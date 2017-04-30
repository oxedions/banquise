# Experimental monitoring pillar
# Aim is to allow "packaged" states, so that states bring with them their monitoring instructions
# This pillar will try to read all monitoring files related tot states used, and provide them to the monitoring tool (default shinken)
# This pillar break the Salt Stack standard organisation, be carefull.

{% import_yaml 'core.sls' as cor %}
{% import_yaml 'masters_states.sls' as mas %}
{% import_yaml 'nodes/computes_states.sls' as com %}
{% import_yaml 'nodes/logins_states.sls' as log %}
{% import_yaml 'nodes/ios_states.sls' as ios %}


engine_monitoring:

 masters:
{% for master, sta in mas.masters_states.items() %}
{% for st in sta %}
  {{"master."~st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}

 computes:
{% for compute, sta in com.computes_states.items() %}
  {{compute}}:
{% for st in sta %}
   {{st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}

 logins:
{% for login, sta in log.logins_states.items() %}
  {{login}}:
{% for st in sta %}
   {{st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}

 ios:
{% for io, sta in ios.ios_states.items() %}
  {{io}}:
{% for st in sta %}
   {{st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}
