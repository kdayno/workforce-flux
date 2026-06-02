-- Phase 6 — compensation & equity
--
-- Examines Production pay structurally: across departments, by tenure,
-- by performance, by sex (controlled), and the stayers-vs-leavers test
-- that confirms F8 at population scale. Underpins Findings #9, #10, #11,
-- and #12.
--
-- Two caveats apply to every query in this file:
--   (a) No role-complexity normalization across departments -- Production
--       roles aren't directly comparable to Sales or IT/IS roles.
--   (b) Snapshot bias -- veterans' pay reflects their hire-date market rate
--       plus subsequent raises; new hires reflect today's market rate.

-- Q1: Salary distribution by department.
-- Production median ($59.5K) is the lowest of any department; the spread
-- is also the tightest. Sets the descriptive picture.
SELECT
    department,
    COUNT(*) AS employees,
    MIN(salary) AS min_salary,
    ROUND(QUANTILE_CONT(salary, 0.25)) AS p25,
    ROUND(QUANTILE_CONT(salary, 0.5))  AS median,
    ROUND(QUANTILE_CONT(salary, 0.75)) AS p75,
    MAX(salary) AS max_salary,
    ROUND(AVG(salary)) AS mean
FROM dim_employee
GROUP BY department
ORDER BY median DESC;


-- Q2: Production salary by tenure band -- the anchored-pay test.
-- Pay inverts with tenure: <2 yrs $64K, 2-10 yrs $59K, 10+ yrs $56K.
-- Newer hires earn more than veterans. Underpins Finding #9.
SELECT
    tenure_band,
    COUNT(*) AS employees,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5))  AS median_salary,
    ROUND(QUANTILE_CONT(salary, 0.25)) AS p25,
    ROUND(QUANTILE_CONT(salary, 0.75)) AS p75
FROM dim_employee
WHERE department = 'Production'
GROUP BY tenure_band
ORDER BY
    CASE tenure_band
        WHEN '< 1 year'    THEN 1
        WHEN '1-2 years'   THEN 2
        WHEN '2-5 years'   THEN 3
        WHEN '5-10 years'  THEN 4
        ELSE 5
    END;


-- Q3: Production salary by performance band -- the merit-pay test.
-- Top performers (Exceeds) earn only ~2% more than median performers
-- (Fully Meets) at the median. No meaningful merit-pay structure.
-- Underpins Finding #10.
SELECT
    performance_score,
    COUNT(*) AS employees,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5)) AS median_salary
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


-- Q4a: Pay equity -- raw company-wide median gap by sex.
-- This is the misleading "headline" number that conflates role mix,
-- tenure, performance, etc. Reads as 2.1% in men's favour at the median.
-- NEVER report this in isolation -- always pair with Q4b.
SELECT
    sex,
    COUNT(*) AS employees,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5)) AS median_salary
FROM dim_employee
GROUP BY sex
ORDER BY sex;


-- Q4b: Pay equity -- Production controlled by position and tenure band.
-- The analytically defensible comparison. Cells with n<3 suppressed.
-- At Technician I and II (86% of Production), women earn the same as
-- or slightly more than men. Underpins Finding #11.
SELECT
    position,
    tenure_band,
    sex,
    COUNT(*) AS employees,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5)) AS median_salary
FROM dim_employee
WHERE department = 'Production'
GROUP BY position, tenure_band, sex
HAVING COUNT(*) >= 3
ORDER BY position, tenure_band, sex;


-- Q4c: Position composition within Production -- the "where does the
-- raw gap come from" view. Sex distribution by role + median pay shows
-- the slight management-representation skew (men 57% of 14 Production
-- Managers; sole Director of Operations is male) that drives the
-- 2.1% raw gap.
SELECT
    position,
    COUNT(*) AS employees,
    COUNT(*) FILTER (WHERE sex = 'M') AS male_n,
    COUNT(*) FILTER (WHERE sex = 'F') AS female_n,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5)) AS median_salary
FROM dim_employee
WHERE department = 'Production'
GROUP BY position
ORDER BY employees DESC;


-- Q5: The direct F8 test -- Production voluntary leavers vs stayers at
-- the same tenure band. Leavers earned 4% less at 2-5 yrs and 12.7% less
-- at 5-10 yrs (n=20 leavers vs n=72 stayers). Population-scale
-- confirmation of the named-case-study pattern from F8. Underpins F12.
SELECT
    tenure_band,
    CASE
        WHEN NOT is_terminated              THEN 'Still here'
        WHEN termination_type = 'Voluntary' THEN 'Voluntary leaver'
    END AS status,
    COUNT(*) AS employees,
    ROUND(AVG(salary)) AS mean_salary,
    ROUND(QUANTILE_CONT(salary, 0.5)) AS median_salary
FROM dim_employee
WHERE department = 'Production'
  AND (NOT is_terminated OR termination_type = 'Voluntary')
GROUP BY tenure_band, status
ORDER BY
    CASE tenure_band
        WHEN '< 1 year'   THEN 1
        WHEN '1-2 years'  THEN 2
        WHEN '2-5 years'  THEN 3
        WHEN '5-10 years' THEN 4
        ELSE 5
    END,
    status DESC;
