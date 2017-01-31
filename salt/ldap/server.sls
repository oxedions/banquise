ldap_server:
  pkg.installed:
    - name: {{ pillar['pkgs']['ldap_server'] }}
    - require:
      - sls: repository.client

ldap_client:
  pkg.installed:
    - name: {{ pillar['pkgs']['ldap_client'] }}
    - require:
      - sls: repository.client

/var/lib/ldap/DB_CONFIG:
  file.copy:
    - source: /usr/share/openldap-servers/DB_CONFIG.example
    - unless: test -e /var/lib/ldap/DB_CONFIG
    - user: ldap
    - group: ldap
    - require:
      - pkg: ldap_server
      - pkg: ldap_client

ldap_service:
  service:
    - name: {{ pillar['services']['ldapserver'] }}
    - running
    - enable: True
    - require:
      - file: /var/lib/ldap/DB_CONFIG

/root/chdomain.ldif:
  file.managed:
    - source: salt://ldap/chdomain.ldif.jinja
    - template: jinja
    - mode: '0644'

/root/basedomain.ldif:
  file.managed:
    - source: salt://ldap/basedomain.ldif.jinja
    - template: jinja
    - mode: '0644'

cosine.ldif:
  cmd.run:
    - name: ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    - unless: test -e /etc/openldap/slapd.d/cn=config/cn=schema/cn={1}cosine.ldif
    - require:
      - service: ldap_service

nis.ldif:
  cmd.run:
    - name: ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    - unless: test -e /etc/openldap/slapd.d/cn=config/cn=schema/cn={2}nis.ldif
    - require:
      - cmd: cosine.ldif

inetorgperson.ldif:
  cmd.run:
    - name: ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    - unless: test -e /etc/openldap/slapd.d/cn=config/cn=schema/cn={3}inetorgperson.ldif
    - require:
      - cmd: nis.ldif

chdomain.ldif:
  cmd.run:
    - name: ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif
    - unless: grep RootPW /etc/openldap/slapd.d/cn=config/olcDatabase={2}hdb.ldif
    - require:
      - cmd: inetorgperson.ldif
      - file: /root/chdomain.ldif

basedomain.ldif: ### Need to be corrected
  cmd.run:
    - name: ldapadd -x -D cn=Manager{% for dc in pillar['ldap_public']['dc'] %},dc={{dc}}{% endfor %} -w {{ pillar['ldap_private']['ldap_admin_pass'] }} -f basedomain.ldif
    - unless: test $(($(ldapsearch -x -b "dc=sphen,dc=local" | grep People > /dev/null 2>&1; echo $?) + $(ldapsearch -x -b "dc=sphen,dc=local" | grep Group > /dev/null 2>&1; echo $?) )) = 0
    - onlyif: test $(systemctl status slapd > /dev/null 2>&1; echo $?) = 0
    - require:
      - cmd: chdomain.ldif
      - file: /root/basedomain.ldif

