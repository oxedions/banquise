gnome_shell_gdm:
  pkg.installed:
    - pkgs:
      - libreoffice-writer
      - libreoffice-calc
      - libreoffice-impress
      - firefox
      - gnome-calculator
      - gnome-screenshot
    - require:
      - sls: workstation.Centos_7_gnome_desktop
