# Monitoring file. Always start with 4 space indent !!
    service:
      display_name: slurm_server
      service_description: check_proc_slurmctld
      check_command: check_nrpe!check_proc_slurmctld

    command:
      command_name: check_proc_slurmctld
      command_path: "/usr/lib64/nagios/plugins/check_procs"
      command_arguments: "-w 1: -c 1:1 -C slurmctld"
 
