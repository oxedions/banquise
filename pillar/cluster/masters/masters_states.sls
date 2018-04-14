# WARNING: this pillar does not respect the banquise rendering order !!!!
# Need to solve this

{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'engine/engine.sls' as eng %}

masters_states:

{#  {% if cor.core.master_mode == "standalone" %} #}
{#  {{ eng.engine.master.masterid}}: #}
  management1:
    - repository.client
    - repository.server
    - dhcp.server 
    - dns.server
    - dns.client
    - network.firewall
    - network.nmanager
    - network.static
    - network.masquerading
    - ntp.server
    - slurm.server
    - ldap.server
    - ldap.phpldapadmin
    - ldap.client
    - pxe.server
    - nfs.server
    - ssh.master
    - shinken.server
    - shinken.client
#    - nyancat
{#  {% endif %} #}

