{% macro parse_salary(part) -%}
    {% if part == 'min' -%}
        {% set segment = "ELEMENT_AT(SPLIT(job_salary, '–'), 1)" %}
    {% elif part == 'max' -%}
        {% set segment = "ELEMENT_AT(SPLIT(job_salary, '–'), -1)" %}
    {%- endif -%}
    TRY_CAST(REPLACE(REGEXP_EXTRACT({{ segment }}, '([0-9]+[,.]?)+', 0), ',', '') AS DECIMAL(15,2)) 
        * 
        CASE REGEXP_EXTRACT( {{ segment }}, '([0-9]+[,.]?)+([KM])?', 2)
            WHEN 'K' THEN 1000
            WHEN 'M' THEN 1000000
            ELSE 1
        END
{%- endmacro %}