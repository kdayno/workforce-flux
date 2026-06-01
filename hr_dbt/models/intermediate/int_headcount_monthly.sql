-- Intermediate: the time-series reconstruction.
--
-- The date spine is cross-joined with employees to produce an EMPLOYEE-MONTH
-- grain, then aggregated to a monthly active headcount. An employee is "active"
-- in a month if they were hired on or before the month-end and had not been
-- terminated as of that month-end.

with spine as (

    select * from {{ ref('int_date_spine') }}

),

employees as (

    select * from {{ ref('int_employees_enriched') }}

),

-- One row per (employee, month) for every month the employee was on payroll.
employee_months as (

    select
        spine.month_start,
        spine.month_end,
        employees.emp_id,
        employees.department
    from spine
    inner join employees
        on employees.date_of_hire <= spine.month_end
        and (
            employees.date_of_termination is null
            or employees.date_of_termination > spine.month_end
        )

)

select
    month_start,
    month_end,
    count(*) as active_headcount
from employee_months
group by month_start, month_end
order by month_start
