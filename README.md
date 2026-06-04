![Workforce Flux Header Image](./docs/workforce-flux-header.png) 

- An end-to-end analysis of workforce data that turns a raw HR dataset into decision-useful insight on headcount trends, attrition, retention, and recruitment effectiveness 
- The analysis is delivered through a modern, file-based analytics stack — DuckDB for storage, dbt for transformation, and Evidence for reporting.

## Objectives

1. **Surface decision-useful HR insight.** Quantify workforce dynamics —
   headcount growth, annualised turnover, attrition drivers, and the
   effectiveness of recruitment channels — and translate the findings into
   recommended actions.
2. **Apply analytics-engineering best practice.** Transform raw, inconsistent
   source data into clean, tested, and documented analytical models through a
   layered ELT pipeline and dimensional modelling.
3. **Demonstrate analytical rigour.** Define HR metrics correctly (for example,
   annualised versus cumulative turnover), segment responsibly given the sample
   size, and state every assumption and limitation transparently.

## Key findings

| # | Finding | Headline number |
|---|---|---|
| 1 | Hiring freeze, not attrition crisis | Annual turnover 3.6–9.9% (low by [BLS 2019 labour-turnover data](https://www.bls.gov/opub/mlr/2020/article/job-openings-hires-and-quits-set-record-highs-in-2019.htm)) |
| 2 | Voluntary attrition concentrated in Production department | 86% of voluntary exits from 67% of headcount |
| 3 | Production has a structural pay-competitiveness gap | Stayers earn 12.7% more than leavers at 5–10 yrs tenure |
| 4 | Pay equity is healthy; raw gap is composition | 2.1% raw gap → ~0% within position |

> **Full analysis** — per-finding tables and caveats:
> [`docs/full-analysis.md`](docs/full-analysis.md). The subject company is anonymised in
> the source dataset; this README refers to it as **Company X**.

### 1. The headcount decline is a hiring freeze, not a workforce reduction

- Headcount peaked at **246** in mid-2015, declined to **207** by end-2018
- Annual terminations *fell* from 23 (2015) to 8–13 (2017–2018); ~76% are voluntary
- Annual turnover **3.6–9.9%** — low by [BLS 2019 labour-turnover data](https://www.bls.gov/opub/mlr/2020/article/job-openings-hires-and-quits-set-record-highs-in-2019.htm)
- Mechanism: hiring stopped, not terminations spiked

### 2. Voluntary attrition concentrated in Production department

- **86% of lifetime voluntary departures** (74 of 86) came from Production, which is 67% of headcount
- Production's lifetime voluntary rate (35%) is **3–4× higher** than IT/IS (10%) or Sales (10%)
- **Every** "unhappy" (14 of 14) and **every** "more money" (11 of 11) voluntary exit is from Production
- The engagement survey doesn't detect it — Production's avg engagement (4.13) is mid-pack

### 3. Production has a structural pay-competitiveness gap

- **Pay inverts with tenure** — Production median by band: ~$64K (<2 yrs) → $59K (2–10 yrs) → $56K (10+ yrs)
- **Pay and performance are essentially decoupled** — performers who are "Exceeding Expectations" earn a median of ~$61K vs. ~$59K for those that "Fully Meet Expectations" (~2% premium); interestingly, those who "Need Improvement" earn ~$60K — *more* than those who "Fully Meet Expectations"
- **Stayers earn more than leavers at the same tenure** — 4% gap at 2–5 yrs, **12.7% gap** at 5–10 yrs (n=72 stayers vs 20 leavers)

### 4. Pay equity is healthy; the raw gap is composition

- Raw company-wide median pay gap is **2.1% in men's favour** — well below typical external benchmarks (15–20% raw)
- Within Production controlled by position and tenure, **women earn the same as or slightly more than men** at the Technician levels (86% of Production)
- The raw gap is a composition effect — men over-represented in Production Manager (57% of 14); the single Director of Operations is male ($170.5K)

## Recommendations

The single highest-leverage intervention indicated by the analysis is a
**market-rate salary review for Production roles at 3+ years of tenure** —
this would directly address the 11 explicit "more money" voluntary exits and
likely absorb a portion of the 17 "Another position" exits.

Three supporting recommendations — engagement-survey replacement, a merit-pay
premium for Production, and an investigation of the Production Manager 5–10 yr
pay cell — are detailed in [`docs/full-analysis.md#recommendations`](docs/full-analysis.md#recommendations).

## Tech stack

| Layer | Tool | Role |
|-------|------|------|
| Storage | [DuckDB](https://duckdb.org) | Embedded analytical database |
| Transformation | [dbt](https://www.getdbt.com) (`dbt-duckdb`) | Tested, layered SQL models |
| Visualisation | [Evidence](https://evidence.dev) | BI-as-code reports |

## Data source

[Human Resources Data Set](https://www.kaggle.com/datasets/rhuebner/human-resources-data-set)
by Dr. Rich Huebner & Dr. Carla Patalano (Kaggle). A single CSV,
`HRDataset_v14.csv` — **~311 employees, 36 columns**, one row per employee.

The raw file is **not committed** (see `.gitignore`). Download it from Kaggle
(a free account is required) and place it at:

```
data/raw/HRDataset_v14.csv
```

## Project structure

```
workforce-flux/
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   └── raw/                  # HRDataset_v14.csv goes here (not committed)
├── docs/
│   └── full-analysis.md           # Full per-finding analysis (tables, caveats)
├── eda/                      # Exploratory data analysis (SQL, run against hr.duckdb)
│   ├── 01_decline_diagnosis.sql
│   ├── 02_retention.sql
│   ├── 03_exit_reasons.sql
│   └── 04_compensation_equity.sql
├── hr_dbt/                   # dbt project
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── packages.yml
│   └── models/
│       ├── staging/
│       │   ├── stg_employees.sql
│       │   └── _staging.yml
│       ├── intermediate/
│       │   ├── int_employees_enriched.sql
│       │   ├── int_date_spine.sql
│       │   └── int_headcount_monthly.sql
│       └── marts/
│           ├── dim_employee.sql
│           ├── mart_headcount_monthly.sql
│           ├── mart_attrition.sql
│           ├── mart_recruitment_effectiveness.sql
│           └── _marts.yml
├── reports/                  # Evidence project (initialised later)
└── hr.duckdb                 # created by dbt (not committed)
```

## Setup

```bash
# 1. Python environment
# NOTE: dbt does not yet support Python 3.14 (its mashumaro dependency fails
# to import). Use Python 3.13 or earlier.
python3.13 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 2. Download HRDataset_v14.csv from Kaggle into data/raw/

# 3. Build the pipeline (run dbt from inside hr_dbt/)
cd hr_dbt
dbt deps                              # installs dbt_utils
dbt build --profiles-dir .            # runs models + tests
```

`profiles.yml` lives inside the project, so dbt needs `--profiles-dir .` (or
`export DBT_PROFILES_DIR=$(pwd)`). All "as of" calculations are anchored to the
`analysis_date` var — see **Assumptions** below.

## Pipeline / data model

```
HRDataset_v14.csv
└─ stg_employees ................. clean + type-cast, 1 row per employee
   └─ int_employees_enriched ..... + derived fields (age, tenure, bands…)
      ├─ dim_employee ............ employee dimension
      ├─ mart_attrition .......... department-level separation summary
      ├─ mart_recruitment_effectiveness
      └─ int_headcount_monthly ... employee-month grain (uses int_date_spine)
         └─ mart_headcount_monthly  monthly time series + turnover rate
```

Layer materialisation: staging & intermediate are **views**, marts are **tables**.

---

## Changes applied to the original dataset

The raw Kaggle CSV is transformed in three stages. None of the original data is
discarded silently — every change is listed here.

### 1. Structural cleaning (`stg_employees`)

- **Column renaming** — all columns are renamed from mixed-case (`EmpID`,
  `DateofHire`, `PerfScoreID`) to consistent `snake_case` (`emp_id`,
  `date_of_hire`, `performance_score_id`).
- **Explicit type casting** — the file is read with every column as text
  (`all_varchar = true`) and then cast deliberately: IDs/counts/salary → integers,
  engagement score → double, date strings → real `DATE` types.
- **Whitespace trimming** — every text column is trimmed; the raw file contains
  trailing spaces (e.g. `Production       `, `M `).
- **Boolean flags** — `0`/`1` integer flags become real booleans:
  `Termd` → `is_terminated`, `FromDiversityJobFairID` → `from_diversity_job_fair`.
- **`HispanicLatino` normalisation** — the raw column mixes `Yes`/`yes`/`No`/`no`;
  it is normalised to a boolean `is_hispanic_latino`.
- **Redundant columns dropped** — encoded-ID columns that merely duplicate a
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

The source is a **point-in-time snapshot** — it cannot answer "how many people
did we have in March 2016?" or "what was turnover in 2017?". Because every row
carries a hire date and (if applicable) a termination date, history can be
*reconstructed*:

- **`int_date_spine`** — a generated monthly calendar (no equivalent in the
  source).
- **`int_headcount_monthly`** — the date spine is cross-joined with employees,
  producing an **employee-month grain**: for every month, exactly who was on
  payroll. This table has far more rows than the 311-row source.
- **`mart_headcount_monthly`** — aggregates that into a monthly series: active
  headcount, hires, terminations, net change, and a **rolling 12-month turnover
  rate**.

This converts a dataset that can only *describe the present* into one that can
*measure change over time*.

---

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
   employer-initiated `TermReason` values — `performance`, `attendance`,
   `gross misconduct`, `no-call, no-show`, `fatal attraction`, and
   `learned that he is a gangster` — to **Involuntary**; every other reason
   (e.g. `more money`, `career change`, `retiring`) is **Voluntary**. This is a
   judgement call; the mapping lives in `int_employees_enriched.sql`. Note the
   dataset contains a couple of joke `TermReason` values, classified above by
   their literal meaning.
4. **Date formats.** Hire/termination/review dates are parsed as `M/D/YYYY` and
   date of birth as `M/D/YY`. Parsing uses `try_strptime`, which yields `NULL`
   (rather than failing the run) on a format mismatch — after the first run,
   check for unexpected `NULL` dates and adjust the formats in
   `stg_employees.sql`.
5. **Two-digit birth years** resolve via DuckDB's `%y` rule (69–99 → 1900s,
   00–68 → 2000s), which is correct for an adult workforce.
6. **Active = employed at month-end.** An employee counts as active in a month
   if hired on/before that month's last day and not terminated as of that day.

## Caveats & limitations

1. **Single snapshot.** Every time-based metric is *reconstructed* from hire and
   termination dates, not observed — it cannot reflect anything those two dates
   do not capture.
2. **Small sample (~311).** Fine-grained segmentation produces tiny cells where
   a percentage is mostly noise. Always read counts next to rates, and be
   cautious past one level of grouping.
3. **Teaching dataset.** This is a well-known instructional dataset; some
   relationships are weak or partly synthetic. Treat findings as method
   practice, not real-world HR conclusions.
4. **"Separation rate" ≠ "turnover rate".** `lifetime_separation_rate` in
   `mart_attrition` / `mart_recruitment_effectiveness` is the share of *everyone
   who has ever worked there* who has since left — cumulative across the
   company's whole history, **not** an annual rate. For a proper annualised
   turnover rate use `rolling_12m_turnover_rate` in `mart_headcount_monthly`.
5. **Pay equity needs confounder control.** A raw salary comparison by gender or
   race is misleading without first controlling for position, department, and
   tenure (Simpson's paradox). This scaffold deliberately does not ship a naive
   pay-gap mart.

## Next steps

- Add `mart_compensation` (with the confounder caveat above) and
  `mart_engagement`.
- Initialise the Evidence project in `reports/` (`npm create evidence@latest`)
  and point its DuckDB connector at the marts.
- **Decouple dbt and Evidence** to avoid DuckDB's single-writer lock: materialise
  the marts as Parquet and have Evidence read those, rather than both processes
  opening `hr.duckdb` at once.
