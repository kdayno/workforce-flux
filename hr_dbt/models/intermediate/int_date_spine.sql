-- Intermediate: a monthly calendar spine used to reconstruct point-in-time
-- headcount from the employee snapshot.
--
-- The range is hard-coded: the start is around the company's earliest hires
-- and the end is one month past the analysis_date (2019-01). Widen this range
-- if you change the `analysis_date` var or find earlier hire dates.

with spine as (

    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('2006-01-01' as date)",
        end_date="cast('2019-02-01' as date)"
    ) }}

)

select
    cast(date_month as date)           as month_start,
    last_day(cast(date_month as date)) as month_end,
    extract(year  from date_month)     as calendar_year,
    extract(month from date_month)     as calendar_month
from spine
order by month_start
