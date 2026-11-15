{% macro slugify(text) -%}
    {{ text | lower() | replace(' ', "_") | replace('-', "_") }}
{%- endmacro %}