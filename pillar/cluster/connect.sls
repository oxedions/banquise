connect:

# The services listed here are the Banquise default ones
# However, you can add a new one if you desire to use Banquise to handle one of your ip

# state_to_watch: state to watch, the ip will be the one of the host installing this state
# management:
#    "auto" let Banquise choose (will use state_to_watch to figure ip and hostname)
#    "external" set an external ip, to be used by clients. Banquise will not manage the server but user whish to use client side.
#    "link" mix between auto and external. Banquise will choose depending of state_to_watch, but will also configure the service (if compatible) to be connected to an external same service (recursive dns for example)
#    "none" do not use this service, ignored by Banquise and if client installed ip will be empty
# Banquise will create two values each time: ipname_ip and ipname_hostname
# for example, for dhcp_server, it will create dhcp_server_ip and dhcp_server_host

 dhcp_server:
   state_to_watch: dhcp.server
   management: auto
   ip_value:
   host_value:

# dns_server:
#   state_to_watch: dns.server
#   management: external
#   ip_value: 10.0.0.2
#   host_value: hostnametest

 dns_server:
   state_to_watch: dns.server
   management: link
   ip_value: 8.8.8.8
   host_value:

 repository_server:
   state_to_watch: repository.server
   management: auto
   ip_value:
   host_value:

 pxe_server:
   state_to_watch: pxe.server
   management: auto
   ip_value:
   host_value:

 ntp_server:
   state_to_watch: ntp.server
   management: auto
   ip_value:
   host_value:

 jobscheduler_server:
   state_to_watch: slurm.server
   management: auto
   ip_value:
   host_value:

 authentication_server:
   state_to_watch: ldap.server
   management: auto
   ip_value:
   host_value:

 monitoring_server:
   state_to_watch: shinken.server
   management: auto
   ip_value:
   host_value:
