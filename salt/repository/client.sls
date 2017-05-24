/etc/yum.repos.d/os_dvd.local.repo:
  file:                                    
    - managed                               
    - source: salt://repository/os_dvd.local.repo.jinja 
    - template: jinja

/etc/yum.repos.d/banquise.local.repo:
  file:
    - managed
    - source: salt://repository/banquise.local.repo.jinja
    - template: jinja

/etc/yum.repos.d/salt.local.repo:
  file:
    - managed
    - source: salt://repository/salt.local.repo.jinja
    - template: jinja
    
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

/etc/yum.repos.d/os_dvd.local.reposerver.repo:
  file:
    - absent

