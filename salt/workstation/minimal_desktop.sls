x_window_system_group:
  pkg.group_installed:
    - name: "X Window System"
#    - require:
#      - sls: repository.client

gnome_shell_gdm:
  pkg.installed:
    - pkgs:
      - gnome-classic-session
      - gnome-terminal
      - control-center
      - liberation-mono-fonts
#    - require:
#      - sls: repository.client

/etc/systemd/system/default.target:
  file.symlink:
    - target: /lib/systemd/system/graphical.target

#reboot_minion:
#  salt.function:
#    - name: system.reboot
#    - require:
#      - pkg: x_window_system_group
#      - pkg: gnome_shell_gdm
#      - file: /etc/systemd/system/default.target
#    - tgt: 'compute1'

#system.reboot:
#  module.run:
#    - require:
#      - pkg: x_window_system_group
#      - pkg: gnome_shell_gdm
#      - file: /etc/systemd/system/default.target


#wait_for_reboots:
#  salt.wait_for_event:
#    - name: salt/minion/{{salt['grains.get']('id')}}/start
#    - require:
#      - module: system.reboot

#system.reboot:
#  module.run:
#    - require:
#      - pkg: x_window_system_group
#      - pkg: gnome_shell_gdm
#      - file: /etc/systemd/system/default.target 
