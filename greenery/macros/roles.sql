{% macro grant(reporting) %}

    {% set sql %}
      GRANT USAGE ON SCHEMA {{ schema }} TO ROLE {{ reporting }};
      GRANT SELECT ON {{ this }} TO ROLE {{ reporting }};
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}