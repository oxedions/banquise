masters_system:

  management1:
    os: Centos
    os_release: 7.4.1708
    partitioning: |
      clearpart --all --initlabel
      part /boot --fstype=ext4 --size=2048
      part / --fstype=ext4 --size=1 --grow
    boot_mode: bios # bios, uefi
    kernel_parameters:
    bmc_console:
    update: none # when to update
    
