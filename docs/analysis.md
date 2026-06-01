# Workforce Flux — Full Analysis

This document extends the Key Findings summary in [`README.md`](../README.md) with
the supporting numbers, the named case study, per-finding caveats, and
recommendation rationale. Read the README first for the headline narrative.

> The subject company is anonymised in the source dataset. This document refers
> to it as **Company X**.

## 1. The headcount decline is a hiring freeze, not a workforce reduction

Headcount peaked at 229 employees in mid-2015 and declined to 207 by the end of
2018. The mechanism is neither layoffs nor an attrition spike: annual terminations
*fell* from 23 (2015) to 8–13 (2017–2018), and ~76% of terminations are voluntary.
Annual turnover peaked at 9.9% (2016), bottomed at 3.6% (2017), and finished at
6.1% (2018) — *below* typical external benchmarks of 8–12% for stable industries.
Company X is not bleeding people. It has stopped hiring.

| Year | Year-end headcount | Annual hires | Annual terminations | TTM turnover |
|---|---|---|---|---|
| 2014 | 216 | — | 13 | 6.7% |
| 2015 | 229 | — | 23 | 9.6% |
| 2016 | 221 | — | 22 | 9.9% |
| 2017 | 219 | — | 8 | 3.6% |
| 2018 | 207 | — | 13 | 6.1% |

*Caveat: The trailing-12-month turnover rate combines voluntary and involuntary
terminations. Voluntary-only rates sit at roughly ¾ of the reported values.*

## 2. Voluntary attrition is concentrated in Production

Of 86 lifetime voluntary departures, **74 (86%) came from Production** — which
makes up 67% of all employees ever hired. Production's lifetime voluntary rate
(35%) is 3–4× higher than the next-largest departments (IT/IS 10%, Sales 10%).

| Department | Total ever | Voluntary | Involuntary | Vol. rate | Avg engagement |
|---|---|---|---|---|---|
| Production | 209 | 74 | 9 | 35.4% | 4.13 |
| Software Engineering | 11 | 3 | 1 | 27.3% | 4.06 |
| Admin Offices | 9 | 1 | 1 | 11.1% | 4.39 |
| IT/IS | 50 | 5 | 5 | 10.0% | 4.15 |
| Sales | 31 | 3 | 2 | 9.7% | 3.82 |
| Executive Office | 1 | 0 | 0 | 0% | 4.83 |

The asymmetry is sharper at the reason level: **every "unhappy" and every
"more money" voluntary exit in the data is from Production** (14 of 14 and 11
of 11 respectively).

The engagement survey does not detect this. Production's average engagement (4.13)
is mid-pack — *higher* than Sales (3.82), which has none of these patterns. The
survey instrument is a false-negative indicator for the dissatisfaction that
actually drives Production exits.

*Caveat: Non-Production has only 12 lifetime voluntary exits in total — the
"100% from Production" claim for specific reasons is directionally clear but
statistically modest.*

## 3. Production has a structural pay-competitiveness gap

Three reinforcing patterns explain why Production loses people.

### Pay inverts with tenure

Median Production salary by tenure band — newer hires earn *more* than veterans,
consistent with hire-date-anchored salaries that have not tracked the market
rate Company X must currently offer:

| Tenure band | N | Median |
|---|---|---|
| < 1 year | 7 | $63,478 |
| 1–2 years | 14 | $64,395 |
| 2–5 years | 89 | $59,472 |
| 5–10 years | 97 | $59,144 |
| 10+ years | 2 | $55,996 |

### No meaningful merit-pay structure

Within Production, top performers (Exceeds) earn ~2% more than median performers
at the median. Performance is not financially rewarded:

| Performance | N | Median | Premium vs Fully Meets |
|---|---|---|---|
| Exceeds | 27 | $60,724 | +2.3% |
| Fully Meets | 159 | $59,365 | — |
| Needs Improvement | 15 | $60,270 | +1.5% |
| PIP | 8 | $56,324 | −5.1% |

### Leavers earned less than stayers at the same tenure

Production voluntary leavers earned 4% less than stayers at 2–5 years tenure,
and **12.7% less** at 5–10 years tenure (n=20 leavers vs n=72 stayers —
reasonable samples):

| Tenure band | Status | N | Median |
|---|---|---|---|
| 2–5 years | Voluntary leaver | 34 | $58,323 |
| 2–5 years | Still here | 51 | $60,627 |
| 5–10 years | Voluntary leaver | 20 | $53,372 |
| 5–10 years | Still here | 72 | $60,136 |

