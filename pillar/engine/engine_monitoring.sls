# Experimental monitoring pillar
# Aim is to allow "packaged" states, so that states bring with them their monitoring instructions
# This pillar will try to read all monitoring files related tot states used, and provide them to the monitoring tool (default shinken)
# This pillar break the Salt Stack standard organisation, be carefull.

{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'cluster/masters/masters_states.sls' as mas %}


engine_monitoring:

 masters:
  masters:
{% for master, sta in mas.masters_states.items() %}
{% for st in sta %}
   {{st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}

{% for types in cor.core.types %}
{% import_yaml 'cluster/nodes/'~types~'_states.sls' as typestates %}
 {{types}}:
{% for ttypestates, stb in typestates.items() %}
{% for group, sta in stb.items() %}
  {{group}}:
{% if sta is not none %}
{% for st in sta %}
   {{st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}

