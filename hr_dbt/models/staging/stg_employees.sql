-- Staging: one cleaned, type-cast row per employee, built directly from the
-- raw Kaggle CSV. Column names are snake_cased, whitespace is trimmed, and
-- 0/1 flags are converted to booleans. No business logic lives here.

with source as (

    -- all_varchar = true forces every column to text so we can cast
    -- deliberately below, rather than relying on CSV type auto-detection.
    select *
    from read_csv_auto(
        '{{ var("raw_data_path") }}/HRDataset_v14.csv',
        all_varchar = true
    )

),

renamed as (

    select
        -- Identifiers
        cast(EmpID as integer)                          as emp_id,
        trim(Employee_Name)                             as employee_name,
        cast(DeptID as integer)                         as department_id,
        cast(ManagerID as integer)                      as manager_id,
        cast(PositionID as integer)                     as position_id,
        cast(PerfScoreID as integer)                    as performance_score_id,

        -- Job / org
        trim(Position)                                  as position,
        trim(Department)                                as department,
        trim(ManagerName)                               as manager_name,
        trim(State)                                     as state,
        trim(Zip)                                       as zip,

        -- Demographics
        trim(Sex)                                       as sex,
        trim(MaritalDesc)                               as marital_status,
        trim(CitizenDesc)                               as citizenship,
        trim(RaceDesc)                                  as race,

        -- HispanicLatino arrives as a mix of 'Yes'/'No'/'yes'/'no'.
        case lower(trim(HispanicLatino))
            when 'yes' then true
            when 'no'  then false
        end                                             as is_hispanic_latino,

        -- 0/1 integer flags -> booleans
        cast(Termd as integer) = 1                      as is_terminated,
        cast(FromDiversityJobFairID as integer) = 1     as from_diversity_job_fair,

        -- Employment / recruitment
        trim(EmploymentStatus)                          as employment_status,
        trim(TermReason)                                as term_reason,
        trim(RecruitmentSource)                         as recruitment_source,
        trim(PerformanceScore)                          as performance_score,

        -- Numeric measures
        cast(Salary as integer)                         as salary,
        cast(EngagementSurvey as double)                as engagement_survey_score,
        cast(EmpSatisfaction as integer)                as employee_satisfaction,
        cast(SpecialProjectsCount as integer)           as special_projects_count,
        cast(DaysLateLast30 as integer)                 as days_late_last_30,
        cast(Absences as integer)                       as absences,

        -- Dates. The raw file mixes M/D/YYYY (hire, termination, review) with
        -- M/D/YY (date of birth). try_strptime returns NULL on a format miss
        -- instead of failing the run -- verify these against the real file.
        try_strptime(DateofHire, '%m/%d/%Y')::date              as date_of_hire,
        try_strptime(DateofTermination, '%m/%d/%Y')::date       as date_of_termination,
        try_strptime(LastPerformanceReview_Date, '%m/%d/%Y')::date as last_performance_review_date,
        try_strptime(DOB, ['%m/%d/%y', '%m/%d/%Y'])::date       as date_of_birth

    from source

)

select * from renamed
