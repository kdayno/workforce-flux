---
title: 1. Hiring freeze, not attrition crisis
description: Company X's headcount decline is driven by hires falling, not terminations rising
sidebar_position: 1
---

Headcount peaked at 246 in mid-2015 and declined to 207 by end-2018. The
mechanism is neither layoffs nor an attrition spike: annual terminations
*fell* from 23 (2015) to 8–13 (2017–2018). Annual turnover (3.6–9.9%) sits low by [BLS 2019 labour-turnover data](https://www.bls.gov/opub/mlr/2020/article/job-openings-hires-and-quits-set-record-highs-in-2019.htm).

```sql monthly_headcount
select month_start, active_headcount
from workforce_flux.mart_headcount_monthly
order by month_start
```

<LineChart
    data={monthly_headcount}
    x=month_start
    y=active_headcount
    title="Active headcount over time"
    yAxisTitle="Employees"
/>

```sql annual_flow_long
select calendar_year, 'hires' as metric, sum(hires) as count
from workforce_flux.mart_headcount_monthly
where calendar_year between 2011 and 2018
group by calendar_year
union all
select calendar_year, 'terminations' as metric, sum(terminations) as count
from workforce_flux.mart_headcount_monthly
where calendar_year between 2011 and 2018
group by calendar_year
order by calendar_year, metric
```

<BarChart
    data={annual_flow_long}
    x=calendar_year
    y=count
    series=metric
    type=grouped
    title="Annual hires vs terminations"
/>

```sql turnover_trend
select
    extract(year from month_start) as year,
    extract(month from month_start) as month,
    month_start,
    rolling_12m_turnover_rate
from workforce_flux.mart_headcount_monthly
where month_start between date '2014-01-01' and date '2018-12-31'
order by month_start
```

<LineChart
    data={turnover_trend}
    x=month_start
    y=rolling_12m_turnover_rate
    yFmt=pct1
    title="Trailing-12-month turnover rate"
    yAxisTitle="Turnover (TTM)"
/>

## The mechanism

Three hypotheses for the net-negative trend, distinguished by the
voluntary/involuntary split:

- **Layoffs** would show an involuntary spike
- **Voluntary attrition surge** would show voluntary climb
- **Hiring freeze** would show both flat or falling — net loss from hires falling faster

The data fits the third.

```sql term_split
select
    extract(year from date_of_termination) as year,
    termination_type,
    count(*) as terminations
from workforce_flux.dim_employee
where is_terminated
  and date_of_termination >= date '2014-01-01'
group by year, termination_type
order by year, termination_type
```

<BarChart
    data={term_split}
    x=year
    y=terminations
    series=termination_type
    type=grouped
    title="Voluntary vs involuntary terminations (2014–2018)"
/>
