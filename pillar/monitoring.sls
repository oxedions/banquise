monitoring:

  parameters:
    
    enable_states_probs: true

  default_probs:

    masters:
      disk: true
      zombies: false
      
    computes:
      disk: true
      zombies: true

    logins:
      disk: true
      zombies: true

    ios:
      disk: true
      zombies: false

