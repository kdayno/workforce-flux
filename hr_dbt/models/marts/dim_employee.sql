-- Mart: the core employee dimension -- one row per employee with all derived
-- analytical attributes. The cross-sectional marts build on this.

select
    emp_id,
    employee_name,
    department,
    position,
    manager_name,

    -- Demographics
    sex,
    race,
    is_hispanic_latino,
    marital_status,
    citizenship,
    age_years,
    age_band,
    state,

    -- Recruitment
    recruitment_source,
    from_diversity_job_fair,

    -- Compensation
    salary,
    salary_band,

    -- Performance & engagement
    performance_score,
    engagement_survey_score,
    employee_satisfaction,
    special_projects_count,
    days_late_last_30,
    absences,

    -- Employment timeline
    date_of_hire,
    hire_year,
    date_of_termination,
    is_terminated,
    term_reason,
    termination_type,
    tenure_end_date,
    tenure_years,
    tenure_band

from {{ ref('int_employees_enriched') }}
