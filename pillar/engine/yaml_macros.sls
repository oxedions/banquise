{% macro write_yaml(my_dict) %}

{% for lvl1, lvl1_args in my_dict.items() %}
{# LVL 1 #}
  {% if lvl1_args is defined and not none %}
      {% if lvl1_args is not mapping %} {# This is not a dict, so we reached last level #}
        {% if lvl1_args is not iterable %} {# This is not a list or a string #}
  {{lvl1}}: {{lvl1_args}}
        {% else %} {# This is a list or a string #}
          {% if lvl1_args is string %} {# This is a string #}
            {% if '\n' in lvl1_args %} {# This is a multi line string #}
  {{lvl1}}: "{% for current_line in lvl1_args.split('\n') %}{{current_line}}\n{% endfor %}"
            {% else %} {# This is a single line string #}
  {{lvl1}}: {{lvl1_args}}
            {% endif %}
          {% else %} {# This is a list #}
  {{lvl1}}:
            {% for current_item in lvl1_args %}
    - {{current_item}}
            {% endfor %}
          {% endif %}
        {% endif %}
      {% else %} {# This is a dict, entering next level #}
  {{lvl1}}:

{# LVL 2 #}

        {% for lvl2, lvl2_args in lvl1_args.items() %}
          {% if lvl2_args is defined and not none %}
            {% if lvl2_args is not mapping %} {# This is not a dict, so we reached last level #}
              {% if lvl2_args is not iterable %} {# This is not a list or a string #}
    {{lvl2}}: {{lvl2_args}}
              {% else %} {# This is a list or a string #}
                {% if lvl2_args is string %} {# This is a string #}
                  {% if '\n' in lvl2_args %} {# This is a multi line string #}
    {{lvl2}}: "{% for current_line in lvl2_args.split('\n') %}{{current_line}}\n{% endfor %}"
                  {% else %} {# This is a single line string #}
    {{lvl2}}: {{lvl2_args}}
                  {% endif %}
                {% else %} {# This is a list #}
    {{lvl2}}:
                  {% for current_item in lvl2_args %}
      - {{current_item}}
                  {% endfor %}
                {% endif %}
              {% endif %}
            {% else %} {# This is a dict, entering next level #}
    {{lvl2}}:
            {% endif %}
          {% endif %}
        {% endfor %}

      {% endif %}

    {% endif %}
{% endfor %}

{% endmacro %}


