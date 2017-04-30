# Monitoring file. Always start with 4 space indent !!
    service:
      display_name: ldap_client
      service_description: check_proc_sssd
      check_command: check_nrpe!check_proc_sssd

    command:
      command_name: check_proc_sssd
      command_path: "/usr/lib64/nagios/plugins/check_procs"
      command_arguments: "-w 1: -c 1:1 -C sssd"
 
