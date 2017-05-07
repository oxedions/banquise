# This file contains the list of cluster nodes, with their parameters. Note that you can add parameters (in this example position), Banquise will not use them as long as you respect YAML structure.
computes:

  standard:

    compute1:                        # Name of the compute
      procs: 2                       # Number of cores of the server
      bmc:
        name: bmccompute1            # Name of the BMC
        ip: 10.1.103.1               # Ip of the bmc
        hwaddr: 08:00:28:18:67:BC    # Mac of the Eth NIC of the BMC
      position:                      # Additional informations not used by Banquise
        rack: rack1
        z: A
      network:
        net0:
          ip: 10.1.3.1
          hwaddr: 08:00:27:84:F5:FA
          interface: auto
        ib0:
          ip: 10.2.3.1
          interface: enp0s8 
  
    compute2:
      procs: 2
      bmc:
        name: bmccompute2
        ip: 10.1.103.2
        hwaddr: 08:00:28:18:67:EE
      network:
        net0:
          ip: 10.1.3.2
          hwaddr: 08:00:27:9E:2A:97
        ib0:
          ip: 10.2.3.2

    
    compute5:
      procs: 2
      bmc:
        name: bmccompute5
        ip: 10.1.103.5
        hwaddr: 08:00:28:18:67:88
      network:
        net0:
          ip: 10.1.3.5
          hwaddr: 08:00:27:9E:2A:55
        ib0:
          ip: 10.2.3.5
          interface: none



  gpu:

    compute3:
      procs: 4                       # BMC is optional
      network:
        net0:
          ip: 10.1.3.3
          hwaddr: 08:00:27:8A:EA:57
        ib0:
          ip: 10.2.3.3

  smp:

    compute4:
      procs: 24
      bmc:
        name: bmccompute4
        ip: 10.1.103.4
        hwaddr: 08:00:28:18:67:EA
      network:
        net0:
          ip: 10.1.3.4
          hwaddr: 08:00:27:8A:EA:58
        ib0:
          ip: 10.2.3.4


