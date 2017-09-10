# Monitoring file. Always start with 4 space indent !!
    service:

      slurmd:
        service_description: check_proc_slurmd
        check_command: check_nrpe!check_proc_slurmd

      munged:
        service_description: check_proc_munged
        check_command: check_nrpe!check_proc_munged

    command:

      slurmd:
        command_name: check_proc_slurmd
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C slurmd"

      munged:
        command_name: check_proc_munged
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C munged"
