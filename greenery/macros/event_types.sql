{%- macro event_types(table_name, column_name) -%}
{% set event_types = dbt_utils.get_column_values(table=ref('stg_events'), column='event_type') %}

{% for event_type in event_type %}

{% endmacro %}