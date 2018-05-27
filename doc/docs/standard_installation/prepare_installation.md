# Prepare installation

## Download needed elements

The management nodes, called "masters", need a Centos Everything DVD iso (or an RHEL equivalent). It is possible to download one from http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/ .

Clients nodes need iso from the targeted Linux distribution.

Here is the list of needed files per client OS:

* Centos:
  * 7:
    * Everything iso, >= 7.4. Can be found here: http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/
    Tested isos are:
      * CentOS-7-x86_64-Everything-1708.iso, sha256sum 8593f5a1631ebfb7581193a7b4ef96d44f500d3ceb49cc4cfbfd71d5698e4173

* Fedora:
  * 27:
    * Server iso. Can be found here:
    Tested isos are:
      * Fedora-Server-dvd-x86_64-27-1.6.iso, sha256sum e383dd414bb57231b20cbed11c4953cac71785f7d4f5990b0df5ad534a0ba95c

* Debian:
  * 9:

* Ubuntu:
  * 18.04:
    * Standard server iso (not the live server one) and the netboot.tar.gz file that comes with it. Can be found here:
    Tested isos are:
      * ubuntu-18.04-server-amd64.iso, sha256sum a7f5c7b0cdd0e9560d78f1e47660e066353bb8a79eb78d1fc3f4ea62a07e6cbc

For Centos, see above to download. For Fedora, see at https://getfedora.org/ or https://spins.fedoraproject.org/ . Note that for very large network, you may need for Fedora an Everything iso also to lower web bandwith usage.

Get also Banquise repositories:

wget --reject="index.html*" -nH -r --no-parent https://repo.saltstack.com/yum/redhat/7/x86_64/2016.11/
