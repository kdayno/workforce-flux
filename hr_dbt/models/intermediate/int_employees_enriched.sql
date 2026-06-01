-- Intermediate: adds the derived analytical fields that the marts and reports
-- rely on but that do not exist in the raw data -- age, tenure, banded
-- categories, and a voluntary/involuntary classification of terminations.

with employees as (

    select * from {{ ref('stg_employees') }}

),

enriched as (

    select
        employees.*,

        -- Tenure runs from hire to termination, or to the analysis anchor
        -- date for employees who are still active.
        coalesce(
            date_of_termination,
            cast('{{ var("analysis_date") }}' as date)
        ) as tenure_end_date,

        floor(
            date_diff(
                'day',
                date_of_hire,
                coalesce(
                    date_of_termination,
                    cast('{{ var("analysis_date") }}' as date)
                )
            ) / 365.25
        ) as tenure_years,

        -- Age as of the analysis anchor date (approximate -- ignores the
        -- exact birthday within the year).
        floor(
            date_diff(
                'day',
                date_of_birth,
                cast('{{ var("analysis_date") }}' as date)
            ) / 365.25
        ) as age_years,

        extract(year from date_of_hire) as hire_year,

        -- Voluntary vs. involuntary is inferred from TermReason. See README
        -- "Assumptions" -- this mapping is a judgement call.
        case
            when not is_terminated then null
            when lower(term_reason) in (
                'performance', 'attendance', 'gross misconduct',
                'no-call, no-show', 'fatal attraction',
                'learned that he is a gangster'
            ) then 'Involuntary'
            else 'Voluntary'
        end as termination_type

    from employees

)

select
    enriched.*,

    case
        when tenure_years < 1  then '< 1 year'
        when tenure_years < 2  then '1-2 years'
        when tenure_years < 5  then '2-5 years'
        when tenure_years < 10 then '5-10 years'
        else '10+ years'
    end as tenure_band,

    case
        when age_years < 30 then 'Under 30'
        when age_years < 40 then '30-39'
        when age_years < 50 then '40-49'
        else '50+'
    end as age_band,

    case
        when salary < 50000  then 'Under $50k'
        when salary < 75000  then '$50k-$75k'
        when salary < 100000 then '$75k-$100k'
        else '$100k+'
    end as salary_band

from enriched
