sssd_package:
  pkg.installed:
    - name: {{ pillar['pkgs']['sssd'] }}
    - require:
      - sls: repository.client

enable_sssd:
  cmd.run:
    - name: authconfig --enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --update
    - unless: grep "USESSSDAUTH=yes" /etc/sysconfig/authconfig
    - require:
      - pkg: sssd_package

/etc/sssd/sssd.conf:
  file.managed:
    - source: salt://ldap/sssd.conf.jinja
    - template: jinja
    - mode: 600

nscd_service:
  service:
    - name: {{ pillar['services']['nscd'] }}
    - dead
    - Disabled: True
    - require:
      - cmd: enable_sssd

sssd_service:
  service:
    - name: {{ pillar['services']['sssd'] }}
    - running
    - enable: True
    - require:
      - file: /etc/sssd/sssd.conf
      - cmd: enable_sssd

