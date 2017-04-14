{% import_yaml 'ios.sls' as ioss %}


ios_states:

  {% for io in ioss.ios %}
  {{ io }}:
    - repository.client
    - dns.client
    - ntp.client
    - network.static
    - network.firewall
    - network.nmanager
    - nfs.server
    - ldap.client
    - ssh.client
  {% endfor %}
