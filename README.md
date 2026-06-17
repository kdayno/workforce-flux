![Workforce Flux Header Image](./docs/workforce-flux-header.png) 

- An end-to-end People Analytics project: a raw HR dataset (sourced from [Kaggle](#data-source)) transformed into decision-useful insight on headcount, attrition, and pay.
- File-based analytics stack (DuckDB + dbt + Evidence), deployed as a static Vercel site.

> 🔗 Live demo: [workforceflux.kdayno.com](https://workforceflux.kdayno.com)

## Objectives

1. **Surface decision-useful HR insight.** Quantify workforce dynamics
   (headcount growth, annualised turnover, attrition drivers, and the
   effectiveness of recruitment channels), and translate the findings into
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

> **Full analysis.** Per-finding tables, methodology, assumptions, and caveats:
> [`docs/full-analysis.md`](docs/full-analysis.md). The subject company is anonymised in
> the source dataset; this README refers to it as **Company X**.

## Recommendations

The single highest-leverage intervention indicated by the analysis is a
**market-rate salary review for Production roles at 3+ years of tenure**.
This would directly address the 11 explicit "more money" voluntary exits and
likely absorb a portion of the 17 "Another position" exits.

Two supporting recommendations (engagement-survey replacement and a merit-pay
premium for Production) are detailed in [`docs/full-analysis.md#recommendations`](docs/full-analysis.md#recommendations).

## Tech stack

| Layer | Tool | Role |
|-------|------|------|
| Storage | [DuckDB](https://duckdb.org) | Embedded analytical database |
| Transformation | [dbt](https://www.getdbt.com) (`dbt-duckdb`) | Tested, layered SQL models |
| Visualisation | [Evidence](https://evidence.dev) | BI-as-code reports |
| Hosting | [Vercel](https://vercel.com) | Static hosting + auto-deploy on push |

## Data source

[Human Resources Data Set](https://www.kaggle.com/datasets/rhuebner/human-resources-data-set)
by Dr. Rich Huebner & Dr. Carla Patalano (Kaggle). A single CSV,
`HRDataset_v14.csv` (**~311 employees, 36 columns**), one row per employee.

A snapshot of this public dataset is committed to the repo as a dbt seed at
`hr_dbt/seeds/raw_hr_dataset.csv`, so `dbt build` is fully reproducible with no
manual download. `stg_employees` reads it via `ref('raw_hr_dataset')`.

## Project structure

```
workforce-flux/
├── LICENSE
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   └── raw/                  # local scratch for the source CSV (not committed)
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
│   ├── seeds/                # raw_hr_dataset.csv (committed source snapshot)
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
├── reports/                  # Evidence reports (live at workforceflux.kdayno.com)
└── hr.duckdb                 # built by dbt; committed for Vercel
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

# 2. Build the pipeline (run dbt from inside hr_dbt/)
#    The raw data ships as a committed dbt seed -- no download needed.
cd hr_dbt
dbt deps                              # installs dbt_utils
dbt build --profiles-dir .            # loads seed + runs models + tests

# 3. Run the Evidence reports locally
cd ../reports
npm install
npm run dev                           # opens http://localhost:3000
```

## Pipeline / data model

```
raw_hr_dataset (seed) ............ committed source snapshot
└─ stg_employees ................. clean + type-cast, 1 row per employee
   └─ int_employees_enriched ..... + derived fields (age, tenure, bands…)
      ├─ dim_employee ............ employee dimension
      ├─ mart_attrition .......... department-level separation summary
      ├─ mart_recruitment_effectiveness
      └─ int_headcount_monthly ... employee-month grain (uses int_date_spine)
         └─ mart_headcount_monthly  monthly time series + turnover rate
```

Layer materialisation: staging & intermediate are **views**, marts are **tables**.

## Next steps

- **Recruitment-source effectiveness as a fifth finding.** The
  `mart_recruitment_effectiveness` model exists but no narrative is built on
  it — it is an intentional orphan mart (no dbt exposure points to it yet).
  Which channels (Indeed, LinkedIn, referral, diversity job fair) produce
  stayers vs leavers, and at what cost-per-retained-hire?
- **Tenure survival curve for voluntary exits.** A hazard curve by
  month-of-tenure, Production vs non-Production, would localise *when* in the
  lifecycle attrition happens and sharpen the salary-review recommendation to
  a specific tenure-month trigger.
- **Quantify the salary-review intervention.** The primary recommendation
  ("market-rate review for Production at 3+ years") is qualitative. A
  cost-benefit estimate (retained employees and avoided replacement cost vs
  the raise bill) would turn it into a business case.
