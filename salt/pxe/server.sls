{% import 'include/myself.sls' as ms with context %}

# Please note that this state is based on RHEL documentation:
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-installation-server-setup

pxe_packages:
  pkg.installed:
    - pkgs:
      - {{ pillar['pkgs']['tftp'] }}
      - {{ pillar['pkgs']['tftpserver'] }}
      #- {{ pillar['pkgs']['syslinux'] }}
      - {{ pillar['pkgs']['webserver'] }}
      - banquise_syslinux
#    - require:
#      - sls: repository.client

/var/lib/tftpboot/pxelinux.0:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/pxelinux.0
    - unless: test -e /var/lib/tftpboot/pxelinux.0
    - makedirs: True
    - require:
      - pkg: pxe_packages

/var/lib/tftpboot/menu.c32:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/menu.c32
    - unless: test -e /var/lib/tftpboot/menu.c32
    - makedirs: True
    - require:
      - pkg: pxe_packages

/var/lib/tftpboot/ldlinux.c32:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/ldlinux.c32
    - unless: test -e /var/lib/tftpboot/ldlinux.c32
    - makedirs: True
    - require:
      - pkg: pxe_packages

/var/lib/tftpboot/memdisk:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/memdisk
    - unless: test -e /var/lib/tftpboot/memdisk
    - makedirs: True
    - require:
      - pkg: pxe_packages

/var/lib/tftpboot/mboot.c32:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/mboot.c32
    - unless: test -e /var/lib/tftpboot/mboot.c32
    - makedirs: True
    - require:
      - pkg: pxe_packages

/var/lib/tftpboot/chain.c32:
   file.copy:
    - source: /banquise/syslinux/usr/share/syslinux/chain.c32
    - unless: test -e /var/lib/tftpboot/chain.c32
    - makedirs: True
    - require:
      - pkg: pxe_packages


#### From here, pxe files are "targeted OS" dependant
#### Loop on type/subtypes, and check for for os and os_release

{% for type in salt['pillar.get']('core:types') %}
{% for subtype, subtype_args in salt['pillar.get'](type, {}).items() %}

# Check system is set for this type/subtype

{% if salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') is defined and salt['pillar.get'](type~'_system:'~subtype~':operating_system:os_release') is defined and salt['pillar.get'](type~'_system:'~subtype~':operating_system:boot_mode') is defined %}

# Check os

########################
### CENTOS, FEDORA, RHEL, etc. Kickstart branch

{% if salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') == 'Centos' or salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') == 'Fedora' %}
{% set os = salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') %}
{% set os_release = salt['pillar.get'](type~'_system:'~subtype~':operating_system:os_release') %}

vmlinuz_{{type}}_{{subtype}}:
  file.copy:
    - name: /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/vmlinuz
    - source: /var/www/html/{{os}}_{{os_release}}.local.repo/images/pxeboot/vmlinuz
    - unless: test -e /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/vmlinuz
    - makedirs: True

initrd.img_{{type}}_{{subtype}}:
  file.managed:
    - name: /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/initrd.img
    - source: /var/www/html/{{os}}_{{os_release}}.local.repo/images/pxeboot/initrd.img
    - unless: test -e /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/initrd.img
    - makedirs: True

{% if salt['pillar.get'](type~'_system:'~subtype~':operating_system:boot_mode') == 'bios' %}

/var/www/html/ks/ks_{{type}}_{{subtype}}.cfg:
  file.managed:
    - source: salt://pxe/ks.cfg.jinja
    - template: jinja
    - mode: '0644'
    - makedirs: True
    - defaults:
        type: {{type}}
        subtype: {{subtype}}
        boot_mode: bios
        os: {{os}}
        os_release: '{{os_release}}'

restorecon_http_{{type}}_{{subtype}}:
   cmd.run:
    - name: restorecon -r /var/www/html/
    - unless: test "$(restorecon -r -n /var/www/html/ -v)" = ""
    - require:
      - file: /var/www/html/ks/ks_{{type}}_{{subtype}}.cfg

/var/lib/tftpboot/pxelinux.cfg/default_{{type}}_{{subtype}}:
  file.managed:
    - source: salt://pxe/default_ks.jinja
    - template: jinja
    - makedirs: True
    - defaults:
        type: {{type}}
        subtype: {{subtype}}
        os: {{os}}
        os_release: '{{os_release}}'

restorecon_tftpboot_{{type}}_{{subtype}}:
   cmd.run:
    - name: restorecon -r /var/lib/tftpboot
    - unless: test "$(restorecon -r -n /var/lib/tftpboot/ -v)" = ""
    - require:
      - file: /var/lib/tftpboot/pxelinux.cfg/default_{{type}}_{{subtype}}

{% endif %}
{% endif %}

########################
### DEBIAN, UBUNTU, etc. Preseed branch

{% if salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') == 'Debian' or salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') == 'Ubuntu' %}
{% set os = salt['pillar.get'](type~'_system:'~subtype~':operating_system:os') %}
{% set os_release = salt['pillar.get'](type~'_system:'~subtype~':operating_system:os_release') %}

