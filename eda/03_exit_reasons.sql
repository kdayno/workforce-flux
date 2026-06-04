-- Phase 5 — exit reasons
--
-- Turns term_reason into a "why do people leave?" narrative. Three cuts:
-- company-wide, Production vs non-Production, and by tenure band.
-- Underpins Findings #6 and #7.

-- Q1: Voluntary exit reasons, company-wide, with proportional shares.
-- Reason classes used downstream:
--   Pull (external opportunity):    Another position, more money, career change
--   Push (driven away from Co. X):  unhappy, hours
--   Life-stage (uncontrollable):    school, relo, military, retirement, maternity, medical
-- Mix is ~47% pull, ~26% push, ~28% life.
SELECT
    term_reason,
    COUNT(*) AS voluntary_exits,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_voluntary
FROM dim_employee
WHERE termination_type = 'Voluntary'
GROUP BY term_reason
ORDER BY voluntary_exits DESC;


-- Q2: Term reason x Production vs non-Production. Localizes the
-- pay/dissatisfaction signal: every "unhappy" (14/14) and every
-- "more money" (11/11) voluntary exit is from Production.
SELECT
    term_reason,
    COUNT(*) FILTER (WHERE department  = 'Production') AS production,
    COUNT(*) FILTER (WHERE department <> 'Production') AS non_production,
    COUNT(*) AS total
FROM dim_employee
WHERE termination_type = 'Voluntary'
GROUP BY term_reason
ORDER BY total DESC;


-- Q3: Term reason x tenure band. Tests whether the 2-5 yr exit peak
-- (Finding #5) is dominated by a single mechanism ("market value built")
-- or is multi-cause. It's multi-cause. Only "career change" concentrates
-- by tenure (<2 yrs). Underpins Finding #7.
SELECT
    term_reason,
    COUNT(*) FILTER (WHERE tenure_years <  2)                       AS exits_lt_2yrs,
    COUNT(*) FILTER (WHERE tenure_years >= 2 AND tenure_years < 5)  AS exits_2_5yrs,
    COUNT(*) FILTER (WHERE tenure_years >= 5)                       AS exits_5plus_yrs,
    COUNT(*) AS total
FROM dim_employee
WHERE termination_type = 'Voluntary'
GROUP BY term_reason
ORDER BY total DESC;
