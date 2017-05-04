# Monitoring file. Always start with 4 space indent !!
    service:

      httpd:
        service_description: check_proc_httpd
        check_command: check_nrpe!check_proc_httpd

    command:

      httpd:
        command_name: check_proc_httpd
        command_path: "/usr/lib64/nagios/plugins/check_procs"
        command_arguments: "-w 4:16 -c 1:20 -C httpd"
