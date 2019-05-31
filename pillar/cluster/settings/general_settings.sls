general_settings:

  ##########################
  # General settings
  ###

  cluster_name: banquise
  domain_name: sphen.local
  time_zone: America/New_York
#  language: us # us, fr, etc
#  keyboard: us

  ##########################
  # Salt settings
  ###

  salt_master_ip: 10.1.0.77    # ip of the saltmaster server
  pillar_path: /srv/pillar
  states_path: /srv/salt

  nodes_groups:
    - managements
#    - computes
