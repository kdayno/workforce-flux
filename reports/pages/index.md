---
title: Workforce Flux
description: People analytics on the Kaggle HR dataset (Company X — synthetic)
---

People analytics on a 311-employee HR snapshot, reconstructed into a monthly
time series. Four findings, each on its own page.

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
    round(count(*) filter (where termination_type = 'Voluntary') * 100.0
          / nullif(count(*) filter (where is_terminated), 0), 1) as voluntary_pct
from workforce_flux.dim_employee
```

<Grid cols=4>
  <BigValue data={peak_hc} value=peak title="Peak headcount (2015)" />
  <BigValue data={latest_hc} value=active_headcount title="Latest headcount (2018)" />
  <BigValue data={latest_hc} value=rolling_12m_turnover_rate fmt=pct1 title="Latest TTM turnover" />
  <BigValue data={voluntary_share} value=voluntary_pct fmt=num1 title="Voluntary share of exits" />
</Grid>

## The diagnosis

**Company X is shrinking by design** — through a hiring freeze, not an
attrition crisis. The voluntary departures it does experience are
**concentrated almost entirely in Production**, which has a structural
**pay-competitiveness gap**. Pay equity within roles is healthy; the small
raw gap is a composition effect.

## Findings

- [**1. Hiring freeze, not attrition crisis**](/decline) — Annual turnover 3.6–9.9% (below external benchmarks)
- [**2. Voluntary attrition concentrated in Production**](/production) — 86% of voluntary exits from 67% of headcount
- [**3. Production has a structural pay-competitiveness gap**](/pay-gap) — Leavers earned 12.7% less than stayers at 5–10 yrs tenure
- [**4. Pay equity is healthy; raw gap is composition**](/pay-equity) — 2.1% raw gap → ~0% within position
