{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/core.sls' as cor %}

engine_network:
{% for network, network_args in net.network.items() %}
{% if network != "global_parameters" %}

  {{network}}:
    subnet: {{ network_args.subnet }}
    netmask: {{ network_args.netmask }}
    {% if network_args.dhcp is defined and network_args.dhcp is not none %}
    dhcp_on: true
    dhcp_unknown_range: {{ network_args.dhcp.dhcp_unknown_range }}
    gateway: {{ network_args.dhcp.gateway }}
    {% else %}
    dhcp_on: false
    {% endif %}
  {% set list1 = network_args.subnet.split('.') %}   # very basic intelligence, need to enhance this
  {% if network_args.netmask == '255.255.255.0' %}
    reverse: 1
    shortnetmask: 24
    matchpatern: "{{list1[0]}}.{{list1[1]}}.{{list1[2]}}"
    broadcast_address: {{list1[0]}}.{{list1[1]}}.{{list1[2]}}.255
  {% elif network_args.netmask == '255.255.0.0' %}
    reverse: 2
    shortnetmask: 16
    matchpatern: "{{list1[0]}}.{{list1[1]}}"
    broadcast_address: {{list1[0]}}.{{list1[1]}}.225.255
  {% elif network_args.netmask == '255.0.0.0' %}
    reverse: 3
    shortnetmask: 8
    matchpatern: "{{list1[0]}}"
    broadcast_address: {{list1[0]}}.255.225.255
  {% endif %}

{% endif %}
{% endfor %}
