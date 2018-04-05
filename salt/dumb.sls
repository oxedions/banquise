{% import 'include/myself.sls' as ms with context %}
/root/dumb.{{ms.type}}.{{ms.subtype}}:
  file:                                    
    - managed                               
    - source: salt://dumb.jinja 
    - template: jinja
    - defaults:
      custom_var: {{ms}}
