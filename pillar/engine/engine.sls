# THIS FILE SHOULD BE REMOVED SOON

{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/core.sls' as cor %}

helloworld: "Hey !!"

engine:

  network:
    domaine_name: {{ net.network.net0.domaine_name }}
    subnet: {{ net.network.net0.subnet }}
    netmask: {{ net.network.net0.netmask }}
    dhcp_unknown_range: {{ net.network.net0.dhcp_unknown_range }}
    {% set list1 = net.network.net0.subnet.split('.') %}
    {% if net.network.net0.netmask == '255.255.255.0' %}
    reverse: 1
    shortnetmask: 24
    matchpatern: "{{list1[0]}}.{{list1[1]}}.{{list1[2]}}"
    broadcast_address: {{list1[0]}}.{{list1[1]}}.{{list1[2]}}.255
    {% elif net.network.net0.netmask == '255.255.0.0' %}
    reverse: 2
    shortnetmask: 16
    matchpatern: "{{list1[0]}}.{{list1[1]}}"
    broadcast_address: {{list1[0]}}.{{list1[1]}}.225.255
    {% elif net.network.net0.netmask == '255.0.0.0' %}
    reverse: 3
    shortnetmask: 8
    matchpatern: "{{list1[0]}}"
    broadcast_address: {{list1[0]}}.255.225.255
    {% else %}
    reverse: unknown (banquise engine)
    shortnetmask: unknown (banquise engine)
    broadcast_address: unknown (banquise engine)
    {% endif %}

  master:
    # render master master ip and id
    {% set count = 1 %}{% if cor.core.master_mode == "standalone" %}
    {% for ma, args in mas.masters.items() %}
    {% if count == 1%}
    masterip: {{args.network.net0.ip}}
    masterid: {{ma}}
    {% endif %}
    {% endfor %}
    {% set count = 2 %}{% endif %}

  servers:
    {% set count = 1 %}{% if cor.core.master_mode == "standalone" %}
    {% for ma, args in mas.masters.items() %}
    {% if count == 1%}
    dhcp_server_ip: {{args.network.net0.ip}}
    dns_server_ip: {{args.network.net0.ip}}
    pxe_server_ip: {{args.network.net0.ip}}
    repository_server_ip: {{args.network.net0.ip}}
    ntp_server_ip: {{args.network.net0.ip}}
    ldap_server_ip: {{args.network.net0.ip}}     # change this to authentication server
    slurm_server_ip: {{args.network.net0.ip}}    # change this to jobscheduler server
    shinken_server_ip: {{args.network.net0.ip}}  # change this to monitoring server
    {% set count = 2 %}
    {% endif %}
    {% endfor %}
    {% endif %}
