# Data Project Workflow

A reusable, phase-based playbook for end-to-end analytics projects, generalized
from the Workforce Flux build (raw Kaggle HR dataset → DuckDB + dbt + Evidence →
static Vercel site). The aim is a repeatable sequence that takes a raw dataset to
decision-useful, defensible insight.

Each phase lists its **goal**, the **steps**, and the **exit criteria** that say
you're ready to move on. Phases are mostly sequential, but EDA and modelling
iterate against each other in practice.

---

## Phase 0 — Frame the problem

**Goal:** know what decision the analysis is meant to inform before touching data.

- Write 2–4 **objectives** in plain language. Separate the *analytical* goal
  (what insight) from the *engineering* goal (clean, tested, documented pipeline)
  and the *rigour* goal (correct metric definitions, honest limitations).
- Identify the **audience** and the artifact they'll consume (exec README, live
  report, notebook). This sets the bar for polish and how much detail surfaces.
- Name the **subject** and any anonymization rules up front (e.g. refer to the
  company as "Company X"; no individual names in exec-facing output).

**Exit criteria:** you can state, in one sentence, what action the finished
analysis should enable.

---

## Phase 1 — Source and stage the data

**Goal:** get the raw data in hand and reproducible for anyone cloning the repo.

- Document the **provenance**: source, author, license, row/column counts, grain
  (one row per what?).
- Decide what's **committed vs ignored**. Keep raw source files out of git when
  licensing or size argues against it; document the exact download path instead
  (`data/raw/<file>`). Commit the built database only if a downstream host needs
  it (we committed `hr.duckdb` for Vercel).
- Scaffold the repo: `data/raw/`, `eda/`, the dbt project, `reports/`, `docs/`,
  `README.md`, `requirements.txt`, `.gitignore`, `LICENSE`.
- Pin the environment. Note known incompatibilities (e.g. dbt didn't support
  Python 3.14 — use 3.13).

**Exit criteria:** a fresh clone + documented setup steps reproduce the raw
dataset and an empty-but-runnable pipeline.

---

## Phase 2 — Exploratory data analysis (EDA)

**Goal:** understand the data's shape, quality, and the questions worth asking —
*before* committing to a model.

- Write **exploratory SQL queries** against the raw/staged data, one file per
  question area (`01_decline_diagnosis.sql`, `02_retention.sql`,
  `03_exit_reasons.sql`, `04_compensation_equity.sql`). Keep them in `eda/` as a
  record of the path, not as production code.
- Profile aggressively: nulls, types, duplicates, outliers, category cardinality,
  date ranges. Note every data-quality issue you'll need to fix in staging.
- Let EDA **surface candidate findings**. The questions that have signal here
  become the marts and report pages later.

**Exit criteria:** a shortlist of candidate findings and a written list of the
cleaning/typing fixes the pipeline must apply.

---

## Phase 3 — Build the transformation pipeline (layered ELT)

**Goal:** turn raw, inconsistent input into clean, tested, documented models.

Use a **layered dbt structure** so each layer has one job:

- **Staging** (`stg_*`, materialized as views): one model per source. Clean and
  type-cast only — rename columns, fix types, trim/standardize. No business
  logic. One row per source entity.
- **Intermediate** (`int_*`, views): derived fields and reshaping that multiple
  marts will reuse (age, tenure, bands; a date spine; a headcount-by-month grain
  via cross-join of the spine and employees).
- **Marts** (`dim_*` / `mart_*`, materialized as tables): the analytical
  surfaces each report page queries. Dimensions for entities, marts for the
  specific questions (attrition summary, monthly headcount + turnover,
  recruitment effectiveness).

Practices that paid off:

- **Test as you build.** Add schema tests (`unique`, `not_null`, accepted
  values, relationships) in `_staging.yml` / `_marts.yml`. Run `dbt build` so
  models and tests run together.
