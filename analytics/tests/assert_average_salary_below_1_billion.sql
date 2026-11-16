SELECT
    job_id,
    average_salary,
    currency_unit,
    salary_unit
FROM {{ ref('stg_job_postings') }}
WHERE average_salary > 1000000000
