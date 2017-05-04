# This file regroups packages names. It's purpose is to help allowing multiple Linux distros in the future (like debian, etc)
{% if grains.os_family == 'RedHat' %}
pkgs:
  apache: httpd
  vim: vim
  dns: bind
  dhcp: dhcp
  sftp: vsftpd
  tftp: tftp
  tftpserver: tftp-server
  xinetd: xinetd
  syslinux: syslinux
  wget: wget
  ntp: ntp
  ldap_server: openldap-servers
  ldap_client: openldap-clients
  munge: munge
  slurm: slurm
  slurm_munge: slurm-munge
  webserver: httpd
  salt_minion: salt-minion
  firewall: firewalld
  networkmanager: NetworkManager
  nfs_utils: nfs-utils
  nsspamldap: nss-pam-ldapd
  sssd: sssd
  phpldapadmin: phpldapadmin
  shinken: shinken
  shinken_arbiter: shinken-arbiter
  shinken_broker: shinken-broker
  shinken_poller: shinken-poller
  shinken_reactionner: shinken-reactionner
  shinken_receiver: shinken-receiver
  shinken_scheduler: shinken-scheduler
  shinken_webui2: shinken-webui2
{% elif grains.os_family == 'Debian' %}

{% endif %}
