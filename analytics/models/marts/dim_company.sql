WITH job_postings AS(
    SELECT * FROM {{ ref('fct_job_postings') }}
)

SELECT 
    company_name,
    COUNT(*) AS total_job_postings,
    AVG(
        CASE 
        WHEN currency_unit = 'USD' AND salary_unit = 'year' THEN average_salary
        END   
    ) AS avg_salary_year
FROM job_postings
WHERE company_name IS NOT NULL
GROUP BY company_name