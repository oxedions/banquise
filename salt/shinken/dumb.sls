  /root/dumb:
    file:                                    
      - managed                               
      - source: salt://shinken/services.cfg.jinja 
      - template: jinja


