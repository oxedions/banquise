# This file describe the network parameters of the cluster
# warning, Banquise does not accept other netmask than 255.255.0.0 for the time being

network:

  global_parameters:
    admin_network: net0
    external_dns:
      - 8.8.8.8
    domain_name: sphen.local

  net0:
    subnet: 10.1.0.0
    netmask: 255.255.0.0                               # See warning above
    dhcp:
      dhcp_unknown_range: 10.1.254.1 10.1.254.254        # nodes whose mac are not knowed will be put into this range
      gateway: 10.1.0.1

  net1:
    subnet: 10.10.0.0
    netmask: 255.255.0.0                               # See warning above
    dhcp:
      dhcp_unknown_range: 10.10.254.1 10.10.254.254        # nodes whose mac are not knowed will be put into this range
      gateway: 10.10.0.1

  ic0:
    subnet: 10.2.0.0
    netmask: 255.255.0.0

  net2:
    subnet: 172.16.0.0
    netmask: 255.255.0.0

  net3:
    subnet: 192.168.1.0
    netmask: 255.255.255.0
