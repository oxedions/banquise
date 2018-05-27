# this file contains nfs servers description (and not nodes that host it !!!, these are IOs or Masters nodes)

nfs:

  management1:                              # Put here the id of the node hosting these exports. You can define multiple nodes with multiple exports.
    /home:                             # Put here the mount point seen by the client
      servermountpoint: /home     # Put here the export from the server
      network: net0                     # Put here the network used (only eth for current release)
#      rights: rw                       # Put here the rights (read = ro, read/write = rw)
      mountpool:                       # Set here the subtypes that should mount this FS
        - computes:standard
        - logins:standard
        - computes:gpu
      export_parameters: rw,no_root_squash,sync
      mount_parameters: rw,rsize=32768,wsize=32768,intr,nfsvers=3,bg
    /opt:
      servermountpoint: /opt
      network: net0
#      rights: ro
      mountpool:
        - computes:standard
        - logins:standard
      export_parameters: ro,no_root_squash,sync
      mount_parameters: ro,intr,nfsvers=3,bg

#  nfs1:
#    /scratch:
#      servermountpoint: /scratch_mount
#      network: ic0
#      rights: rw
#      mountpool:
#        - 'computes:standard'
#        - 'logins:standard'
