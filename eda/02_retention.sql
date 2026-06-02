-- Phase 4 — retention
--
-- Diagnostic queries on annualised turnover, departmental concentration,
-- regrettability (do top performers leave?), and tenure-at-exit patterns.
-- Underpins Findings #2, #3 (partially), #4, and #5.

-- Q1: Annualised turnover by year via the trailing-12-month window.
-- Distinguishes Company X's actual rate (3.6-9.9%) from naive "lifetime
-- cumulative separation rate" (~33%). Year-end snapshot of mart_headcount_monthly.
SELECT
    EXTRACT(YEAR FROM month_start) AS year,
    active_headcount,
    separations_ttm,
    avg_headcount_ttm,
    rolling_12m_turnover_rate
FROM mart_headcount_monthly
WHERE EXTRACT(MONTH FROM month_start) = 12
  AND EXTRACT(YEAR FROM month_start) BETWEEN 2014 AND 2018
ORDER BY year;


-- Q2: Voluntary attrition concentration by department.
-- Surfaces the 86%/67% concentration in Production. Engagement is included
-- to confirm it doesn't differentiate Production from healthier departments.
SELECT
    department,
    total_employees,
    voluntary_separations,
    involuntary_separations,
    ROUND(voluntary_separations * 1.0 / NULLIF(total_employees, 0), 3) AS voluntary_rate,
    avg_tenure_years,
    avg_engagement_score
FROM mart_attrition
ORDER BY voluntary_rate DESC;


-- Q3: Regrettability test — performance band x voluntary rate, company-wide.
-- If voluntary rate were highest for "Exceeds", that would be the worst-case
-- regrettable pattern. Company X's pattern is non-regrettable overall.
SELECT
    performance_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE NOT is_terminated) AS still_active,
    COUNT(*) FILTER (WHERE termination_type = 'Voluntary') AS voluntary_quits,
    COUNT(*) FILTER (WHERE termination_type = 'Involuntary') AS involuntary_terms,
    ROUND(
        COUNT(*) FILTER (WHERE termination_type = 'Voluntary') * 1.0
        / NULLIF(COUNT(*), 0),
        3
    ) AS voluntary_rate
FROM dim_employee
GROUP BY performance_score
ORDER BY
    CASE performance_score
        WHEN 'Exceeds'           THEN 1
        WHEN 'Fully Meets'       THEN 2
        WHEN 'Needs Improvement' THEN 3
        WHEN 'PIP'               THEN 4
    END;


-- Q4: Same regrettability test, Production-only. Tests whether the
-- aggregate non-regrettable pattern holds within the dept that drives
-- 86% of voluntary exits. It does -- but Production Exceeds quit at
-- >2x the non-Production Exceeds rate, the top-performer flight risk.
SELECT
    performance_score,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE NOT is_terminated) AS still_active,
    COUNT(*) FILTER (WHERE termination_type = 'Voluntary') AS voluntary_quits,
    COUNT(*) FILTER (WHERE termination_type = 'Involuntary') AS involuntary_terms,
    ROUND(
        COUNT(*) FILTER (WHERE termination_type = 'Voluntary') * 1.0
        / NULLIF(COUNT(*), 0),
        3
    ) AS voluntary_rate
FROM dim_employee
WHERE department = 'Production'
GROUP BY performance_score
ORDER BY
    CASE performance_score
        WHEN 'Exceeds'           THEN 1
        WHEN 'Fully Meets'       THEN 2
        WHEN 'Needs Improvement' THEN 3
        WHEN 'PIP'               THEN 4
    END;


-- Q5: Tenure-at-exit distribution for voluntary leavers.
-- No early-tenure cliff; peak at 3-5 years. Underpins Finding #5.
SELECT
    CASE
        WHEN tenure_years < 1 THEN '0-1 yrs'
        WHEN tenure_years < 2 THEN '1-2 yrs'
        WHEN tenure_years < 3 THEN '2-3 yrs'
        WHEN tenure_years < 5 THEN '3-5 yrs'
        ELSE '5+ yrs'
    END AS tenure_at_exit,
    COUNT(*) AS voluntary_exits
FROM dim_employee
WHERE termination_type = 'Voluntary'
GROUP BY 1
ORDER BY 1;
