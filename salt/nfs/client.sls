nfs_utils:
  pkg.installed:
    - name: {{ pillar['pkgs']['nfs_utils'] }}
    - require:
      - sls: repository.client

{% for nfsservid, args in salt['pillar.get']('nfs', {}).items() %}
{% for mountpoint, argus in args.items() %}
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
{% endfor %}{% endfor %}
