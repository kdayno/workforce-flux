---
title: Data Lineage
description: Browse the dbt project — models, tests, exposures, and column-level lineage
sidebar_position: 5
---

<iframe
  src='https://docs.workforceflux.kdayno.com/#!/overview?g_v=1'
  title='dbt documentation site'
  width='100%'
  height='820'
  style='border: 1px solid var(--grey-300); border-radius: 8px; margin-bottom: 1.5rem;'
  loading='lazy'>
</iframe>

This project is built on a tested, documented dbt pipeline. The full dbt
documentation site lets you click through the lineage graph from the raw seed
all the way to the Evidence pages, and inspect every model, column, test, and
exposure.

What you'll find there:

- **Lineage graph** — the DAG from `raw_hr_dataset` (seed) → staging →
  intermediate → marts → the five Evidence pages (modelled as dbt exposures).
- **Models & columns** — descriptions and data types for every model.
- **Tests** — the 40+ data tests (not-null/unique/relationships, range checks,
  and custom business-rule tests) guarding each layer.

<BigLink url='https://docs.workforceflux.kdayno.com/#!/overview?g_v=1'>Open the dbt docs site →</BigLink>
