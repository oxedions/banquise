# This file describe the network parameters of the cluster

networks:

  net0:
    subnet: 10.10.0.0
    netmask: 255.255.0.0                               # See warning above
    dhcp:
      
      dhcp_unknown_range: 10.10.254.1 10.10.254.254        # nodes whose mac are not knowed will be put into this range
    gateway: 10.10.0.1
    services:
       pxe_server_ip: 10.10.0.1
       repositories_server_ip: 10.10.0.1
