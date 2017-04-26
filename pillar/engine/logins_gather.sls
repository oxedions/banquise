{% import_yaml 'nodes/logins.sls' as log %}
{% import_yaml 'nodes/logins_states.sls' as sta %}

logins_gather:

{% for group_log, args in log.logins.items() %}
#  {{group_log}}:
{% for node in args %}
  {{node}}:
    {% for group_state, argu in sta.logins_states.items() %}
    {% if group_state == group_log %}
    {% for states in argu %}
    - {{states}}
    {% endfor %}
    {% endif %}
    {% endfor %}
{% endfor %}
{% endfor %}

