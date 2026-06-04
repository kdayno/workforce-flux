---
title: 3. Production has a structural pay-competitiveness gap
description: Pay inverts with tenure, no merit premium, and stayers earn 12.7% more than leavers
sidebar_position: 3
---

Three reinforcing patterns explain why Production loses people.

## Pay inverts with tenure

Newer hires earn more than veterans — consistent with hire-date-anchored
salaries that have not tracked the market rate Company X must currently offer.

```sql pay_by_tenure
select
    tenure_band,
    count(*) as employees,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
where department = 'Production'
group by tenure_band
order by
    case tenure_band
        when '< 1 year'    then 1
        when '1-2 years'   then 2
        when '2-5 years'   then 3
        when '5-10 years'  then 4
        else 5
    end
```

<BarChart
    data={pay_by_tenure}
    x=tenure_band
    y=median_salary
    title="Production median salary by tenure band"
    yFmt=usd0
    sort=false
    yMin=50000
    labels=true
/>

## No merit-pay structure

Top performers earn only ~2% more than median performers at the median.

```sql pay_by_perf
select
    performance_score,
    count(*) as employees,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
where department = 'Production'
group by performance_score
order by
    case performance_score
        when 'Exceeds'           then 1
        when 'Fully Meets'       then 2
        when 'Needs Improvement' then 3
        when 'PIP'               then 4
    end
```

<BarChart
    data={pay_by_perf}
    x=performance_score
    y=median_salary
    title="Production median salary by performance band"
    yFmt=usd0
    sort=false
    yMin=50000
    labels=true
/>

## Stayers earn more than leavers at the same tenure

Production employees who stay earn 4% more than employees who voluntary leave at 2–5 years of tenure, and **12.7% more** at 5–10 years (n=72 stayers vs 20 leavers).

```sql stayers_vs_leavers
select
    tenure_band,
    case
        when not is_terminated              then 'Still here'
        when termination_type = 'Voluntary' then 'Voluntary leaver'
    end as status,
    count(*) as employees,
    round(quantile_cont(salary, 0.5)) as median_salary
from workforce_flux.dim_employee
where department = 'Production'
  and (not is_terminated or termination_type = 'Voluntary')
group by tenure_band, status
order by
    case tenure_band
        when '< 1 year'   then 1
        when '1-2 years'  then 2
        when '2-5 years'  then 3
        when '5-10 years' then 4
        else 5
    end,
    status desc
```

<DataTable data={stayers_vs_leavers}>
    <Column id=tenure_band title="Tenure" />
    <Column id=status />
    <Column id=employees title="N" />
    <Column id=median_salary title="Median salary" fmt=usd0 />
</DataTable>
