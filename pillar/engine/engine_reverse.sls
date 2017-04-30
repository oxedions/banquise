{% import_yaml 'nodes/computes.sls' as com %}
{% import_yaml 'nodes/logins.sls' as log %}
{% import_yaml 'nodes/ios.sls' as ios %}
{% import_yaml 'masters.sls' as mas %}


engine_reverse:

{% for group_comp, args in com.computes.items() %}
{% for node in args %}
  {{node}}:
    group: {{group_comp}}
    type: computes
{% endfor %}
{% endfor %}

{% for group_login, args in log.logins.items() %}
{% for node in args %}
  {{node}}:
    group: {{group_login}}
    type: logins
{% endfor %}
{% endfor %}

{% for group_io, args in ios.ios.items() %}
{% for node in args %}
  {{node}}:
    group: {{group_io}}
    type: ios
{% endfor %}
{% endfor %}

{% for master in mas.masters %}
  {{master}}:
    group: masters
    type: masters
{% endfor %}



