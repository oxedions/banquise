{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'cluster/ip.sls' as ip %}

engine_ip:
# Forced ip are put directly, this is used in case of bug, or if you wish to use and external server
# Automatic ip are deduced depending of the values set into the cluster configuration (core, etc.)


{% for ips, args in ip.ip.items() %}

{% if args == "auto" %}
{% if cor.core.master_mode == "standalone" %}
{% set count = 1 %}
{% for ma, args in mas.masters.items() %}
  {{ips}}: {{args.network.net0.ip}}
{% set count = 2 %}
{% endfor %}
{% endif %}

{% else %}
  {{ips}}: {{args}}
{% endif %}

{% endfor %}


