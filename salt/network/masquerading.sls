# On the fly masquerading, not persistent.

{% set group = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':subtype') %}
{% set type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}


{% if type == "masters" %}
{% set netpath = type~":"~(salt['grains.get']('id')|replace("."~salt['pillar.get']('engine:network:domaine_name'),'')) %}
{% else %}
{% set netpath = type~":"~group~":"~(salt['grains.get']('id')|replace("."~salt['pillar.get']('engine:network:domaine_name'),'')) %}
{% endif %}


{% if salt['pillar.get'](netpath~':external_interface') is defined and salt['pillar.get'](netpath~':external_interface') is not none %}
non_persistent_ipforward:
  cmd.run:
    - name: sysctl -w net.ipv4.ip_forward=1

# {{salt['pillar.get'](netpath~':external_interface')}}
non_persistent_masquerading:
  cmd.run:
    - name: iptables -t nat -A POSTROUTING -o {{salt['pillar.get'](netpath~':external_interface')}} -j MASQUERADE

{% endif %}