linux.{{type}}_{{subtype}}:
  file.managed:
    - name: /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/linux
    - source: /var/www/html/{{os}}_{{os_release}}.local.repo/install/netboot/{{os|lower}}-installer/amd64/linux
    - unless: test -e /var/lib/tftpboot/netboot/{{os}}_{{os_release}}/linux
    - makedirs: True

initrd.gz.{{type}}_{{subtype}}:
  file.managed:
    - name: /var/lib/tftpboot/netboot/{{os}}/{{os_release}}/initrd.gz
    - source: /var/www/html/{{os}}_{{os_release}}.local.repo/install/netboot/{{os|lower}}-installer/amd64/initrd.gz
    - unless: test -e /var/lib/tftpboot/netboot/{{os}}_{{os_release}}/initrd.gz
    - makedirs: True

{% if salt['pillar.get'](type~'_system:'~subtype~':operating_system:boot_mode') == 'bios' %}

/var/www/html/preseed/{{type}}_{{subtype}}.preseed:
  file.managed:
    - source: salt://pxe/preseed.jinja
    - template: jinja
    - mode: '0644'
    - makedirs: True
    - defaults:
        type: {{type}}
        subtype: {{subtype}}
        boot_mode: bios
        os: {{os}}
        os_release: '{{os_release}}'

restorecon_http_{{type}}_{{subtype}}:
   cmd.run:
    - name: restorecon -r /var/www/html/
    - unless: test "$(restorecon -r -n /var/www/html/ -v)" = ""
    - require:
      - file: /var/www/html/preseed/{{type}}_{{subtype}}.preseed

/var/lib/tftpboot/pxelinux.cfg/default_{{type}}_{{subtype}}:
  file.managed:
    - source: salt://pxe/default_preseed.jinja
    - template: jinja
    - makedirs: True
    - defaults:
        type: {{type}}
        subtype: {{subtype}}
        os: {{os}}
        os_release: '{{os_release}}'

restorecon_tftpboot_{{type}}_{{subtype}}:
   cmd.run:
    - name: restorecon -r /var/lib/tftpboot
    - unless: test "$(restorecon -r -n /var/lib/tftpboot/ -v)" = ""
    - require:
      - file: /var/lib/tftpboot/pxelinux.cfg/default_{{type}}_{{subtype}}

{% endif %}

{% endif %}




{% endif %}

{% endfor %}
{% endfor %}


restorecon_tftpboot:
   cmd.run:
    - name: restorecon -r /var/lib/tftpboot
    - unless: test "$(restorecon -r -n /var/lib/tftpboot/ -v)" = ""
    - require:
#      - file: /var/lib/tftpboot/pxelinux.cfg/default
      - file: /var/lib/tftpboot/pxelinux.0
      - file: /var/lib/tftpboot/menu.c32
      - file: /var/lib/tftpboot/memdisk
      - file: /var/lib/tftpboot/mboot.c32
      - file: /var/lib/tftpboot/chain.c32

webserver_pxe:
  service:
    - name: {{ pillar['services']['webserver'] }}
    - running
    - enable: True

tftpserver_service:
  service:
    - name: {{ pillar['services']['tftpserver'] }}
    - running
    - enable: True
