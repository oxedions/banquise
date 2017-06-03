{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'engine/engine.sls' as eng %}

engine_reverse:

{% for master in mas.masters %}
  {{master}}.{{eng.engine.network.domaine_name}}:
    group: masters
    type: masters
{% endfor %}

{% for types in cor.core.types %}
{% import_yaml 'cluster/nodes/'~types~'.sls' as type %}
{% for ttype, argy in type.items() %}
{% for group, args in argy.items() %}
{% for node in args %}
  {{node}}.{{eng.engine.network.domaine_name}}:
    group: {{group}}
    type: {{types}}
{% endfor %}
{% endfor %}
{% endfor %}


{% endfor %}
