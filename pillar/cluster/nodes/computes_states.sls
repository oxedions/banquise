computes_states:

  standard:
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
    - shinken.client

  gpu:
    - repository.client
    - dns.client
    - ntp.client
#    - network.static
    - network.firewall
    - network.nmanager
    - shinken.client
    - ldap.client
#    - slurm.client
    - nfs.client
    - ssh.client

  smp:
    - repository.client
    - dns.client
    - ntp.client
    - network.static
    - network.firewall
    - network.nmanager
    - slurm.client
    - ldap.client
    - ssh.client
