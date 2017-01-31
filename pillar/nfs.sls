nfs:

  master:
    /home:
      servermountpoint: /user-home 
      network: eth
      rights: rw
    /hpc_softwares:
      servermountpoint: /soft
      network: eth
      rights: ro

