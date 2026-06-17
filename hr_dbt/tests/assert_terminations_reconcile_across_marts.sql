-- Cross-mart reconciliation: the total monthly terminations in the headcount
-- time series must equal the count of separated employees in the dimension.
-- Returns a row (failing the test) only if the two totals disagree.

with monthly as (
    select sum(terminations) as total_terminations
    from {{ ref('mart_headcount_monthly') }}
),

dim as (
    select count(*) as separated_employees
    from {{ ref('dim_employee') }}
    where is_terminated
)

select
    monthly.total_terminations,
    dim.separated_employees
from monthly
cross join dim
where monthly.total_terminations <> dim.separated_employees
