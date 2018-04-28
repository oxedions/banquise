# What is Banquise ?

![Banquise_logo](img/banquise_logo.png)

Banquise is a tool made using [Salt Stack](https://saltstack.com/) to allow simple design and deployment of groups of computers (cluster).

Banquise is composed of two things:

* A Salt pillars custom organisation, designed to use full power of Salt while having a cluster oriented simple structure.
* A group of Salt states (called "icebergs") ready to deploy a standard cluster of nodes (HPC cluster, small company office/work-stations, etc).

## Enterprise size networks

Banquise can be used to deploy, monitor and maintain an enterprise network.

All systems can then share same users data base, shared spaces, shared computational ressources, etc.

Banquise provides icebergs (modules) for workstations, based on Centos or Fedora Linux oerating systems.



    a base core (repository, dhcp, dns, ntp, pxe)
    a network file system (nfs)
    an authentication (ldap/phpldapadmin/sssd)
    a desktop state (Gnome, LibreOffice, Firefox, ...)

