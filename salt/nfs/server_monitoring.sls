# Monitoring file. Always start with 4 space indent !!
    service:

      nfsd:
        service_description: check_proc_nfsd
        check_command: check_nrpe!check_proc_nfsd

      rpcbind:
        service_description: check_proc_rpcbind
        check_command: check_nrpe!check_proc_rpcbind

    command:

      nfsd:
        command_name: check_proc_nfsd
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 8:8 -c 7:9 -C nfsd"

      rpcbind:
        command_name: check_proc_rpcbind
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 1: -c 1:1 -C rpcbind"
