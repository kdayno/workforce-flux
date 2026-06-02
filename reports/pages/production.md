---
title: 2. Voluntary attrition concentrated in Production
description: 86% of voluntary departures come from one department
---

74 of 86 lifetime voluntary departures (86%) came from Production, which makes
up 67% of headcount. Production's lifetime voluntary rate (35%) is 3–4× higher
than IT/IS (10%) or Sales (10%).

```sql attrition_by_dept
select
    department,
    total_employees,
    voluntary_separations,
    involuntary_separations,
    round(voluntary_separations * 1.0 / nullif(total_employees, 0), 3) as voluntary_rate,
    avg_engagement_score
from workforce_flux.mart_attrition
order by voluntary_separations desc
```

<BarChart
    data={attrition_by_dept}
    x=department
    y=voluntary_separations
    title="Voluntary departures by department (lifetime)"
    swapXY=true
/>

<DataTable data={attrition_by_dept} rows=10>
    <Column id=department />
    <Column id=total_employees title="Total ever" />
    <Column id=voluntary_separations title="Voluntary" />
    <Column id=involuntary_separations title="Involuntary" />
    <Column id=voluntary_rate title="Vol. rate" fmt=pct1 />
    <Column id=avg_engagement_score title="Avg engagement" fmt=num2 />
</DataTable>

## The signal at the reason level

Every "unhappy" and every "more money" voluntary exit in the dataset is from
Production — 14 of 14 and 11 of 11 respectively.

```sql reason_by_dept
select
    term_reason,
    count(*) filter (where department = 'Production') as production,
    count(*) filter (where department <> 'Production') as non_production,
    count(*) as total
from workforce_flux.dim_employee
where termination_type = 'Voluntary'
group by term_reason
order by total desc
```

<BarChart
    data={reason_by_dept}
    x=term_reason
    y={['production', 'non_production']}
    type=stacked
    title="Voluntary exit reasons — Production vs non-Production"
    swapXY=true
/>

## The engagement-survey blind spot

Production's average engagement (4.13) is *higher* than Sales (3.82), which
has none of these voluntary patterns. The engagement instrument is a known
false negative for the dissatisfaction that drives Production exits.
