# Workforce Flux: Full Analysis

This document extends the Key Findings summary in [`README.md`](../README.md) with
the supporting numbers, per-finding caveats, and
recommendation rationale. Read the README first for the headline narrative.

> The subject company is anonymised in the source dataset. This document refers
> to it as **Company X**.

## 1. The headcount decline is a hiring freeze, not a workforce reduction

Headcount peaked at 246 employees in mid-2015 and declined to 207 by the end of
2018. The mechanism is neither layoffs nor an attrition spike: annual terminations
*fell* from 23 (2015) to 8–13 (2017–2018), and ~76% of terminations are voluntary.
Annual turnover peaked at 9.9% (2016), bottomed at 3.6% (2017), and finished at
6.1% (2018), low by [BLS 2019 labour-turnover data](https://www.bls.gov/opub/mlr/2020/article/job-openings-hires-and-quits-set-record-highs-in-2019.htm).
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

## 2. Voluntary attrition concentrated in Production department

Of 86 lifetime voluntary departures, **74 (86%) came from Production**, which
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
is mid-pack, *higher* than Sales (3.82), which has none of these patterns. The
survey instrument is a false-negative indicator for the dissatisfaction that
actually drives Production exits.

*Caveat: Non-Production has only 12 lifetime voluntary exits in total. The
"100% from Production" claim for specific reasons is directionally clear but
statistically modest.*

## 3. Production has a structural pay-competitiveness gap

Three reinforcing patterns explain why Production loses people.

### Pay inverts with tenure

Median Production salary by tenure band. Newer hires earn *more* than veterans,
consistent with hire-date-anchored salaries that have not tracked the market
rate Company X must currently offer:

| Tenure band | N | Median |
|---|---|---|
| < 1 year | 7 | $63,478 |
| 1–2 years | 14 | $64,395 |
| 2–5 years | 89 | $59,472 |
| 5–10 years | 97 | $59,144 |
| 10+ years | 2 | $55,996 |

### Pay and performance are essentially decoupled

Within Production, performers who are "Exceeding Expectations" earn a median of
$60,724 vs. $59,365 for those that "Fully Meet Expectations", only a ~2% premium.
Interestingly, those who "Need Improvement" earn a median of $60,270, essentially
the same as top performers, and *more* than those who "Fully Meet Expectations".
Performance is not financially rewarded:

| Performance | N | Median | Premium vs Fully Meets |
|---|---|---|---|
| Exceeds | 27 | $60,724 | +2.3% |
| Fully Meets | 159 | $59,365 | — |
| Needs Improvement | 15 | $60,270 | +1.5% |
| PIP | 8 | $56,324 | −5.1% |

### Stayers earn more than leavers at the same tenure

Production stayers earn 4% more than voluntary leavers at 2–5 years tenure,
and **12.7% more** at 5–10 years tenure (n=72 stayers vs n=20 leavers,
reasonable samples):

| Tenure band | Status | N | Median |
|---|---|---|---|
| 2–5 years | Voluntary leaver | 34 | $58,323 |
| 2–5 years | Still here | 51 | $60,627 |
| 5–10 years | Voluntary leaver | 20 | $53,372 |
| 5–10 years | Still here | 72 | $60,136 |

*Caveat: Position-mix within Production is not fully controlled in the
tenure-based comparisons. Position-level analysis would refine the magnitudes
without changing the direction.*

## 4. Pay equity is healthy; the raw gap is composition

The raw company-wide median pay gap is **2.1% in men's favour**, already small
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
(healthy) and *representation across roles* (a small skew worth monitoring).
Reporting the raw gap alone would mislead in both directions.

*Caveat: Performance is not controlled in the within-position comparison;
sample sizes shrink below interpretability when adding it. The Production
Manager 5–10 yr cell shows a 19% premium for men but n=3 vs 4; flag for
investigation, not a finding on its own.*

## Recommendations

### Primary: market-rate salary review for Production

The single highest-leverage intervention indicated by the analysis is a
market-rate salary review for Production roles, particularly at 3+ years of
tenure. This would directly address the 11 explicit "more money" voluntary
exits, likely absorb a portion of the 17 "Another position" exits, and remove
the structural mechanism behind regrettable top-performer departures.

*Grounded in Findings 2 and 3.*

### Supporting

- **Replace or augment the engagement survey as a Production retention
  forecaster.** Production employees who voluntarily cite "unhappy" do so
  without first registering as low engagement. The current instrument is a
  known false negative for the dissatisfaction that actually drives Production
  exits. A diagnostic scoped to Production-specific conditions (hours, role,
  supervisor) would surface what the survey misses. *Grounded in Finding 2.*
- **Build a merit-pay premium for Production.** Performers who are "Exceeding
  Expectations" earn only a ~2% premium over those that "Fully Meet
  Expectations", well below the level needed to retain high performers
  against external offers. A meaningful premium would compound with the
  market-rate adjustment to specifically address regrettable attrition.
  *Grounded in Finding 3.*

---

## Methodology: changes applied to the original dataset

The raw Kaggle CSV is transformed in three stages. None of the original data is
discarded silently; every change is listed here.

### 1. Structural cleaning (`stg_employees`)

- **Column renaming.** All columns are renamed from mixed-case (`EmpID`,
  `DateofHire`, `PerfScoreID`) to consistent `snake_case` (`emp_id`,
  `date_of_hire`, `performance_score_id`).
- **Explicit type casting.** The file is read with every column as text
  (`all_varchar = true`) and then cast deliberately: IDs/counts/salary → integers,
  engagement score → double, date strings → real `DATE` types.
- **Whitespace trimming.** Every text column is trimmed; the raw file contains
  trailing spaces (e.g. `Production       `, `M `).
- **Boolean flags.** `0`/`1` integer flags become real booleans:
  `Termd` → `is_terminated`, `FromDiversityJobFairID` → `from_diversity_job_fair`.
- **`HispanicLatino` normalisation.** The raw column mixes `Yes`/`yes`/`No`/`no`;
  it is normalised to a boolean `is_hispanic_latino`.
- **Redundant columns dropped.** Encoded-ID columns that merely duplicate a
  descriptive text column are not carried forward: `MarriedID`, `MaritalStatusID`,
  `GenderID`, `EmpStatusID`.

### 2. Derived fields (`int_employees_enriched`)

New columns that do **not** exist in the source are added:

| New field | Derivation |
|-----------|------------|
| `age_years`, `age_band` | From `DOB` vs. the analysis anchor date |
| `tenure_end_date` | Termination date, or the anchor date if still active |
| `tenure_years`, `tenure_band` | Hire date → `tenure_end_date` |
| `hire_year` | Year component of the hire date |
| `salary_band` | Salary bucketed (`Under $50k` … `$100k+`) |
| `termination_type` | `Voluntary` / `Involuntary`, inferred from `TermReason` |

### 3. Time-series reconstruction (the structural change)

The source is a **point-in-time snapshot**. It cannot answer "how many people
did we have in March 2016?" or "what was turnover in 2017?". Because every row
carries a hire date and (if applicable) a termination date, history can be
*reconstructed*:

- **`int_date_spine`** is a generated monthly calendar (no equivalent in the
  source).
- **`int_headcount_monthly`** cross-joins the date spine with employees,
  producing an **employee-month grain**: for every month, exactly who was on
  payroll. This table has far more rows than the 311-row source.
- **`mart_headcount_monthly`** aggregates that into a monthly series: active
  headcount, hires, terminations, net change, and a **rolling 12-month turnover
  rate**.

This converts a dataset that can only *describe the present* into one that can
*measure change over time*.

## Assumptions

1. **Analysis anchor date = `2019-01-01`.** All "as of" calculations (age,
   tenure, current headcount) are frozen to this date via the `analysis_date`
   dbt var, because the dataset is a 2018–2019 snapshot. Using `current_date`
   would make results drift on every run. Change the var to re-anchor.
2. **Continuous employment.** The source records exactly one hire date and at
   most one termination date per person. The headcount reconstruction therefore
   assumes nobody was rehired, took a leave of absence, or had an employment
   gap.
3. **Voluntary vs. involuntary classification.** `termination_type` maps the
   employer-initiated `TermReason` values (`performance`, `attendance`,
   `gross misconduct`, `no-call, no-show`, `fatal attraction`, and
   `learned that he is a gangster`) to **Involuntary**; every other reason
   (e.g. `more money`, `career change`, `retiring`) is **Voluntary**. This is a
   judgement call; the mapping lives in `int_employees_enriched.sql`. Note the
   dataset contains a couple of joke `TermReason` values, classified above by
   their literal meaning.
4. **Date formats.** Hire/termination/review dates are parsed as `M/D/YYYY` and
   date of birth as `M/D/YY`. Parsing uses `try_strptime`, which yields `NULL`
   (rather than failing the run) on a format mismatch. After the first run,
   check for unexpected `NULL` dates and adjust the formats in
   `stg_employees.sql`.
5. **Two-digit birth years** resolve via DuckDB's `%y` rule (69–99 → 1900s,
   00–68 → 2000s), which is correct for an adult workforce.
6. **Active = employed at month-end.** An employee counts as active in a month
   if hired on/before that month's last day and not terminated as of that day.

## Caveats & limitations

1. **Single snapshot.** Every time-based metric is *reconstructed* from hire and
   termination dates, not observed. It cannot reflect anything those two dates
   do not capture.
2. **Small sample (~311).** Fine-grained segmentation produces tiny cells where
   a percentage is mostly noise. Always read counts next to rates, and be
   cautious past one level of grouping.
3. **Teaching dataset.** This is a well-known instructional dataset; some
   relationships are weak or partly synthetic. Treat findings as method
   practice, not real-world HR conclusions.
4. **"Separation rate" ≠ "turnover rate".** `lifetime_separation_rate` in
   `mart_attrition` / `mart_recruitment_effectiveness` is the share of *everyone
   who has ever worked there* who has since left, cumulative across the
   company's whole history, **not** an annual rate. For a proper annualised
   turnover rate use `rolling_12m_turnover_rate` in `mart_headcount_monthly`.
5. **Pay equity needs confounder control.** A raw salary comparison by gender or
   race is misleading without first controlling for position, department, and
   tenure (Simpson's paradox). This scaffold deliberately does not ship a naive
   pay-gap mart.
