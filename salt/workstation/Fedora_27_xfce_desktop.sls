xfce_desktop_pkg:
  pkg.group_installed:
    - name: "Xfce Desktop"
    - require:
      - sls: repository.client

gnome_shell_gdm_pkg:
  pkg.installed:
    - pkgs:
      - gdm
    - require:
      - sls: repository.client

/etc/systemd/system/default.target:
  file.symlink:
    - target: /lib/systemd/system/graphical.target

gdm_service:
  service:
    - name: {{ gdm }}
    - running
    - enable: True
    - require:
      - pkg: xfce_desktop_pkg
      - pkg: gnome_shell_gdm_pkg

