-- Active employees must not carry a termination date (and vice versa).
-- Returns offending rows; the test passes only when none exist.

select emp_id, is_terminated, date_of_termination
from {{ ref('dim_employee') }}
where (not is_terminated and date_of_termination is not null)
   or (is_terminated and date_of_termination is null)
