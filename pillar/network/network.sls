# This file describe the network parameters of the cluster
# warning, Banquise does not accept other netmask than 255.255.0.0 for the time being

network:

  net0:                    # THIS NAME CANNOT BE CHANGED! net0 is the name for the admin network

    domaine_name: sphen.local
    subnet: 10.1.0.0
    netmask: 255.255.0.0                               # See warning above
    dhcp_unknown_range: 10.1.254.1 10.1.254.254

  ib0:

    subnet: 10.2.0.0
    netmask: 255.255.0.0

  net1:

    subnet: 192.168.0.0
    netmask: 255.255.0.0
