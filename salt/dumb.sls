{% for specie in animal %}
  /root/dumb.{{specie}}:
    file:                                    
      - managed                               
      - source: salt://dumb.jinja 
      - template: jinja
      - defaults:
        custom_var: "default value"
{% endfor %}
