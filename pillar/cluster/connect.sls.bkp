connect:

# The services listed here are the Banquise default ones
# However, you can add a new one if you desire to use Banquise to handle one of your iop

  managed_services:

# state_to_watch: state to watch, the ip will be the one of the host installing this state
# management:
#    "auto" let Banquise choose (will use state_to_watch to figure ip and hostname)
#    "external" set an external ip, to be used by clients. Banquise will not manage the server and ignore it.
#    "none" do not use this service, ignored by Banquise and if client installed ip will be empty
# ip_value can accept multiple ip, juste use the following format:
# ip_value:
#   - 10.1.0.1
#   - 10.1.0.2
# Banquise will create two values each time: ipname_ip and ipname_hostname
# for example, for dhcp_server, it will create dhcp_server_ip and dhcp_server_host

   dhcp_server:
     state_to_watch: dhcp.server
     management: auto
     ip_value:
     host_value:

   dns_server:
     state: dns.server
     management: auto
       ip_name: dns_server_ip
       ip_value:
       hostname_name: dns_server
       hostname_value:

   pxe_server:
     state: pxe.server
     management: auto
       ip_name: pxe_server_ip
       ip_value:
       hostname_name: pxe_server
       hostname_value:

   repository_server:
     state: repository.server
     management: auto
       ip_name: repository_server_ip
       ip_value:
       hostname_name: repository_server
       hostname_value:

   ntp_server:
     state: ntp.server
     management: auto
       ip_name: ntp_server_ip
       ip_value:
       hostname_name: ntp_server
       hostname_value:

   authentication_server:
     state: ldap.server
     management: auto
       ip_name: authentication_server_ip
       ip_value:
       hostname_name: authentication_server
       hostname_value:

   jobscheduler_server:
     state: slurm.server
     management: auto
       ip_name: jobscheduler_server_ip
       ip_value:
       hostname_name: jobscheduler_server
       hostname_value:

   monitoring_server:
     state: shinken.server
     management: auto
       ip_name: monitoring_server_ip
       ip_value:
       hostname_name: monitoring_server
       hostname_value:

