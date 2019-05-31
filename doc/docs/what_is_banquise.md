# What is Banquise ?

## The story...

Once upon a time, in a very cold sea...

Penguins were living on small icebergs, each colony separated from the others by dangerous and cold water... Each tentative to join to the others was a disaster.

![Banquise_logo](img/splitted_icebergs.svg)

One day, penguins discovered that sea Salt could be used to build strong structures.

From this day, penguins started using Salt to gather icebergs and created a unified land: the Banquise. They started living in harmony and effectiveness, gathering icebergs and communicating with other species...

## The tool

Banquise is a tool made using [Salt](https://saltstack.com/) to allow simple design and deployment of groups of computers (cluster). It is a full opensource tool, using other opensource resources.
![Salt_logo](img/Saltstack_logo.png)

Note: Salt is the opensource tool, Salt Stack is the company that develops and provides support on Salt.

Banquise is composed of two things:

* A Salt pillars custom organization, designed to use full power of Salt while having a cluster oriented simple structure.
* A group of Salt states, called modules, ready to deploy a standard cluster of nodes (HPC cluster, small company office/work-stations, etc).

Banquise has been made to abstract from host: it can be deployed on bare metal, VM or containers.

Each module has been made to be as autonomous as possible.

Engines allow to plug other Salt Formulae to Banquise pillar structure.

### Enterprise size networks

Banquise can be used to deploy, monitor and maintain many kind of IT park: enterprise, university, laboratory, ...

All systems can then share same user data base, shared spaces, unified computational resources, etc.

Banquise provides modules for servers but also for workstations, based on standard Linux operating systems.

### HPC cluster

Banquise can be used to easily configure, deploy, update and maintain an HPC cluster, in the pets and cattle cloud philosophy.

The following (but not mandatory) solution is proposed:
* a base core (repository, dhcp, dns, ntp, pxe)
* an authentication (ldap/phpldapadmin/sssd)
* a network file system (nfs)
* a job scheduler (slurm)
* a monitoring (shinken/webui2)

Assuming system administrator already know MAC addresses of servers, a standard cluster can be deployed and go in production in less than a day.
