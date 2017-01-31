restorecon_var_www:
   cmd.run:
    - name: restorecon -r /var/www
    - unless: test "$(restorecon -r -n /var/www/html/ -v)" = ""

webserver_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['webserver'] }}

webserver_service:
  service:
    - name: {{ pillar['services']['webserver'] }}
    - running
    - enable: True
    - require:
      - pkg: webserver_pkg

