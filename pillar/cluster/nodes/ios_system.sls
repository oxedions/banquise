ios_system:

  nfs:
    operating_system:
      os: Centos
      os_release: 7.4.1708
      kernel_parameters:
      boot_mode: bios
      partitioning: |
        clearpart --all --initlabel
        part /boot --fstype=ext4 --size=2048
        part / --fstype=ext4 --size=1 --grow
      updates: kickstart, none
    hardware:
      sockets: 1
      cores_per_socket: 1
      threads_per_core: 1
      memory: 1024
    bmc:
      user:
      password:
      console:

  lustre:
    operating_system:
      os: Centos
      os_release: 7.4.1708
      kernel_parameters:
      boot_mode: bios
      partitioning: |
        clearpart --all --initlabel
        part /boot --fstype=ext4 --size=2048
        part / --fstype=ext4 --size=1 --grow
      updates: kickstart, none
    hardware:
      sockets: 1
      cores_per_socket: 1
      threads_per_core: 1
      memory: 1024
    bmc:
      user:
      password:
      console:


