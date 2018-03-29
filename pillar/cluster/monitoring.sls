# Should migrate to system files...
monitoring:

  parameters:
    
    enable_states_probs: true

  default_probs:

    masters:
      disk: true
      zombie: false
      
    computes:
      disk: true
      zombie: true

    logins:
      disk: true
      zombie: true

    ios:
      disk: true
      zombie: false

