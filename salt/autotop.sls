base:

# masters
{% for master in salt['pillar.get']('masters') %}  '{{master}}.{{salt['pillar.get']('network:domaine_name')}}':
    - repository/client
    - repository/server
    - dhcp/server 
{% endfor %}

# compute nodes
{% for host in salt['pillar.get']('computes') %}  '{{host}}.{{salt['pillar.get']('network:domaine_name')}}':
    - dumb
{% endfor %}

