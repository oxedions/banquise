core:

  cluster_name: banquise
  master_mode: standalone      # only standalone is available for now, using something else will result in crash
  domain_name: sphen.local
  salt_master_ip: 10.1.0.77    # ip of the saltmaster server
  pillar_path: /srv/pillar
  states_path: /srv/salt  
  types:                       # These are the types taken into account by Banquise
    - computes
    - logins
    - ios
    - switchs
  admin_network: net0
