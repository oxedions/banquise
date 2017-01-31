/root/.ssh/id_rsa:
  file:                                    
    - managed                               
    - makedirs: True
    - source: salt://ssh/id_rsa.jinja 
    - template: jinja
    - user: root
    - group: root
    - mode: 600

/root/.ssh/id_rsa.pub:
  file:
    - managed
    - makedirs: True
    - source: salt://ssh/id_rsa.pub.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

restorecon_sshkey:
   cmd.run:
    - name: restorecon -r /root/.ssh
    - unless: test "$(restorecon -r -n /root/.ssh/ -v)" = ""
    - require:
      - file: /root/.ssh/id_rsa
      - file: /root/.ssh/id_rsa.pub
