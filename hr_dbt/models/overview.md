{% docs __overview__ %}

# Workforce Flux — HR Analytics

This is the dbt documentation for **Workforce Flux**, an end-to-end people-analytics
project built on a file-based modern analytics stack: **DuckDB + dbt + Evidence**,
deployed as a static site.

It transforms a raw HR dataset into decision-useful insight on headcount, attrition,
and pay, surfaced through a set of Evidence pages.

- 📊 **Live dashboards:** [workforceflux.kdayno.com](https://workforceflux.kdayno.com)
- 💻 **Source:** [github.com/kdayno/workforce-flux](https://github.com/kdayno/workforce-flux)

## Pipeline architecture

A conventional layered ELT flow — each layer has a single responsibility:

| Layer | Materialisation | Purpose |
|-------|-----------------|---------|
| **Seed** (`raw_hr_dataset`) | table | Committed snapshot of the raw source CSV — reproducible builds, no manual download. |
| **Staging** (`stg_*`) | view | Clean + type-cast, one row per entity. Snake-case names, trimmed strings, boolean flags. No business logic. |
| **Intermediate** (`int_*`) | view | Derived fields and reshaping (tenure, age, bands, the monthly headcount grain). |
| **Marts** (`dim_*`, `mart_*`) | table | Analytics-ready models the dashboards read from. |

Use the **lineage graph** (blue icon, bottom-right) to trace any column from the raw
seed through to the Evidence pages, which are modelled as dbt **exposures**.

## Testing

The project ships a real testing layer — 40+ data tests across every layer:

- **Structural:** `not_null`, `unique`, and `relationships` on keys.
- **Range / value:** `dbt_utils.accepted_range` and `dbt_expectations` checks on
  salaries, scores, rates, and counts; a row-count guard against silent source drift.
- **Business rules:** a custom `termination_after_hire` generic test plus singular
  tests for active/terminated date consistency and cross-mart reconciliation.

## Conventions

- Analysis is anchored to a frozen `analysis_date` (`2019-01-01`) so "as of" metrics
  (tenure, age, current headcount) are stable across runs.
- The subject company is anonymised in the source dataset.

{% enddocs %}
