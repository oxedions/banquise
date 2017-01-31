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

{% if salt['grains.get']('localhost') != salt['grains.get']('id') %}
sethostname:
  cmd.run:
    - name: hostnamectl set-hostname {{salt['grains.get']('id')}}
{% endif %}

