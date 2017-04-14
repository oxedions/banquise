{% import_yaml 'logins.sls' as log %}


logins_states:

  {% for lo in log.logins %}
  {{ lo }}:
    - repository.client
    - dns.client
    - ntp.client
    - network.static
    - network.firewall
    - network.nmanager
    - slurm.login
    - nfs.client
    - ldap.client
    - ssh.client
    - nyancat
  {% endfor %}
