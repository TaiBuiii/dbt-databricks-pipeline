{%
    set extension_keywords = [
        "10 hours ago", 
        "Full-time and Part-time", 
        "Dental insurance", 
        "Health insurance", 
        "Paid time off"
    ]
%}
WITH source AS(
    SELECT *
    FROM {{ source('jobs','raw_job_postings') }}
    WHERE error IS NOT TRUE AND job_id IS NOT NULL
),
parsed AS(
    SELECT *,
        FROM_JSON(job_extensions_raw, 'array<string>') AS job_extensions
    FROM source
),
cleaned AS(
    SELECT 
        job_id,
        job_title,
        TRIM(company_name) AS company_name,
        job_location,
        REGEXP_REPLACE(job_via, '^via ', '') AS source_platform,
        job_posted_at,
        {{ parse_salary('min') }} AS min_salary,
        {{ parse_salary('max') }} AS max_salary,
        {{ parse_salary_unit() }} AS salary_unit,
        {{ parse_salary_currency_unit() }} AS currency_unit,
        ({{ parse_salary('min') }} + {{ parse_salary('max') }}) / 2 AS average_salary,
        job_schedule_type,
        job_work_from_home,
        search_time AS searched_at,
        search_date,
        search_term,
        search_location ,
        {% for keyword in extension_keywords -%}
        ARRAY_CONTAINS(
            job_extensions,
            '{{ keyword }}'
        ) AS has_{{ slugify(keyword) }}
        {{- "," if not loop.last }}
        {%- endfor %}
    FROM parsed
)
SELECT * FROM cleaned