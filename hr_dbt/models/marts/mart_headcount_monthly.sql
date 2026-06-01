-- Mart: monthly workforce time series.
--
-- For each month: active headcount, hires, terminations, net change, and a
-- trailing-12-month (TTM) turnover rate. This is the model that turns a
-- point-in-time snapshot into a measure of change over time.

with spine as (

    select * from {{ ref('int_date_spine') }}

),

headcount as (

    select * from {{ ref('int_headcount_monthly') }}

),

employees as (

    select * from {{ ref('int_employees_enriched') }}

),

hires as (

    select
        date_trunc('month', date_of_hire)::date as month_start,
        count(*)                                as hires
    from employees
    where date_of_hire is not null
    group by 1

),

terminations as (

    select
        date_trunc('month', date_of_termination)::date as month_start,
        count(*)                                       as terminations
    from employees
    where date_of_termination is not null
    group by 1

),

monthly as (

    select
        spine.month_start,
        spine.calendar_year,
        coalesce(headcount.active_headcount, 0) as active_headcount,
        coalesce(hires.hires, 0)                as hires,
        coalesce(terminations.terminations, 0)  as terminations
    from spine
    left join headcount    on headcount.month_start    = spine.month_start
    left join hires        on hires.month_start        = spine.month_start
    left join terminations on terminations.month_start = spine.month_start

)

select
    month_start,
    calendar_year,
    active_headcount,
    hires,
    terminations,
    hires - terminations as net_headcount_change,

    -- TTM turnover = separations over the last 12 months divided by average
    -- headcount over the same window. This is the correct annualised turnover
    -- rate (see README caveats). The first 11 months use a partial window.
    sum(terminations)           over trailing_12m       as separations_ttm,
    round(avg(active_headcount) over trailing_12m, 1)    as avg_headcount_ttm,
    round(
        sum(terminations) over trailing_12m
        / nullif(avg(active_headcount) over trailing_12m, 0),
        3
    )                                                    as rolling_12m_turnover_rate

from monthly
window trailing_12m as (
    order by month_start
    rows between 11 preceding and current row
)
order by month_start
