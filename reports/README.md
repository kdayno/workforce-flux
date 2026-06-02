# Workforce Flux — Reports

[Evidence](https://evidence.dev) project that renders the four findings from
the analysis as a small static site. Run from this directory:

```bash
npm install
npm run sources    # materialise sources/workforce_flux/*.sql against ../hr.duckdb
npm run dev        # local server at localhost:3000
```

The DuckDB file is built upstream by `dbt build` from `../hr_dbt/`.
See the [project README](../README.md) for the analytical findings and
recommendations.
