masters_system:

  management1:
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
      sockets:
      cores_per_socket:
      threads_per_core:
      memory:
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
    
