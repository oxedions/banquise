shinken_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken'] }}
    - require:
      - sls: repository.client

shinken_arbiter_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_arbiter'] }}
    - require:
      - sls: repository.client

shinken_broker_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_broker'] }}
    - require:
      - sls: repository.client

shinken_poller_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_poller'] }}
    - require:
      - sls: repository.client

shinken_reactionner_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_reactionner'] }}
    - require:
      - sls: repository.client

shinken_receiver_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_receiver'] }}
    - require:
      - sls: repository.client

shinken_scheduler_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_scheduler'] }}
    - require:
      - sls: repository.client

plugin_nrpe_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['plugin_nrpe'] }}
    - require:
      - sls: repository.client

/etc/shinken/hostgroups/cluster-groups.cfg:
  file:                                    
    - managed                               
    - source: salt://shinken/cluster-groups.cfg.jinja 
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

/etc/shinken/hosts/masters.cfg:
  file:
    - managed
    - source: salt://shinken/masters.cfg.jinja
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

/etc/shinken/hosts/computes.cfg:
  file:                                    
    - managed                               
    - source: salt://shinken/computes.cfg.jinja 
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

/etc/shinken/hosts/logins.cfg:
  file:
    - managed
    - source: salt://shinken/logins.cfg.jinja
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

/etc/shinken/hosts/ios.cfg:
  file:
    - managed
    - source: salt://shinken/ios.cfg.jinja
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

#/etc/shinken/servicegroups/servicegroup.cfg:
#  file:                                    
#    - managed                               
#    - source: salt://shinken/servicegroup.cfg.jinja 
#    - template: jinja
#    - requires:
#       - pkg: shinken_pkg
#       - pkg: shinken_arbiter_pkg
#       - pkg: shinken_broker_pkg
#       - pkg: shinken_poller_pkg
#       - pkg: shinken_reactionner_pkg
#       - pkg: shinken_receiver_pkg
#       - pkg: shinken_scheduler_pkg

/etc/shinken/services/services.cfg:
  file:                                    
    - managed                               
    - source: salt://shinken/services.cfg.jinja 
    - template: jinja
    - requires:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

#/etc/shinken/resource.d/paths.cfg:
#  file.line:
#    - mode: replace
#    - match: ^\$NAGIOSPLUGINSDIR\$
#    - content: '$NAGIOSPLUGINSDIR$=/usr/lib64/nagios/plugins/'
#    - require:
#       - pkg: shinken_pkg
#       - pkg: shinken_arbiter_pkg
#       - pkg: shinken_broker_pkg
#       - pkg: shinken_poller_pkg
#       - pkg: shinken_reactionner_pkg
#       - pkg: shinken_receiver_pkg
#       - pkg: shinken_scheduler_pkg

/etc/shinken/templates/templates.cfg:
  file.line:
    - mode: insert
    - after: ".*alias.*generic-host.*"
    - content: '            check_command                       check_ping'
    - require:
       - pkg: shinken_pkg
       - pkg: shinken_arbiter_pkg
       - pkg: shinken_broker_pkg
       - pkg: shinken_poller_pkg
       - pkg: shinken_reactionner_pkg
       - pkg: shinken_receiver_pkg
       - pkg: shinken_scheduler_pkg

shinken_scheduler_serv:
  service:
    - name: {{ pillar['services']['shinken_scheduler'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['shinken_scheduler'] }}

shinken_poller_serv:
  service:
    - name: {{ pillar['services']['shinken_poller'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['shinken_poller'] }}

shinken_reactionner_serv:
  service:
    - name: {{ pillar['services']['shinken_reactionner'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['shinken_reactionner'] }}

shinken_broker_serv:
  service:
    - name: {{ pillar['services']['shinken_broker'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['shinken_broker'] }}

shinken_arbiter_serv:
  service:
    - name: {{ pillar['services']['shinken_arbiter'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['shinken_arbiter'] }}
      - service: shinken_scheduler_serv
      - service: shinken_poller_serv
      - service: shinken_reactionner_serv
      - service: shinken_broker_serv
#      - file: /etc/shinken/services/services.cfg
      - file: /etc/shinken/hostgroups/cluster-groups.cfg
#      - file: /etc/shinken/servicegroups/servicegroup.cfg
      - file: /etc/shinken/hosts/computes.cfg
      - file: /etc/shinken/hosts/ios.cfg
      - file: /etc/shinken/hosts/logins.cfg


shinkeninit:
  cmd.run:
    - name: shinken --init
    - unless: test -e /root/.shinken.ini
    - require:
      - service: shinken_arbiter_serv

shinken_webui2_apache_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['apache'] }}
    - require:
      - sls: repository.client

shinken_webui2_pkg:
  pkg.installed:
    - name: {{ pillar['pkgs']['shinken_webui2'] }}
    - require:
      - service: shinken_arbiter_serv
      - cmd: shinkeninit
      - pkg: shinken_webui2_apache_pkg
      - sls: repository.client

/etc/shinken/brokers/broker-master.cfg:
  file.line:
    - mode: replace
    - match: '\ \ \ \ modules'
    - content: '    modules webui2'
    - require:
      - pkg: shinken_webui2_pkg

shinken_mongodb_serv:
  service:
    - name: {{ pillar['services']['mongodb_server'] }}
    - running
    - enable: True
    - require:
      - pkg: shinken_webui2_pkg

shinken_broker_webui2_serv:
  service:
    - name: {{ pillar['services']['shinken_broker'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/shinken/brokers/broker-master.cfg
    - require:
      - pkg: {{ pillar['pkgs']['shinken_broker'] }}
      - service: shinken_mongodb_serv

shinken_apache_webui2_serv:
  service:
    - name: {{ pillar['services']['apache'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/shinken/brokers/broker-master.cfg
    - require:
      - pkg: {{ pillar['pkgs']['apache'] }}

