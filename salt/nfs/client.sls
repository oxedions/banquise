<<<<<<< HEAD
{% set host_type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}
{% set host_group = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':group') %}
nfs_utils:
  pkg.installed:
    - name: {{ pillar['pkgs']['nfs_utils'] }}
#    - require:
#      - sls: repository.client

{% for nfsservid, args in salt['pillar.get']('nfs', {}).items() %}
{% for mountpoint, argus in args.items() %}
{% if (host_type~':'~host_group) in argus.mountpool %}
{{mountpoint}}:
  mount.mounted:
{%- if argus.network == "net0" %}
    - device: {{nfsservid}}:{{argus.servermountpoint}}
{%- else %}
    - device: {{nfsservid}}.{{argus.network}}:{{argus.servermountpoint}}
{%- endif %}
    - fstype: nfs
    - persist: True
    - mkmnt: True
    - require:
      - pkg: nfs_utils
      - sls: dns.client
{% endif %}
{% endfor %}{% endfor %}
=======
nfs_utils:
  pkg.installed:
    - name: {{ pillar['pkgs']['nfs_utils'] }}
    - require:
      - sls: repository.client

{% for nfsservid, args in salt['pillar.get']('nfs', {}).items() %}
{% for mountpoint, argus in args.items() %}
{{mountpoint}}:
  mount.mounted:
    - device: {{nfsservid}}:{{argus.servermountpoint}}
    - fstype: nfs
    - persist: True
    - mkmnt: True
    - require:
      - pkg: nfs_utils
      - sls: dns.client
{% endfor %}{% endfor %}
>>>>>>> fd940a25f1140ac17f02364496b45f25fb24a45f
