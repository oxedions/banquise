{% if salt['grains.get']('localhost') != salt['grains.get']('id') %}
sethostname:
  cmd.run:
    - name: hostnamectl set-hostname {{salt['grains.get']('id')}}
{% endif %}

{% set group = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':subtype') %}
{% set type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}


{% if type == "masters" %}
{% set netpath = type~":"~(salt['grains.get']('id')|replace("."~salt['pillar.get']('engine:network:domaine_name'),''))~":network" %}
{% else %}
{% set netpath = type~":"~group~":"~(salt['grains.get']('id')|replace("."~salt['pillar.get']('engine:network:domaine_name'),''))~":network" %}
{% endif %}

{% for network, argo in salt['pillar.get'](netpath).items() %}

{% if network ==  salt['pillar.get']('core:admin_network') and argo.interface == "auto" %}
# auto interface enabled
{% for interf, args in salt['grains.get']('ip4_interfaces').items() %}
{% for ips in args %}
{% if salt['pillar.get']("engine_network:"~network~":matchpatern") in ips %}
{{interf}}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ips}}
    - netmask: {{salt['pillar.get']("engine_network:"~network~":netmask")}}
{% if salt['pillar.get']("engine_network:"~network~":gateway") is defined %}
    - gateway: {{salt['pillar.get']("engine_network:"~network~":gateway")}}
{% endif %}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}

{% if argo.interface != "auto" and argo.interface != "na" %}
{{argo.interface}}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{argo.ip}}
    - netmask: {{salt['pillar.get']("engine_network:"~network~":netmask")}}  {#"network:"~network~":netmask")}}#}
{% if salt['pillar.get']("engine_network:"~network~":gateway") is defined and  salt['pillar.get']("engine_network:"~network~":gateway") is not none %}
    - gateway: {{salt['pillar.get']("engine_network:"~network~":gateway")}}
{% endif %}

{% endif %}

{% endfor %}

