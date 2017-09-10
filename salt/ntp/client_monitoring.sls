# Monitoring file. Always start with 4 space indent !!
    service:

      ntpd:
        service_description: check_proc_ntpd
        check_command: check_nrpe!check_proc_ntpd

    command:

      ntpd:
        command_name: check_proc_ntpd
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C ntpd"