### Named case study — the 6 lifetime regrettable Production departures

The 6 voluntary departures of Production top performers (Exceeds) over the
company's history:

| Employee | Reason | Tenure | Hire yr | Salary | Engagement |
|---|---|---|---|---|---|
| Peters, Lauren | more money | 1 | 2011 | $57,954 | 4.2 |
| Squatrito, Kristen | unhappy | 2 | 2013 | $62,425 | 4.1 |
| **Lynch, Lindsay** | **Another position** | **4** | **2011** | **$47,434** | **5.0** |
| Veera, Abdellah | maternity (DNR) | 3 | 2012 | $58,523 | 4.5 |
| Winthrop, Jordan | retiring | 3 | 2013 | $70,507 | 5.0 |
| Johnson, George | more money | 6 | 2011 | $46,837 | 4.7 |

Of the 4 actionable cases (excluding life-stage exits), 3 cite pay or pay-implicating
reasons. **The Lynch row is the single most decision-useful row in the analysis.**
Engagement 5.0 (maximum), top performer, 4 years of tenure, salary in the bottom
quartile of Production — Lynch wasn't disengaged or unhappy. She just got a
better offer. The only difference between her and Winthrop (same engagement,
$23K higher salary, stayed until retirement) was pay.

*Caveat: Position-mix within Production is not fully controlled in the
tenure-based comparisons. Position-level analysis would refine the magnitudes
without changing the direction.*

## 4. Pay equity is healthy; the raw gap is composition

The raw company-wide median pay gap is **2.1% in men's favour** — already small
by external benchmarks (typically 15–20% raw). Within Production, controlled by
position and tenure band, **women earn the same as or slightly more than men**
at Production Technician I and II levels, where 86% of the Production workforce
sits:

| Position | Tenure | F median | M median | Gap (M premium) |
|---|---|---|---|---|
| Production Technician I | 2–5 yrs | $57,748 (n=35) | $52,846 (n=23) | −$4,902 (F earns more) |
| Production Technician I | 5–10 yrs | $55,882 (n=44) | $56,649 (n=28) | +$767 (≈0) |
| Production Technician II | 2–5 yrs | $65,902 (n=19) | $66,217 (n=8) | +$315 (≈0) |
| Production Technician II | 5–10 yrs | $66,441 (n=9) | $62,806 (n=8) | −$3,635 (F earns more) |
| Production Manager | 5–10 yrs | $70,192 (n=4) | $83,667 (n=3) | +$13,475 (+19%) |

The 2.1% raw gap arises from representation: men are slightly over-represented
in Production Manager (57% of 14) and hold the single Director of Operations
role ($170,500). The right framing splits the question into *equity within role*
(healthy) and *representation across roles* (a small skew worth monitoring) —
reporting the raw gap alone would mislead in both directions.

*Caveat: Performance is not controlled in the within-position comparison;
sample sizes shrink below interpretability when adding it. The Production
Manager 5–10 yr cell shows a 19% premium for men but n=3 vs 4 — flag for
investigation, not a finding on its own.*

## Recommendations

### Primary — market-rate salary review for Production

The single highest-leverage intervention indicated by the analysis is a
market-rate salary review for Production roles, particularly at 3+ years of
tenure. This would directly address the 11 explicit "more money" voluntary
exits, likely absorb a portion of the 17 "Another position" exits, and remove
the structural mechanism behind the Lynch-type regrettable departures.

*Grounded in Findings 2 and 3.*

### Supporting

- **Replace or augment the engagement survey as a Production retention
  forecaster.** Production employees who voluntarily cite "unhappy" do so
  without first registering as low engagement — the current instrument is a
  known false negative for the dissatisfaction that actually drives Production
  exits. A diagnostic scoped to Production-specific conditions (hours, role,
  supervisor) would surface what the survey misses. *Grounded in Finding 2.*
- **Build a merit-pay premium for Production.** Top performers (Exceeds) earn
  only ~2% more than median performers at the median — well below the level
  needed to retain high performers against external offers. A meaningful
  premium would compound with the market-rate adjustment to specifically
  address regrettable attrition. *Grounded in Finding 3.*
- **Investigate the Production Manager 5–10 year pay cell from Finding 4.**
  Men in this cell earn 19% more than women on n=3 vs 4 — too small to call
  a finding, large enough to warrant a deliberate look. A targeted pull of
  position changes, raise history, and starting salaries for these 7
  employees would either rule it in or out as a real gap. *Grounded in
  Finding 4.*
