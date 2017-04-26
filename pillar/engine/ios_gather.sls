{% import_yaml 'nodes/ios.sls' as io %}
{% import_yaml 'nodes/ios_states.sls' as sta %}

ios_gather:

{% for group_io, args in io.ios.items() %}
#  {{group_io}}:
{% for node in args %}
  {{node}}:
    {% for group_state, argu in sta.ios_states.items() %}
    {% if group_state == group_io %}
    {% for states in argu %}
    - {{states}}
    {% endfor %}
    {% endif %}
    {% endfor %}
{% endfor %}
{% endfor %}

