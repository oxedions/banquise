{% for nfsservid, args in salt['pillar.get']('nfs', {}).items() %}
{% if salt['grains.get']('host') == nfsservid %}

nfs_utils:
  pkg.installed:
    - name: {{ pillar['pkgs']['nfs_utils'] }}
    - require:
      - sls: repository.client

/etc/exports:
  file:
    - managed
    - source: salt://nfs/exports.jinja
    - template: jinja

rpcbind:
  service:
    - name: {{ pillar['services']['rpcbind'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['nfs_utils'] }}

nfs_server:
  service:
    - name: {{ pillar['services']['nfs_server'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/exports
    - require:
      - pkg: {{ pillar['pkgs']['nfs_utils'] }}
      - file: /etc/exports
      - service: rpcbind

{% endif %}
{% endfor %}