- **Materialization rule of thumb:** staging + intermediate as views (cheap,
  always fresh), marts as tables (fast for the BI layer to hit).
- **Document the model graph** in the README as an ASCII dependency tree so the
  lineage is legible without opening dbt docs.
- Use `dbt deps` for utility packages (e.g. `dbt_utils` for the date spine).

**Exit criteria:** `dbt build` passes clean (all models + tests green) from a
fresh clone, and the mart layer answers every candidate finding from Phase 2.

---

## Phase 4 — Analysis and visualization

**Goal:** turn models into a narrative a decision-maker can act on.

- Build **BI-as-code reports** (Evidence) — one page per finding. Each page
  queries the marts directly, shows the chart + table, and states the takeaway in
  prose. Code-based reports version-control cleanly and deploy as a static site.
- **Define metrics correctly and say which definition you used** (e.g.
  annualized vs cumulative turnover). The definition is part of the finding.
- **Segment responsibly for the sample size.** Set a minimum cell size (we used
  n ≥ 3) and don't over-claim on thin slices.
- **Control for confounders before claiming an effect.** A raw gap can be
  composition, not cause — show the controlled view (position × tenure × sex)
  next to the raw number so the reader sees both.

**Exit criteria:** every claim on a report page is backed by a query the reader
can inspect, and each page ends with a clear takeaway.

---

## Phase 5 — Synthesize findings and recommendations

**Goal:** compress the analysis into a few defensible findings and one or two
high-leverage actions.

- Lead with a **findings summary table**: number, one-line finding, single
  headline number with its benchmark/source. Keep the README to highlights; the
  numbers and per-finding tables live on the live report and in the full
  analysis.
- Derive **recommendations** from the findings, ranked by leverage. Name the
  single highest-leverage intervention; list supporting ones briefly. Tie each
  recommendation back to specific evidence (e.g. the explicit "more money" exits).
- Keep a **full analysis doc** (`docs/full-analysis.md`) for the back-matter:
  per-finding tables, methodology, **every change applied to the source data**,
  **assumptions**, and **caveats & limitations**. State assumptions and limits
  transparently — this is where rigour shows.

**Exit criteria:** a reader gets the story from the README in two minutes and can
drill into evidence and caveats on demand.

---

## Phase 6 — Document, publish, and deploy

**Goal:** make the project legible and the reports live.

- **README as front door:** objectives, key findings table, recommendations,
  tech stack, data source, project structure, setup steps (1 → N, fully
  reproducible), pipeline diagram, next steps.
- **Deploy the reports** as a static site with auto-deploy on push (Vercel). If
  the host needs the built database, commit it.
- **Repo hygiene before any push/PR/merge:** scan for secrets, PII, and stray
  artifacts. Honor anonymization rules in every exec-facing artifact.
- **Git workflow:** branch off `main`, make focused conventional commits
  (`docs(readme):`, `feat(reports):`), open a PR whose body describes the
  changeset + test plan (keep analytical findings in the README/analysis, not the
  PR body), then merge.

**Exit criteria:** the live site renders, the README reproduces the build, and
the repo is clean.

---

## Phase 7 — Next steps

**Goal:** capture the obvious follow-on work so momentum isn't lost.

- List concrete extensions with enough specificity to pick up cold: an unused
  mart waiting for a narrative, a sharper analytical cut (e.g. a tenure survival
  curve), or turning a qualitative recommendation into a quantified business case
  (retained employees + avoided cost vs the spend).

---

## Stack reference (Workforce Flux)

| Layer | Tool | Role |
|-------|------|------|
| Storage | DuckDB | Embedded analytical database (file-based) |
| Transformation | dbt (`dbt-duckdb`) | Tested, layered SQL models |
| Visualisation | Evidence | BI-as-code reports |
| Hosting | Vercel | Static hosting + auto-deploy on push |

The file-based stack (no warehouse, no server) is what makes the whole project
clone-and-run reproducible.
