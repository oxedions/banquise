
{% import_yaml 'masters_states.sls' as mas %}

monitoring:
#  dhcpvalue: test
{% for master, sta in mas.masters_states.items() %}
{% for st in sta %}
{% include (st|replace(".","/"))~"_monitoring.sls" ignore missing %}
{% endfor %}
{% endfor %}
