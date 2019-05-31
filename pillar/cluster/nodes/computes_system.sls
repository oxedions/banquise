computes_system:

  standard:
    operating_system:
      os: Centos
      os_release: 7.4.1708
      kernel_parameters:
      boot_mode: bios            # bios, uefi
      partitioning: |            # Multiple lines variables, start with a | and indented. This is plain kickstart syntax here.
        clearpart --all --initlabel
        part /boot --fstype=ext4 --size=2048
        part / --fstype=ext4 --size=1 --grow
      updates: kickstart, none   # when to update, separate by comma
    hardware:
      sockets: 1
      cores_per_socket: 1
      threads_per_core: 1
      memory: 1024
    bmc:
      user:
      password:
      console:

#    os: Centos
#    os_release: 7.4.1708
#    partitioning: |
#      clearpart --all --initlabel
#      part /boot --fstype=ext4 --size=2048
#      part / --fstype=ext4 --size=1 --grow
#    boot_mode: bios # bios, uefi
#    kernel_parameters:
#    bmc_console:
#    update: none # when to update
    
  gpu:
    operating_system:
      os: Fedora
      os_release: 27
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

#    os: Fedora
#    os_release: 27
#    partitioning: |
#      clearpart --all --initlabel
#      part /boot --fstype=ext4 --size=2048
#      part / --fstype=ext4 --size=1 --grow
#    boot_mode: bios # bios, uefi
#    kernel_parameters:
#    bmc_console:
#    update: none # when to update

  smp:
    operating_system:
      os: Fedora
      os_release: 27
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
