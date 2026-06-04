---
title: 4. Pay equity is healthy; raw gap is composition
description: 2.1% raw gap → ~0% within position; the raw gap is representation, not unequal pay
sidebar_position: 4
---

The raw company-wide median pay gap is **2.1% in men's favour** which is well below
typical external benchmarks of 15–20% raw. Within the Production department controlled by
position and tenure, women earn the same as or slightly more than men at the
Technician levels where 86% of Production sits.

```sql raw_gap
select
    sex,
    count(*) as employees,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
group by sex
order by sex
```

<DataTable data={raw_gap}>
    <Column id=sex title="Sex" />
    <Column id=employees title="N" />
    <Column id=median_salary title="Median salary" fmt=usd0 />
</DataTable>

## The composition effect

The raw 2.1% gap arises from representation, not unequal pay. Men are
slightly over-represented in Production Manager (57% of 14) and hold the
single Director of Operations role ($170,500).

```sql position_composition
select
    position,
    count(*) as employees,
    count(*) filter (where sex = 'M') as male_n,
    count(*) filter (where sex = 'F') as female_n,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
where department = 'Production'
group by position
order by employees desc
```

<BarChart
    data={position_composition}
    x=position
    y={['male_n', 'female_n']}
    type=stacked
    swapXY=true
    title="Production headcount by position and sex"
/>

<DataTable data={position_composition}>
    <Column id=position title="Position" />
    <Column id=employees title="N" />
    <Column id=male_n title="Male" />
    <Column id=female_n title="Female" />
    <Column id=median_salary title="Median salary" fmt=usd0 />
</DataTable>

## The controlled view

Within position × tenure × sex, cells with n≥3:

```sql controlled
select
    position,
    tenure_band,
    sex,
    count(*) as employees,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
where department = 'Production'
group by position, tenure_band, sex
having count(*) >= 3
order by position, tenure_band, sex
```

<DataTable data={controlled}>
    <Column id=position title="Position" />
    <Column id=tenure_band title="Tenure" />
    <Column id=sex title="Sex" />
    <Column id=employees title="N" />
    <Column id=median_salary title="Median salary" fmt=usd0 />
</DataTable>

The right framing splits the question into *equity within role* (healthy)
and *representation across roles* (a small skew worth monitoring). Reporting the raw 2.1% gap alone would mislead in both directions.
