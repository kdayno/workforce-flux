-- Department-level component checks on mart_attrition:
--   active + separated must equal total, and
--   voluntary + involuntary must equal separated.
-- Returns any department where either identity is violated.

select
    department,
    total_employees,
    active_employees,
    separated_employees,
    voluntary_separations,
    involuntary_separations
from {{ ref('mart_attrition') }}
where active_employees + separated_employees <> total_employees
   or voluntary_separations + involuntary_separations <> separated_employees
