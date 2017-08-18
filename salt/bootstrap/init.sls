sethostname:
   cmd.run:
    - name: hostnamectl set-hostname {{salt['grains.get'] ('id')}}
    - unless: test "$(hostname)" = "{{salt['grains.get'] ('id')}}" 

/etc/yum.repos.d/CentOS-Base.repo:
  file:
    - absent

/etc/yum.repos.d/CentOS-CR.repo:
  file:
    - absent

/etc/yum.repos.d/CentOS-Debuginfo.repo:
  file:
    - absent

/etc/yum.repos.d/CentOS-fasttrack.repo:
  file:
    - absent

/etc/yum.repos.d/CentOS-Sources.repo:
  file:
    - absent

/etc/yum.repos.d/CentOS-Vault.repo:
  file:
    - absent

/etc/yum.repos.d/salt.local.repo:
  file:                                    
    - managed                               
    - source: salt://bootstrap/salt.local.repo.jinja 
    - template: jinja

/etc/yum.repos.d/os_dvd.local.repo:
  file:
    - managed
    - source: salt://bootstrap/os_dvd.local.repo.jinja
    - template: jinja

salt-master:
  host.present:
    - ip: {{salt['pillar.get']('core:salt_master_ip')}}
    - names:
      - salt
      - salt-master  

salt-minion:
  pkg.installed:
    - name: {{ pillar['pkgs']['salt_minion'] }}
    - require:
      - file: /etc/yum.repos.d/salt.local.repo
      - file: /etc/yum.repos.d/os_dvd.local.repo
      - file: /etc/yum.repos.d/CentOS-Base.repo
      - file: /etc/yum.repos.d/CentOS-CR.repo
      - file: /etc/yum.repos.d/CentOS-Debuginfo.repo
      - file: /etc/yum.repos.d/CentOS-fasttrack.repo
      - file: /etc/yum.repos.d/CentOS-Sources.repo
      - file: /etc/yum.repos.d/CentOS-Vault.repo
        
salt-minion-service:
  service:
    - name: {{ pillar['services']['salt_minion'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['salt_minion'] }}
      - host: salt-master
      - cmd: sethostname

