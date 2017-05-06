# this file contains nfs servers description (and not nodes that host it !!!, these are IOs or Masters nodes)

nfs:

  master:                              # Put here the id of the node hosting these exports. You can define multiple nodes with multiple exports.
    /home:                             # Put here the mount point seen by the client
      servermountpoint: /home     # Put here the export from the server
      network: net0                     # Put here the network used (only eth for current release)
      rights: rw                       # Put here the rights (read = ro, read/write = rw)
    /opt:
      servermountpoint: /opt
      network: net0
      rights: ro

  nfs1:
    /scratch:
      servermountpoint: /scratch_mount
      network: ib0
      rights: rw

