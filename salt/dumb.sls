  /root/dumb:
    file:                                    
      - managed                               
      - source: salt://dumb.jinja 
      - template: jinja
      - defaults:
        custom_var: "default value"

