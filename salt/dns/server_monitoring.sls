# Monitoring file. Always start with 4 space indent !!
    service:

      named:
        service_description: check_proc_named
        check_command: check_nrpe!check_proc_named

    command:

      named:
        command_name: check_proc_named
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C named"
