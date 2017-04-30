nrpe_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['nrpe'] }}

monitoring_proc_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['monitoring_proc'] }}

{% for node, argu in salt['pillar.get']('engine_reverse', {}).items() %}{# Node check which type and which group it belongs #}
{% if node~"."~salt['pillar.get']('network:domaine_name') == salt['grains.get']('id') %}{# Node found herself #}

{%if salt['pillar.get']('monitoring:default_probs:'~argu.type~':disk') %}

monitoring_disk_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['monitoring_disk'] }}

disk_1:
  file.append:
    - name: /etc/nrpe.d/commands.cfg
    - text: 'command[check_disk_root]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p / -m'
    - unless: grep "check_disk_root" /etc/nrpe.d/commands.cfg

disk_2:
  file.line:
    - name: /etc/nrpe.d/commands.cfg
    - mode: replace
    - content: 'command[check_disk_root]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p / -m'
    - match: ".*check_disk_root.*"
{% endif %}

{%if salt['pillar.get']('monitoring:default_probs:'~argu.type~':zombie') %}
zombie_1:
  file.append:
    - name: /etc/nrpe.d/commands.cfg
    - text: 'command[check_proc_zombie]=/usr/lib64/nagios/plugins/check_procs -w 5 -c 10 -s Z'
    - unless: grep "check_proc_zombie" /etc/nrpe.d/commands.cfg

zombie_2:
  file.line:
    - name: /etc/nrpe.d/commands.cfg
    - mode: replace
    - content: 'command[check_proc_zombie]=/usr/lib64/nagios/plugins/check_procs -w 5 -c 10 -s Z'
    - match: ".*check_proc_zombie.*"
{% endif %}

{% if salt['pillar.get']('monitoring:parameters:enable_states_probs') %}
{% for state, args in salt['pillar.get']('engine_monitoring:'~argu.type~":"~argu.group, {}).items() %}{% if args is not none %}{% for element, argo in args.items() %}{# Node now check for each state in its type:group if there something to do. All of this is listed in engine_monitoring virtual pillar #}

{% if element == "command" %}

{{argo.command_name}}_{{state}}1:
  file.append:
    - name: /etc/nrpe.d/commands.cfg
    - text: 'command[{{argo.command_name}}]={{argo.command_path}} {{argo.command_arguments}}'
    - unless: grep {{argo.command_name}} /etc/nrpe.d/commands.cfg

{{argo.command_name}}_{{state}}2:
  file.line:
    - name: /etc/nrpe.d/commands.cfg
    - mode: replace
    - content: 'command[{{argo.command_name}}]={{argo.command_path}} {{argo.command_arguments}}'
    - match: ".*{{argo.command_name}}.*"

{% endif %}

{% endfor %}

{% endif %}{% endfor %}
{% endif %}


{% endif %}
{% endfor %}
 
nrpeservice:
  service:
    - name: {{ pillar['services']['nrpe'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['nrpe'] }}

