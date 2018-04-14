{% import 'include/myself.sls' as ms with context %}
/root/dumb.{{ms.os}}.{{ms.os_release}}:
  file:                                    
    - managed                               
    - source: salt://dumb.jinja 
    - template: jinja
    - defaults:
      custom_var: {{ms}}
