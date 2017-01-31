ntp:
  pkg.installed:
    - name: {{ pillar['pkgs']['ntp'] }}
    - require:
      - sls: repository.client

/etc/ntp.conf:
  file:
    - managed
    - source: salt://ntp/ntp.conf.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['ntp'] }}

ntpd:
  service:
    - name: {{ pillar['services']['ntp'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/ntp.conf
    - require:
      - pkg: {{ pillar['pkgs']['ntp'] }}
      - file: /etc/ntp.conf

