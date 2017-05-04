# This file describe the netowkr parameters of the cluster
# warning, Banquise does not accept other netmask than 255.255.255.0, 255.255.0.0 or 255.0.0.0 for the time being

network:

  domaine_name: sphen.local
  subnet: 10.1.0.0
  netmask: 255.255.0.0                               # !! See warning above
  dhcp_cluster_range: 10.1.254.1 10.1.254.254
