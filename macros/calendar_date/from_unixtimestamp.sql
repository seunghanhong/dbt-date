{%- macro from_unixtimestamp(epochs, format="seconds") -%}
    {{ adapter.dispatch('from_unixtimestamp', packages = dbt_date._get_utils_namespaces()) (epochs, format) }}
{%- endmacro %}

{%- macro snowflake__from_unixtimestamp(epochs, format) -%}
    
    {%- if format == "seconds" -%}
    {%- set scale = 0 -%}
    {%- elif format == "milliseconds" -%}
    {%- set scale = 3 -%}
    {%- elif format == "microseconds" -%}
    {%- set scale = 6 -%}
    {%- else -%}
    {{ exceptions.raise_compiler_error(
        "value " ~ format ~ " for `format` for from_unixtimestamp is not supported."
        ) 
    }}
    to_timestamp_ntz({{ epochs }}, {{ scale }})
    {% endif -%}

{%- endmacro %}

{%- macro bigquery__from_unixtimestamp(epochs, format) -%}
    {%- if format == "seconds" -%}
        timestamp_seconds({{ epochs }})
    {%- elif format == "milliseconds" -%}
        timestamp_millis({{ epochs }})
    {%- elif format == "microseconds" -%}
        timestamp_micros({{ epochs }})
    {%- else -%}
    {{ exceptions.raise_compiler_error(
        "value " ~ format ~ " for `format` for from_unixtimestamp is not supported."
        ) 
    }}
    {% endif -%}
{%- endmacro %}
