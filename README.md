          ██████   █████  ███    ██  ██████  ██    ██ ██ ███████ ███████
          ██   ██ ██   ██ ████   ██ ██    ██ ██    ██ ██ ██      ██
          ██████  ███████ ██ ██  ██ ██    ██ ██    ██ ██ ███████ █████
          ██   ██ ██   ██ ██  ██ ██ ██ ▄▄ ██ ██    ██ ██      ██ ██
          ██████  ██   ██ ██   ████  ██████   ██████  ██ ███████ ███████ 
                                        ▀▀

                                       It's time to dive in !
                                       /
                                   ('<    ?
                                   (v\  >o
                                  <(_)  (")
                                    ~~  ^^

Current release : beta 1

Mail : oxedions@gmail.com

# banquise

ʕʘ̅͜ʘ̅ʔ What does not work today:

- I don't have any IB network at home, and cannot do it at work if I want to keep Banquise opensource. There are no IB states in current version.
- There could be an issue with network.static if ip has pattern somewhere else in it (10.0 -> 10.0.10.0 = issue ?). Need to rewrite this (regex ^).
- Cannot change some ldap parameters on the fly once data base created.

ʕʘ̅͜ʘ̅ʔ Other notes:

- Slurm does not restart automatically after slurm.conf update. This was done on purpose, has it would be too risky. Administrator must use scontrol reconfigure once all nodes slurm.conf files are synchronized.
- Missing a lot of rpm for /hpc_softwares (gcc, openmpi/mvapich2, boost, etc and their module files), waiting for beta 1 to be ended to provide them.
- Ldap user interface (based on dialog) still not released.
- PXE user interface (based on dialog) still not released.
- Current version does not support iptables.
- Current version does not support SSL for ldap.

Admin sys beginner notes: if you feel lost, keep in mind that Banquise is just automatically reproducing what was done manually here: https://www.sphenisc.com/doku.php/system/linux_cluster

## Introduction

Banquise is an HPC stack based on Salt.

The aims of Banquise are: simplicity, modularity, and less scripts as possible.

Banquise is able to deploy a full basic HPC cluster, including: master node, login nodes, compute nodes, and io nodes.

            +------------+
            |            |
            | saltmaster |
            |            |
            +-----+------+
                  |            eth network
         +--------+----+------------+------------+----···
         |             |            |            |
    +----+---+         |            |            |
    |        |         |            |            |
    | master |         |            |            |
    |        |      +--+---+     +--+---+     +--+---+
    +--------+      | node |     | node |     | node |
                    +------+     +------+     +------+

Banquise will setup all needed tools, including a job scheduler (slurm).

Cluster maintenance is easy: all configuration files (server/client) are dynamic and are automatically generated/regenerated on the fly if configuration changed, and impacted services are automatically restarted. It is also possible to check cluster consistency using the same method.

Banquise is using as less as possible packages to reduce attack surface. SELinux is kept activated and enforced on all hosts.

All needed softwares/tools are provided from Banquise repository.

Banquise can be installed on all type of hardware, including VM for experimenting. With small modifications, Banquise could also be compatible with containers (thanks to salt-ssh feature). User will need Centos 7 (>= 7.2) Everything DVD (or RHEL Server DVD for RHEL installation).

## Installation

Note: saltmaster can directly be installed on master node. However, this should be avoided as having saltmaster hosted somewhere else allows to reinstall quickly master in case of hardware failure.

It is assume here that user is using Centos, but RHEL instructions are the same.

Note: saltmaster ip will be 10.1.0.77, and master ip 10.1.0.1. Netmask used will be 255.255.0.0 (Banquise allows /8, /16 and /24).

### saltmaster

            +------------+
            |            |
            | saltmaster |
            |            |
            +-----+------+
                  |
         +--------+--------···

It is assumed that during it's first installation, saltmaster system can reach the web to download some rpm, iso and Banquise files.

Install an CentOS/RHEL 7.2 (or >) with minimal packages.

First step purpose is to setup a local repository for Salt and CentOS/RHEL rpm. This repository will be used to bootstrap salt client side on master and nodes.

Install wget and httpd, and start httpd:

    yum install wget httpd git
    systemctl start httpd
    systemctl enable httpd

Download or upload needed CentOS iso (assuming you are using CentOS). Some download links:

    wget http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1511.iso
    wget http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1511.iso

Go into /root and download Salt Stack 2016.11 main repository:

    cd /root
    wget --reject="index.html*" -nH -r --no-parent https://repo.saltstack.com/yum/redhat/7/x86_64/2016.11/

Then move these files into httpd directory:

    mkdir -p /var/www/html/salt.local.repo/
    mv yum/redhat/7/x86_64/2016.11/* /var/www/html/salt.local.repo/
    rm -Rf yum

Then create a local repository file to be able to install salt locally. Edit /etc/yum.repos.d/salt-2016.11.local.repo and use the following content:

    [salt]
    name=local salt repository
    baseurl=http://localhost/salt.local.repo/
    gpgcheck=0
    enabled=1

And restore SELinux flags:

    restorecon -R /var/www/html/

Download Banquise main repository:

    cd /root
    wget --reject="index.html*" -nH -r --no-parent https://www.sphenisc.com/repository/banquise/el/7/x86_64/

Then keep these files into /root:

    mkdir -p /root/banquise/
    mv repository/banquise/el/7/x86_64/* /root/banquise/
    rm -Rf repository

Finally mount Centos everything DVD and copy all content localy (will be used on master for repository and pxe process):

    mount CentOS-7-x86_64-Everything-1511.iso /mnt
    mkdir -p /root/os_dvd/
    cp -ar /mnt/* /root/os_dvd
    umount /mnt

Install salt-master:

    yum install salt-master salt-ssh

Then add master ip into Salt roster /etc/salt/roster (allows salt-ssh to know master ip and to boostrap on it). Edit /etc/salt/roster and add (assuming master hostname is master and domain name is sphen.local):

    master.sphen.local:
      host: 10.1.0.1

Configure static ip on ethernet linked to the cluster main network (i.e. also linked to master to be deployed). We will use here the 10.1.0.77/16 ip, and assuming the interface connected on the cluster is enp0s8. Edit /etc/sysconfig/network-scripts/ifcfg-enp0s8 as following:

    TYPE=Ethernet
    BOOTPROTO=none
    NAME=enp0s8
    DEVICE=enp0s8
    ONBOOT=yes
    IPADDR=10.1.0.77
    NETMASK=255.255.0.0

Activate interface:

    ifup enp0s8

And set hostname with domain name:

    hostnamectl set-hostname saltmaster.sphen.local

Generate an ssh key without pass-phrase:

    ssh-keygen

Also generate an ssh key for future master, and keep it somewhere (private and public key).

Download Banquise:

    mkdir /srv
    cd /srv
    git clone https://github.com/oxedions/banquise .

And start and enable salt-master:

    systemctl start salt-master
    systemctl enable salt-master

For the time being, disable firewalld (or any firewall, i.e. iptables):

    systemctl stop firewalld
    systemctl disable firewalld

There is no need for an internet connection from now.

### Configure Banquise

All files are in /srv.

You will need to configure some files, especially MAC addresses of computes nodes.

In /srv/pillar:

- core.sls that contains very basic cluster information
- network.sls that contains network information
- master.sls that contains master node information
- ios.sls that contains all io nodes information (nfs servers, etc)
- computes.sls that contains all compute nodes information (hostname, ip, mac, etc)
- nfs.sls that contains nfs related informations
- ldap_private.sls and ldap_public.sls that contains data for ldap (private is protected in top.sls of pillar)
- ssh_private.sls and ssh_public.sls (private is protected in top.sls of pillar) Put here the ssh key you made for future master.

**Important: ensure that time zone in /srv/salt/pxe/ks.cfg.jinja is the same as the one you used to deploy saltmaster and master. If not, slurm (munge) will not be able to authenticate.** Default is America/New_York.

You can edit /srv/salt/top.sls file to choose what to install on who. If you don't know what to do, don't touch it and use "compute\*" for your compute names, and "master" for master node.

If you are using servers with BMC, edit default.jinja2 in /srv/salt/pxe and add console=tty0 console=ttyS1,115200 at the end of line with APPEND. This should allow ipmi console (you may need to change ttyS1 to ttyS0 or ttyS2 depending of your hardware).

If you are using slurm, **you need to generate a munge key**. Use:

    dd if=/dev/urandom bs=1 count=1024 > /srv/salt/slurm/munge.key

You shouldn't need to edit other files in /srv/salt, except for debugging purposes.

### Master deployment

                 +------------+
                 |            |
                 | saltmaster |
                 |            |
                 +-----+------+
                       |
              +--------+--------···
              |          
         +----+---+     
         |        |      
         | master |   
         |        |     
         +--------+  

Install also a minimal system on master node, and configure static ip on it to be reachable by salt master. We will assume here that interface is enp0s8. Edit /etc/sysconfig/network-scripts/ifcfg-enp0s8 as following:

    TYPE=Ethernet
    BOOTPROTO=none
    NAME=enp0s8
    DEVICE=enp0s8
    ONBOOT=yes
    IPADDR=10.1.0.1
    NETMASK=255.255.0.0

And start interface:

    ifup enp0s8

Then stop and disable network manager:

    systemctl stop NetworkManager
    systemctl disable NetworkManager

This is done to ensure no one is editing network configuration files.

                 +------------+
                 |            |
                 | saltmaster |
                 |            |
                 +-----▼------+
                       |
              +----◀---+--------···
              |          
         +----▼---+     
         |        |      
         | master |   
         |        |     
         +--------+  

Deploy your ssh key on master:

    ssh-copy-id 10.1.0.1

We now need to copy huge files on master. This means os_dvd and banquise repository. Choice was to not do that using Banquise as it is not made to copy such amount of large files (needs a lot of RAM).

    ssh 10.1.0.1 mkdir -p /var/www/html/
    scp -r /root/banquise 10.1.0.1:/var/www/html/banquise.local.repo
    scp -r /root/os_dvd 10.1.0.1:/var/www/html/os_dvd.local.repo
    ssh 10.1.0.1 restorecon -r /var/www/html/

Depending of your hardware, it could take a while...

Now, from saltmaster, boostrap the master, using (root password of master will be asked, and accept deploying the key):

    salt-ssh "master.sphen.local" state.apply bootstrap -l debug

Check that master tried to register on salt-master (salt-minion service running on master), using:

    salt-key

If yes, accept the key (if not, ensure that on master salt-minion is installed and running, and that "salt" and "saltmaster" are set in /etc/hosts, also check you disabled firewall on saltmaster and that salt-master is running on saltmaster):

    salt-key -a master.sphen.local

And ask salt to deploy repository server on master, to ensure all goes well after boostrap (mandatory for the following) (note: this step could be added into boostrap):

    salt "master*" state.apply repository.server -l debug -v

Before last step, **ensure the directories to be exported by your nfs configuration exists** (for example, in default configuration, ensure /soft and /user-home exist on master node).


                            Now please read the following entirely before taking an action.
                                       /
                                   ('<    !
                                   (v\  >o
                                  <(_)  (")
                                    ~~  ^^

--- START ---

Finally, you can deploy master. In normal time, you will use from saltmaster 'salt "master" state.highstate' to apply configuration or changes on the master. However, because this is the first install you should ssh on master and use salt-call to display all informations on what is going on, and to prevent time out of salt-minion.

ssh on master (ssh 10.1.0.1) and use:

    salt-call state.highstate -l debug

If it start, you can go take a coffee. This step is not that long, but depending of your hardware, it could take around 1 to 20 minutes.

Once finished, exit master and from saltmaster ensure all is ok:

    salt "master" state.highstate -v

If all is green, you are OK, and your master is ready. If not, do not hesitate to ask for help (see mail at top).

--- END ---

### Computes deployment

                 +------------+
                 |            |
                 | saltmaster |
                 |            |
                 +-----+------+
                       |
              +----▶---+--▶-+------------+------------+----···
              |             |            |            |
         +----▲---+         ▼            |            |
         |        |         |            |            |
         | master |         |            |            |
         |        |      +--▼---+     +--+---+     +--+---+
         +--------+      | node |     | node |     | node |
                         +------+     +------+     +------+

In the current state (beta 1), Banquise does not incorporate a way to help administrator to manage computes nodes PXE. All nodes that boot on PXE will reinstall their OS. This limitation will be removed in next beta.

To deploy a compute, simply ask the node to boot on PXE, and once OS is installed, set node to boot on local disk (or you can play with file /var/lib/tftpboot/pxelinux.cfg/default on master, by switching default action).

Once the node has booted, it should automatically try to register on salt-master. From saltmaster, use salt-key to display informations, and salt-key -a to accept a new key or salt-key -d to delete one (if you want to update a key, delete it, then ssh on the node and restart salt-minion, the new key should be on saltmaster now).

Computes do not need to be bootstraped as salt-minion is automatically deploy and enabled during kickstart process. Master public key is also installed.

                 +------------+
                 |            |
                 | saltmaster |
                 |            |
                 +-----▼------+
                       |
              +--------+--▶-+------------+------------+----···
              |             |            |            |
         +----+---+         ▼            |            |
         |        |         |            |            |
         | master |         |            |            |
         |        |      +--▼---+     +--+---+     +--+---+
         +--------+      | node |     | node |     | node |
                         +------+     +------+     +------+

Accept key for new node:

    salt-key -a compute1.sphen.local

Then simply apply configuration on computes. Ssh on node (through master because root key was added during kickstart process) and use (again we use salt-call for first install to avoid time-out):

    salt-call state.highstate -l debug

Note: in the current version you may need to execute this command twice as NetworkManager may interfere with our dns client. (should be fixed by now).

Then, to keep node up to date, simple use from saltmaster (you can use regex for names in salt, here *):

    salt "compute*" state.highstate -v

Once installed, you can ssh on master and enable node(s) into slurm. Check nodes state using:

    sinfo

And move down/drain nodes to compute pool (assuming you just installed compute1):

    scontrol update nodename=compute1 state=idle

And try to launch a job on it:

    srun -N 1 hostname

If the job is executed, you have installed the cluster correctly. You can change some parameters on saltmaster in /srv/pillar and apply them to all cluster using:

    salt "*" state.highstate -v

Remember to use 'scontrol reconfigure' on master to ask slurm to reload configuration.

### And now ?

You can deploy the other elements of the cluster using the /srv/salt/top.sls file on saltmaster (for example you may want master be used also as login node, then simply add ldap.client state in /srv/salt/top.sls for master).
Ensure that nfs.server is set for nfs servers (even for master if it should export and nfs volume).

To add a user into ldap database, refer to: https://www.sphenisc.com/doku.php/system/linux_cluster/managing_cluster#managing_users

Banquise is still young. Please report any bugs, any features you would like, or simply tell me you are using Banquise and it worked, I will be really pleased to hear that!!

