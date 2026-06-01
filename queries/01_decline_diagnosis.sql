-- Phase 1 — decline diagnosis
--
-- Tests whether Company X's mid-2015 -> 2018 headcount drop is driven by
-- a hiring freeze, a layoff event, or a voluntary-attrition spike.
-- Underpins Finding #1.
--
-- Connect to ../hr.duckdb (built by `dbt build` from hr_dbt/).

-- Q1: Year-over-year hires, terminations, and net change from the
-- reconstructed monthly time series. The 2016+ net-negative inflection
-- shows up here.
SELECT
    calendar_year,
    SUM(hires)        AS hires,
    SUM(terminations) AS terminations,
    SUM(hires) - SUM(terminations) AS net_change
FROM mart_headcount_monthly
GROUP BY calendar_year
ORDER BY calendar_year;


-- Q2: Voluntary vs involuntary terminations by year (2014+).
-- Distinguishes three hypotheses for the decline:
--   - layoff event       -> would show involuntary spike
--   - voluntary spike    -> would show voluntary climb
--   - hiring freeze      -> both flat or falling; net loss from hires falling faster
-- The data supports the third hypothesis.
SELECT
    EXTRACT(YEAR FROM date_of_termination) AS term_year,
    termination_type,
    COUNT(*) AS terminations
FROM dim_employee
WHERE is_terminated
  AND date_of_termination >= DATE '2014-01-01'
GROUP BY term_year, termination_type
ORDER BY term_year, termination_type;
