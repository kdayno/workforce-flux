-- Mart: how recruitment sources compare on retention, tenure, engagement and
-- performance.
--
-- Per-source sample sizes are small -- always read `total_hires` alongside
-- every rate before drawing a conclusion. `lifetime_separation_rate` carries
-- the same caveat as in mart_attrition (cumulative, not annualised).

with employees as (

    select * from {{ ref('dim_employee') }}

)

select
    recruitment_source,
    count(*)                                          as total_hires,
    count(*) filter (where not is_terminated)         as still_employed,
    round(
        count(*) filter (where is_terminated) * 1.0 / nullif(count(*), 0),
        3
    )                                                 as lifetime_separation_rate,
    round(avg(tenure_years), 1)                       as avg_tenure_years,
    round(avg(engagement_survey_score), 2)            as avg_engagement_score,
    round(
        count(*) filter (where performance_score in ('Exceeds', 'Fully Meets'))
            * 1.0 / nullif(count(*), 0),
        3
    )                                                 as pct_meeting_or_exceeding
from employees
group by recruitment_source
order by total_hires desc
