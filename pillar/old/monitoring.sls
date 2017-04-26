# Experimental monitoring pillar
# Aim is to allow "all in one" states, so that states bring with them their monitoring instructions
# This pillar will try to read all states used monitoring related files, and provide them to the monitoring tool (default shinken)
# This pillar break the Salt Stack standard organisation, be carefull.

{% import_yaml 'core.sls' as cor %}
{% import_yaml 'masters_states.sls' as mas %}
{% import_yaml 'computes_states.sls' as com %}
{% import_yaml 'logins_states.sls' as log %}
{% import_yaml 'ios_states.sls' as ios %}


monitoring:
 masters:
{% for master, sta in mas.masters_states.items() %}
{% for st in sta %}
  {{"master."~st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}
 computes:
#{% for compute, sta in com.computes_states.items() %}
#{% for st in sta %}
#  {{"computes."~st}}:
#{% endfor %}
#{% endfor %}
 logins:
{% for login, sta in log.logins_states.items() %}
{% for st in sta %}
  {{"logins."~st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}
 ios:
{% for ios, sta in ios.ios_states.items() %}
{% for st in sta %}
  {{"ios."~st}}:
{% include cor.core.states_path~"/"~(st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}
