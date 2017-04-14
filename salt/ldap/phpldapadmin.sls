webserver_pkg_ldap:
  pkg.installed:
    - name: {{ pillar['pkgs']['webserver'] }}
    - require:
      - sls: repository.client

phpldapadmin:
  pkg.installed:
    - name: {{ pillar['pkgs']['phpldapadmin'] }}
    - require:
      - sls: repository.client

/etc/phpldapadmin/config.php_comment:
  file.comment:
    - name: /etc/phpldapadmin/config.php
    - char: //
    - regex: ^\$servers\-\>setValue\('login','attr','uid'\);
    - require:
      - pkg: phpldapadmin

/etc/phpldapadmin/config.php_uncomment:
  file.uncomment:
    - name: /etc/phpldapadmin/config.php
    - char: //
    - regex: \$servers\-\>setValue\('login','attr','dn'\);
    - require:
      - file: /etc/phpldapadmin/config.php_comment

/etc/httpd/conf.d/phpldapadmin.conf:
  file.line:
    - mode: replace
    - match: Allow from 127.0.0.1
    - content: Allow from 127.0.0.1 {{ pillar['core']['salt_master_ip'] }}
    - require:
      - pkg: phpldapadmin

enableaccess:
  cmd.run:
    - name: setsebool httpd_can_connect_ldap 1
    - onlyif: getsebool -a | grep httpd_can_connect_ldap | grep off
    - require:
      - pkg: phpldapadmin

webserver_service_ldap:
  service:
    - name: {{ pillar['services']['webserver'] }}
    - running
    - enable: True
    - require:
      - pkg: webserver_pkg
      - file: /etc/phpldapadmin/config.php_comment
      - file: /etc/phpldapadmin/config.php_uncomment
      - file: /etc/httpd/conf.d/phpldapadmin.conf
      - cmd: enableaccess
    - watch:
      - file: /etc/phpldapadmin/config.php_comment
      - file: /etc/phpldapadmin/config.php_uncomment
      - file: /etc/httpd/conf.d/phpldapadmin.conf
      - cmd: enableaccess

