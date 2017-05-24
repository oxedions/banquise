tftp:
  pkg.installed:
    - name: {{ pillar['pkgs']['tftp'] }}
    - require:
      - sls: repository.client

tftp-server:
  pkg.installed:
    - name: {{ pillar['pkgs']['tftpserver'] }}
    - require:
      - sls: repository.client

syslinux:
  pkg.installed:
    - name: {{ pillar['pkgs']['syslinux'] }}
    - require:
      - sls: repository.client

webserver:
  pkg.installed:
    - name: {{ pillar['pkgs']['webserver'] }}
    - require:
      - sls: repository.client

/var/lib/tftpboot/pxelinux.0:
   file.copy:
    - source: /usr/share/syslinux/pxelinux.0
    - unless: test -e /var/lib/tftpboot/pxelinux.0
    - makedirs: True
    - require:
      - pkg: {{ pillar['pkgs']['syslinux'] }}

/var/lib/tftpboot/menu.c32:
   file.copy:
    - source: /usr/share/syslinux/menu.c32
    - unless: test -e /var/lib/tftpboot/menu.c32
    - makedirs: True
    - require:
      - pkg: {{ pillar['pkgs']['syslinux'] }}

/var/lib/tftpboot/memdisk:
   file.copy:
    - source: /usr/share/syslinux/memdisk
    - unless: test -e /var/lib/tftpboot/memdisk
    - makedirs: True
    - require:
      - pkg: {{ pillar['pkgs']['syslinux'] }}

/var/lib/tftpboot/mboot.c32:
   file.copy:
    - source: /usr/share/syslinux/mboot.c32
    - unless: test -e /var/lib/tftpboot/mboot.c32
    - makedirs: True
    - require:
      - pkg: {{ pillar['pkgs']['syslinux'] }}

/var/lib/tftpboot/chain.c32:
   file.copy:
    - source: /usr/share/syslinux/chain.c32
    - unless: test -e /var/lib/tftpboot/chain.c32
    - makedirs: True
    - require:
      - pkg: {{ pillar['pkgs']['syslinux'] }}

/var/lib/tftpboot/netboot/vmlinuz:
  file.copy:
    - source: /var/www/html/os_dvd.local.repo/images/pxeboot/vmlinuz
    - unless: test -e /var/lib/tftpboot/netboot/vmlinuz
    - makedirs: True

/var/lib/tftpboot/netboot/initrd.img:
  file.managed:
    - source: /var/www/html/os_dvd.local.repo/images/pxeboot/initrd.img
    - unless: test -e /var/lib/tftpboot/netboot/initrd.img
    - makedirs: True

/var/www/html/ks.cfg:
  file.managed:
    - source: salt://pxe/ks.cfg.jinja
    - template: jinja
    - mode: '0644'

restorecon_http:
   cmd.run:
    - name: restorecon -r /var/www/html/
    - unless: test "$(restorecon -r -n /var/www/html/ -v)" = ""
    - require:
      - file: /var/www/html/ks.cfg

/var/lib/tftpboot/pxelinux.cfg/default:
  file.managed:
    - source: salt://pxe/default.jinja
    - template: jinja
    - makedirs: True

restorecon_tftpboot:
   cmd.run:
    - name: restorecon -r /var/lib/tftpboot
    - unless: test "$(restorecon -r -n /var/lib/tftpboot/ -v)" = ""
    - require:
      - file: /var/lib/tftpboot/pxelinux.cfg/default
      - file: /var/lib/tftpboot/pxelinux.0
      - file: /var/lib/tftpboot/menu.c32
      - file: /var/lib/tftpboot/memdisk
      - file: /var/lib/tftpboot/mboot.c32
      - file: /var/lib/tftpboot/chain.c32
      - file: /var/lib/tftpboot/netboot/vmlinuz
      - file: /var/lib/tftpboot/netboot/initrd.img

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

