{% if salt['grains.get']('localhost') != salt['grains.get']('id') %}
sethostname:
  cmd.run:
    - name: hostnamectl set-hostname {{salt['grains.get']('id')}}
{% endif %}

{% set group = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':group') %}
{% set type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}

{% if type == "masters" %}
{% set netpath = type~":"~salt['grains.get']('host')~":network" %}
{% else %}
{% set netpath = type~":"~group~":"~salt['grains.get']('host')~":network" %}
{% endif %}
{% for network, argo in salt['pillar.get'](netpath).items() %}

{% if network == "net0" and argo.interface == "auto" %}
# auto interface enabled
{% for interf, args in salt['grains.get']('ip_interfaces').items() %}
{% for ips in args %}
{% if salt['pillar.get']('engine:network:matchpatern') in ips %}
{{interf}}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ips}}
    - netmask: {{salt['pillar.get']('engine:network:netmask')}}

{% endif %}
{% endfor %}
{% endfor %}
{% endif %}

{% if argo.interface != "auto" and argo.interface != "none" %}
{{argo.interface}}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{argo.ip}}
    - netmask: {{salt['pillar.get']("network:"~network~":netmask")}}
{% endif %}

{% endfor %}

