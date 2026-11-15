{% macro parse_salary_currency_unit() -%}
    COALESCE(NULLIF(REGEXP_EXTRACT(TRIM(job_salary), '^([A-Z]{2,3}\\$?|[\\$£€¥₱₹₩₫])', 1), ''), 'USD')
{%- endmacro %}