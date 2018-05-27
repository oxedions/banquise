{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/network.sls' as net %}

engine_reverse:

{% for master in mas.masters %}
  {{master}}.{{net.network.global_parameters.domain_name}}:
    subtype: {{master}}
    type: masters
{% endfor %}

{% for types in cor.core.types %}
{% import_yaml 'cluster/nodes/'~types~'.sls' as type %}
{% for ttype, argy in type.items() %}
{% for group, args in argy.items() %}
{% for node in args %}
  {{node}}.{{net.network.global_parameters.domain_name}}:
    subtype: {{group}}
    type: {{types}}
{% endfor %}
{% endfor %}
{% endfor %}


{% endfor %}
