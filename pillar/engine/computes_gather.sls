{% import_yaml 'nodes/computes.sls' as com %}
{% import_yaml 'nodes/computes_states.sls' as sta %}

computes_gather:

{% for group_comp, args in com.computes.items() %}
#  {{group_comp}}:
{% for node in args %}
  {{node}}:
    {% for group_state, argu in sta.computes_states.items() %}
    {% if group_state == group_comp %}
    {% for states in argu %}
    - {{states}}
    {% endfor %}
    {% endif %}
    {% endfor %}
{% endfor %}
{% endfor %}

