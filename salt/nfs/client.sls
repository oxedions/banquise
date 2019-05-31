{% set host_type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}
{% set host_subtype = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':subtype') %}
nfs_utils:
  pkg.installed:
    - name: {{ pillar['pkgs']['nfs_utils'] }}
    - require:
      - sls: repository.client

{% for nfsservid, nfsservid_args in salt['pillar.get']('nfs', {}).items() %}
{% for mountpoint, mountpoint_args in nfsservid_args.items() %}
{% if (host_type~':'~host_subtype) in mountpoint_args.mountpool %}
{{mountpoint}}:
  mount.mounted:
{%- if mountpoint_args.network == "net0" %}
    - device: {{nfsservid}}:{{mountpoint_args.servermountpoint}}
{%- else %}
    - device: {{nfsservid}}.{{mountpoint_args.network}}:{{mountpoint_args.servermountpoint}}
{%- endif %}
    - fstype: nfs
    - persist: True
    - mkmnt: True
    - opts: {{mountpoint_args.mount_parameters}}
    - require:
      - pkg: nfs_utils
      - sls: dns.client
{% endif %}
{% endfor %}{% endfor %}
