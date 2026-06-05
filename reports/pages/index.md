---
description: People analytics on a Kaggle HR dataset
---

<style>
	:global(blockquote.markdown *) {
		color: inherit !important;
	}
</style>

![Workforce Flux](/workforce-flux-header.png)

A deep dive into Company X's headcount, attrition, and pay using an HR dataset. Observing workforce trends, drawing key insights, and making recommendations to leadership.

```sql peak_hc
select max(active_headcount) as peak from workforce_flux.mart_headcount_monthly
```

```sql latest_hc
select active_headcount, rolling_12m_turnover_rate
from workforce_flux.mart_headcount_monthly
where month_start = (select max(month_start) from workforce_flux.mart_headcount_monthly)
```

```sql voluntary_share
select
    count(*) filter (where termination_type = 'Voluntary') * 1.0
        / nullif(count(*) filter (where is_terminated), 0) as share
from workforce_flux.dim_employee
```

<Grid cols=4>
  <BigValue data={peak_hc} value=peak title="Peak headcount (2015)" />
  <BigValue data={latest_hc} value=active_headcount title="Latest headcount (2018)" />
  <BigValue data={latest_hc} value=rolling_12m_turnover_rate fmt=pct1 title="Latest TTM turnover" />
  <BigValue data={voluntary_share} value=share fmt=pct1 title="Voluntary share of exits" />
</Grid>

---

## The big picture
> The company is shrinking through a **[hiring freeze](#1-hiring-freeze-not-attrition-crisis)** rather than an attrition crisis. **Voluntary departures** are concentrated almost entirely in the **[Production department](#2-voluntary-attrition-concentrated-in-production-department)**, which has a structural **[pay-competitiveness gap](#3-pay-inverts-with-tenure-inside-production-department)**. **Pay equity** within roles is **healthy**; the small raw gap is a composition effect.

### 1. Hiring freeze, not attrition crisis

Headcount peaked in mid-2015 and has trended down since. The driver is reduced hiring, not a spike in terminations.

```sql monthly_headcount_overview
select month_start, active_headcount
from workforce_flux.mart_headcount_monthly
order by month_start
```

<LineChart
    data={monthly_headcount_overview}
    x=month_start
    y=active_headcount
    title="Active headcount over time"
    yAxisTitle="Employees"
/>

*[→ See more details about Finding 1](/decline)*

### 2. Voluntary attrition concentrated in Production department

Production is 67% of headcount but accounts for 86% of lifetime voluntary departures.

```sql voluntary_by_dept_overview
select department, voluntary_separations
from workforce_flux.mart_attrition
order by voluntary_separations desc
```

<BarChart
    data={voluntary_by_dept_overview}
    x=department
    y=voluntary_separations
    title="Lifetime voluntary departures by department"
    swapXY=true
    sort=false
/>

*[→ See more details about Finding 2](/production)*

### 3. Pay inverts with tenure inside Production department

Within Production, pay falls with tenure. The newest hires earn meaningfully more than veterans.

```sql production_pay_by_tenure_overview
select
    tenure_band,
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
    data={production_pay_by_tenure_overview}
    x=tenure_band
    y=median_salary
    title="Production median salary by tenure"
    yFmt=usd0
    sort=false
    yMin=50000
    labels=true
/>

*[→ See more details about Finding 3](/pay-gap)*

## Key findings

| # | Finding | Headline number |
|---|---|---|
| 1 | [Hiring freeze, not attrition crisis](/decline) | Annual turnover 3.6–9.9% (low by [BLS 2019 labour-turnover data](https://www.bls.gov/opub/mlr/2020/article/job-openings-hires-and-quits-set-record-highs-in-2019.htm)) |
| 2 | [Voluntary attrition concentrated in Production department](/production) | 86% of voluntary exits from 67% of headcount |
| 3 | [Production has a structural pay-competitiveness gap](/pay-gap) | Stayers earn 12.7% more than leavers at 5–10 yrs tenure |
| 4 | [Pay equity is healthy; raw gap is composition](/pay-equity) | 2.1% raw gap → ~0% within position |

## Recommendations

The single highest-leverage intervention indicated by the analysis is a **market-rate salary review for Production roles at 3+ years of tenure**. This directly addresses the **[pay-competitiveness gap](#3-pay-inverts-with-tenure-inside-production-department)** that drives most voluntary attrition at Company X.

Three supporting interventions:

- **Replace the engagement survey** as a Production retention forecaster. The current instrument fails to detect the dissatisfaction driving exits.
- **Build a merit-pay premium for Production**, since performers who are "Exceeding Expectations" currently earn only marginally more than those that "Fully Meet Expectations".
- **Investigate the Production Manager pay structure** for tenure-based equity concerns (small sample, worth a deliberate look).
