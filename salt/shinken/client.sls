nrpe_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['nrpe'] }}

monitoring_proc_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['monitoring_proc'] }}


/etc/nagios/nrpe.cfg:
  file.line:
    - mode: replace
    - match: '.*allowed_hosts=127.0.0.1.*'
    - content: allowed_hosts=127.0.0.1,{{salt['pillar.get']('engine_connect:monitoring_server_ip')}}
    - require:
      - pkg: nrpe_pkg

restorecon_nrpe.cfg:
   cmd.run:
    - name: restorecon /etc/nagios/nrpe.cfg
    - unless: test "$(restorecon -r -n /etc/nagios/nrpe.cfg -v)" = ""

{% if salt['pillar.get']('monitoring:default_probs:'~salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type')~':disk') %}

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

{% if salt['pillar.get']('monitoring:default_probs:'~salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type')~':zombie') %}

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

{% for state, args in salt['pillar.get']('engine_monitoring:'~salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type')~":"~salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':group'), {}).items() %}
{% if args is not none %}
{% for element, argo in args.items() %}    {# Node now check for each state in its type:group if there something to do. All of this is listed in engine_monitoring virtual pillar #}

{% if element == "command" %}
{% for command, argy in argo.items() %}
{{argy.command_name}}_{{state}}1:
  file.append:
    - name: /etc/nrpe.d/commands.cfg
    - text: 'command[{{argy.command_name}}]={{argy.command_path}} {{argy.command_arguments}}'
    - unless: grep {{argy.command_name}} /etc/nrpe.d/commands.cfg

{{argy.command_name}}_{{state}}2:
  file.line:
    - name: /etc/nrpe.d/commands.cfg
    - mode: replace
    - content: 'command[{{argy.command_name}}]={{argy.command_path}} {{argy.command_arguments}}'
    - match: ".*{{argy.command_name}}.*"

{% endfor %}
{% endif %}

{% endfor %}

{% endif %}{% endfor %}
{% endif %}
 
nrpeservice:
  service:
    - name: {{ pillar['services']['nrpe'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/nrpe.d/commands.cfg
      - file: /etc/nagios/nrpe.cfg
    - require:
      - pkg: nrpe_pkg
      - file: /etc/nagios/nrpe.cfg
      - cmd: restorecon_nrpe.cfg
