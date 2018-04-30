# What is Banquise ?

![Banquise_logo](img/banquise_logo.png)

## The story...

Once upon a time, in a very cold sea...

Penguins were living on small icebergs, each colony separated from the others by dangerous and cold water... Each tentative to join the others was a disaster.

One day, penguins discovered that sea Salt could be used to build strong structures.

From this day, penguins started using Salt to gather icebergs and created a unified land: the Banquise. They started living in harmony and effectiveness, and story even say they started some secret business with whales...


## The tool

Banquise is a tool made using [Salt Stack](https://saltstack.com/) to allow simple design and deployment of groups of computers (cluster). It is a full opensource tool, using other opensource resources.

Banquise is composed of two things:

* A Salt pillars custom organization, designed to use full power of Salt while having a cluster oriented simple structure.
* A group of Salt states (called "icebergs") ready to deploy a standard cluster of nodes (HPC cluster, small company office/work-stations, etc).

Banquise has been made to abstract from host: it can be deployed on bare metal, VM or containers.

Each iceberg has been made to be as autonomous as possible.

### Enterprise size networks

Banquise can be used to deploy, monitor and maintain many kind of IT park: enterprise, university, laboratory, ...

All systems can then share same user data base, shared spaces, unified computational resources, etc.

Banquise provides icebergs (modules) for servers but also for workstations, based on Centos or Fedora Linux operating systems. Support for Debian is also scheduled to be implemented soon.

### HPC cluster

Banquise can be used to easily configure, deploy, update and maintain an HPC cluster, in the pets and cattle cloud philosophy.

The following (but not mandatory) solution is proposed:
* a base core (repository, dhcp, dns, ntp, pxe)
* an authentication (ldap/phpldapadmin/sssd)
* a network file system (nfs)
* a job scheduler (slurm)
* a monitoring (shinken/webui2)

Assuming system administrator already know MAC addresses of servers, a standard cluster can be deployed and go in production in less than a day.

