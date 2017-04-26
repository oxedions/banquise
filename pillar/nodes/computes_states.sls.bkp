{% import_yaml 'computes.sls' as com %}


computes_states:

  {% for co in com.computes %}
  {{ co }}:
    - repository.client
    - dns.client
    - ntp.client
    - network.static
    - network.firewall
    - network.nmanager
    - slurm.client
    - nfs.client
    - ldap.client
    - ssh.client
  {% endfor %}
