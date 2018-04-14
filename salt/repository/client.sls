{% import 'include/myself.sls' as ms with context %}


/etc/yum.repos.d/os_base.local.repo:
  file:
    - managed
    - source: salt://repository/genericwithupdate.local.repo.jinja
    - template: jinja
    - defaults:
        reponame: {{ms.os}}_{{ms.os_release}}

#/etc/yum.repos.d/{{ms.os}}_{{ms.os_release}}.local.repo:
#  file:
#    - managed
#    - source: salt://repository/os_dvd.local.repo.jinja
#    - template: jinja
#    - defaults:
#        os: {{ms.os}}
#        os_release: {{ms.os_release}}

/etc/yum.repos.d/banquise.local.repo:
  file:
    - managed
    - source: salt://repository/banquise.local.repo.jinja
    - template: jinja
    - defaults:
        os: {{ms.os}}
        os_release: {{ms.os_release}}

/etc/yum.repos.d/salt.local.repo:
  file:
    - managed
    - source: salt://repository/salt.local.repo.jinja
    - template: jinja
    - defaults:
        os: {{ms.os}}
        os_release: {{ms.os_release}}

    
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

