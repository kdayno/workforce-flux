-- Mart: department-level separation summary.
--
-- NOTE: `lifetime_separation_rate` is the share of *all employees who have ever
-- worked in the department* who have since left. It is a cumulative figure
-- across the company's whole history, NOT an annual turnover rate -- use
-- mart_headcount_monthly.rolling_12m_turnover_rate for time-based turnover.

with employees as (

    select * from {{ ref('dim_employee') }}

)

select
    department,
    count(*)                                                 as total_employees,
    count(*) filter (where not is_terminated)                as active_employees,
    count(*) filter (where is_terminated)                    as separated_employees,
    count(*) filter (where termination_type = 'Voluntary')   as voluntary_separations,
    count(*) filter (where termination_type = 'Involuntary') as involuntary_separations,
    round(
        count(*) filter (where is_terminated) * 1.0 / nullif(count(*), 0),
        3
    )                                                        as lifetime_separation_rate,
    round(avg(tenure_years), 1)                              as avg_tenure_years,
    round(avg(engagement_survey_score), 2)                   as avg_engagement_score
from employees
group by department
order by total_employees desc
