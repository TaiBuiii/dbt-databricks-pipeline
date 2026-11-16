{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='job_id'
    )
}}

WITH source AS (
    SELECT * 
    FROM {{ ref('stg_job_postings') }}
),
incremental_data AS(
    SELECT source.*
    FROM source
    {% if is_incremental() %}
    WHERE source.search_date > (
        SELECT COALESCE(MAX(search_date), DATE '1990-01-01') AS max_search_date
        FROM {{ this }}
    )
    {% endif %}
),
deduplicated_data AS(
    SELECT * 
    FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY job_id ORDER BY searched_at DESC) AS rank
        FROM incremental_data
    ) AS sub
    WHERE sub.rank = 1
)

SELECT
    job_id,
    job_title,
    search_term,
    company_name,
    job_location,
    source_platform,
    job_schedule_type,
    job_work_from_home,
    search_date,
    min_salary,
    max_salary,
    average_salary,
    salary_unit,
    currency_unit,
    has_health_insurance,
    has_dental_insurance,
    has_paid_time_off
FROM deduplicated_data 