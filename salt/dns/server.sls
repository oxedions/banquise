<<<<<<< HEAD
dns:
  pkg.installed:
    - name: {{ pillar['pkgs']['dns'] }}
    - require:
      - sls: repository.client
        
/etc/named.conf:
  file:                                    
    - managed                               
    - source: salt://dns/named.conf.jinja 
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}

/var/named/forward:
  file:
    - managed
    - source: salt://dns/forward.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}

{% for network, args in salt['pillar.get']('network').items() %}
/var/named/reverse.{{network}}:
  file:
    - managed
    - source: salt://dns/reverse.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}
    - defaults:
        net: {{network}}
{% endfor %}

named:
  service:
    - name: {{ pillar['services']['dns'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/named.conf
      - file: /var/named/forward
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}
      - file: /etc/named.conf
      - file: /var/named/forward

=======
dns:
  pkg.installed:
    - name: {{ pillar['pkgs']['dns'] }}
    - require:
      - sls: repository.client
        
/etc/named.conf:
  file:                                    
    - managed                               
    - source: salt://dns/named.conf.jinja 
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}

/var/named/forward:
  file:
    - managed
    - source: salt://dns/forward.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}

/var/named/reverse:
  file:
    - managed
    - source: salt://dns/reverse.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}

named:
  service:
    - name: {{ pillar['services']['dns'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/named.conf
      - file: /var/named/forward
      - file: /var/named/reverse
    - require:
      - pkg: {{ pillar['pkgs']['dns'] }}
      - file: /etc/named.conf
      - file: /var/named/forward
      - file: /var/named/reverse

>>>>>>> fd940a25f1140ac17f02364496b45f25fb24a45f
