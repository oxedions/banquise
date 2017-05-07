core:

  cluster_name: banquise
  master_mode: standalone      # only standalone is available for now, using something else will result in crash
  salt_master_ip: 10.1.0.77    # ip of the saltmaster server
  pillar_path: /srv/pillar
  states_path: /srv/salt  
  types:
    - computes
    - logins
    - ios
    - switchs
