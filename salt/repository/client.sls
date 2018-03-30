{% set type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}
{% set subtype = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':subtype') %}
{% set os = salt['pillar.get'](type~'_system:'~subtype~':os') %}
{% set os_release = salt['pillar.get'](type~'_system:'~subtype~':os_release') %}

/etc/yum.repos.d/{{os}}_{{os_release}}.local.repo:
  file:
    - managed
    - source: salt://repository/os_dvd.local.repo.jinja
    - template: jinja
    - defaults:
        os: {{os}}
        os_release: {{os_release}}

/etc/yum.repos.d/banquise.local.repo:
  file:
    - managed
    - source: salt://repository/banquise.local.repo.jinja
    - template: jinja
    - defaults:
        os: {{os}}
        os_release: {{os_release}}

/etc/yum.repos.d/salt.{{os}}_{{os_release}}.local.repo:
  file:
    - managed
    - source: salt://repository/salt.local.repo.jinja
    - template: jinja
    - defaults:
        os: {{os}}
        os_release: {{os_release}}

    
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

