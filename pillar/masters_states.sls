{% import_yaml 'core.sls' as cor %}
{% import_yaml 'engine/engine.sls' as eng %}

masters_states:

  {% if cor.core.master_mode == "standalone" %}
  {{ eng.engine.master.masterid}}:
    - repository.client
    - repository.server
    - dhcp.server 
    - dns.server
    - dns.client
    - network.firewall
    - network.nmanager
    - ntp.server
    - slurm.server
    - ldap.server
    - ldap.phpldapadmin
    - pxe.server
    - nfs.server
    - ssh.master
    - shinken.server
  {% endif %}
