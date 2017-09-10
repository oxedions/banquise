dhcp:
  pkg.installed:
    - name: {{ pillar['pkgs']['dhcp'] }}
    - require:
      - sls: repository.client
        
/etc/dhcp/dhcpd.conf:
  file:                                    
    - managed                               
    - source: salt://dhcp/dhcpd.conf.jinja 
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['dhcp'] }}

dhcpd:
  service:
    - name: {{ pillar['services']['dhcp'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/dhcp/dhcpd.conf
    - require:
      - pkg: {{ pillar['pkgs']['dhcp'] }}
      - file: /etc/dhcp/dhcpd.conf

