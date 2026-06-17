{#
  Generic test: a termination date, when present, must not predate the hire
  date. Returns the offending rows -- the test fails if any are found.
#}
{% test termination_after_hire(model, hire_column, termination_column) %}

select *
from {{ model }}
where {{ termination_column }} is not null
  and {{ termination_column }} < {{ hire_column }}

{% endtest %}
