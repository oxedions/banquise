# Monitoring file. Always start with 4 space indent !!
    service:

      dhcpd:
        service_description: check_proc_dhcpd
        check_command: check_nrpe!check_proc_dhcpd

    command:

      dhcpd:
        command_name: check_proc_dhcpd
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C dhcpd"
