{% macro parse_salary_unit() %}
    REGEXP_EXTRACT(job_salary, 'month|year|day|hour', 0)
{% endmacro %}