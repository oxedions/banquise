

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702680/710bfdee-30d2-11e7-9cf0-5288e83c7259.png)](https://cloud.githubusercontent.com/assets/929620/25702680/710bfdee-30d2-11e7-9cf0-5288e83c7259.png)


          ██████   █████  ███    ██  ██████  ██    ██ ██ ███████ ███████
          ██   ██ ██   ██ ████   ██ ██    ██ ██    ██ ██ ██      ██
          ██████  ███████ ██ ██  ██ ██    ██ ██    ██ ██ ███████ █████
          ██   ██ ██   ██ ██  ██ ██ ██ ▄▄ ██ ██    ██ ██      ██ ██
          ██████  ██   ██ ██   ████  ██████   ██████  ██ ███████ ███████ 
                                        ▀▀

                                            Welcome on Banquise 
                                           /
                                       ('<       <`)    
                                       /V\       (V)     <`)
                                      <(_)     ]/__)>    (V) 
                                        ~~             ]/__)>

Current release: Alpha 2

Mail: oxedions@gmail.com

  - 1. Introduction
    - 1.1 What is Banquise
    - 1.2 What is Banquise currently capable of
    - 1.3 Known issues
  - 2. Using Banquise
    - 2.1 Install saltmaster
    - 2.2 Configure Banquise
    - 2.3 Deploy master
    - 2.4 Deploy cluster
    - 2.5 Manage cluster
    - 2.6 Update cluster

# 1. Introduction

## 1.1 What is Banquise

Banquise is an HPC stack based on Salt.

The aim of Banquise is to be simple, modular, and to use less scripts as possible.

Banquise is able to deploy a full basic HPC cluster, including: master node, login nodes, compute nodes, and io nodes (or simply a master and its compute nodes).

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

Banquise can be installed on all type of hardware, including VM for experimenting.

## 1.2 What is Banquise capable of

Banquise can deploy a full cluster, based on Rhel/CentOS linux distribution. Future Banquise versions should be also compatible with Debian and Sles based linux.

Banquise is based on Salt Stack, a deployment tool, like Ansible or Puppet.

Banquise deploy the following elements:

  - Repository (server: http)
  - Dhcp
  - Dns
  - Ntp
  - Pxe (server: tftp and http)
  - Ldap (server: openldap + phpldapadmin, client: SSSD + cache)
  - Slurm (server: munge + slurm, client munge + slurm)
  - Shinken (server: shinken + webui2)
  - Nfs

Once cluster is deployed, it is ready to be used.

Banquise also allows to add/remove/update some parameters (for example adding a compute node, updating mac address of another, etc), and will automatically propagate the modification on the cluster. Cluster maintenance is easy: all configuration files (server/client) are dynamic and are automatically generated/regenerated on the fly if configuration has changed, and impacted services are automatically restarted. It is also possible to check cluster consistency using the same method.

Banquise is using as less as possible packages to reduce attack surface. SELinux is kept activated and enforced on all hosts.

All needed softwares/tools are provided from Banquise repository.

The structure of Banquise should facilitate creation of new elements in the futur.

## 1.3 Known issues

Alpha 2:

  - Possible issue with network.static if pattern twice in ip (10.0.10.0 for example)
  - Only netmask 255.255.0.0 (/16) working
  - Once created, cannot update ldap database main parameters (like dn/cn)
  - BMC of login and io nodes are not taken into account

# 2. Using Banquise

Admin sys beginner notes: if you feel lost, keep in mind that Banquise is just automatically reproducing some part of what was done manually [here](https://www.sphenisc.com/doku.php/system/linux_cluster)

                                            OK, time to dive in. Please follow each step. 
                                           /
                                       ('<       <`)    
                                       /V\       (V)     <`)
                                      <(_)     ]/__)>    (V) 
                                        ~~             ]/__)>

## 2.1 Install saltmaster

Note: saltmaster can directly be installed on master node. However, this should be avoided as having saltmaster hosted somewhere else allows to reinstall quickly master in case of hardware failure.
Other note: saltmaster refer to the Salt Stack server. saltminion or minions refer to the nodes where Salt Stack client side is installed and enabled. In Banquise, master, compute, login and io nodes are minion of the saltmaster.

It is assumed here that user is using Centos, but RHEL instructions are the same.

Note: saltmaster ip will be 10.1.0.77, and master ip 10.1.0.1. Netmask used will be 255.255.0.0.

            +------------+
            |            |
            | saltmaster |
            |            |
            +-----+------+
                  |
         +--------+--------···

It is assumed that during it's first installation, saltmaster system can reach the web to download some files.

Install CentOS 7.2 (or >) with minimal packages (if you need ISO, it can be found [here](http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/). Download CentOS-7-x86_64-Everything-\*.iso).

First step is to setup a local repository for Salt and CentOS rpm. This repository will be used to bootstrap salt-client on minions.

Mount Centos everything DVD (server dvd for RHEL) and copy all content locally (will be also used later to be uploaded on master for repository and pxe process):

    mount CentOS-7-x86_64-Everything-1511.iso /mnt
    mkdir -p /var/www/html/os_dvd.local.repo/
    cp -ar /mnt/* /var/www/html/os_dvd.local.repo/
    umount /mnt

Then create the local repository so OS can install some very basic packages. Remove all files in /etc/yum.repos.d/:

    rm -f /etc/yum.repos.d/*

And create the file `/etc/yum.repos.d/os_dvd.local.repo` with the following content:

    [os_dvd]
    name=os_dvd
    baseurl=file:///var/www/html/os_dvd.local.repo/
    gpgcheck=0
    enabled=1

Now install wget and httpd, and start httpd:

    yum install wget httpd git
    systemctl start httpd
    systemctl enable httpd

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

Install salt-master:

    yum install salt-master salt-ssh

Then add master ip into Salt roster /etc/salt/roster (this allows salt-ssh to know master ip and to boostrap on it). Edit /etc/salt/roster and add (assuming master hostname is master and domain name is sphen.local):

    master.sphen.local:
      host: 10.1.0.1

Configure static ip on ethernet linked to the cluster main network (i.e. also linked to master to be deployed). We will use here the 10.1.0.77/16 ip, and assume the interface connected on the cluster is enp0s8. Edit /etc/sysconfig/network-scripts/ifcfg-enp0s8 as following:

    TYPE=Ethernet
    BOOTPROTO=static
    NAME=enp0s8
    DEVICE=enp0s8
    ONBOOT=yes
    IPADDR=10.1.0.77
    NETMASK=255.255.0.0

Activate interface:

    ifup enp0s8

And set hostname with domain name:

    hostnamectl set-hostname saltmaster.sphen.local

Generate an ssh key without pass-phrase (just press enter for each question):

    ssh-keygen

Also generate another ssh key for future master, and keep it in root as masterkey (private and public key):

    ssh-keygen -f /root/masterkey -N ""

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

## 2.2 Configure Banquise

All Banquise files are in /srv.
/srv/pillar contains "data" (except engine.sls).
/srv/salt contains Banquise "logical" files.

You will need to configure some files.

                                            This is the boring part... 
                                           /                 Z
                                       ('<       <`)        z
                                       /V\       (V)     <`)
                                      <(_)     ]/__)>    (V) 
                                        ~~             ]/__)>

Go into /srv/pillar. Then edit the following files:

**core.sls**:

Specify here the cluster name, and also the saltmaster ip (we used 10.1.0.77 here).

**network.sls**:

Specify here the cluster network parameters.

**master.sls**:

Specify here the master ip (we used 10.1.0.1 here).

**ssh_private.sls**:

Put here the private key of the master created before (this is the content of file /root/masterkey), to replace the one provided as an example. __You need to indent the key__, like the one already in the file.

**ssh_public.sls**:

Put here public key of master and saltmaster (this is the content of files /root/masterkey.pub for ssh\_master\_public\_key and `/root/.ssh/id_rsa.pub` for ssh\_salt\_public\_key), to replace the ones provided as examples.

**passwords_public.sls**:

Put here the hash of the root password that will be set during installation on compute, login and io nodes. To generate this hash, use the following command:

    python -c "import crypt,random,string; print crypt.crypt(raw_input('clear-text password: '), '\$6\$' + ''.join([random.choice(string.ascii_letters + string.digits) for _ in range(16)]))"

**ldap_private.sls**:

Put here the initial ldap password (in clear text, don't worry, access to this file is limited to the master node). Onde cluster is deployed, you can edit this file and set somehting else if you wish.

**ldap_private.sls**:

Put here the initial ldap password hash (use slappasswd command with the password you put in ldap\_private).
Also put here the domain name, by cutting each part separated by a dot in normal domain name, like in the default file.

**computes.sls**:

This file contains data of compute nodes. You can specify only the basic data, and you can add a BMC (if present), and/or you can add other data that will not be used by Banquise (assuming you keep YAML format syntax). If you do not know MAC addresses at this point, put random MAC and you will be able to update them later.

**logins.sls**:

This file contains data of login nodes. Same rules here than for compute nodes.

**ios.sls**:

This file contains data of io nodes. Same rules here than for compute nodes.

**nfs.sls**:

This file contains data of nfs mounting points. Comments are present in the file to help you understand the structure.


That's all for data files.

Now regarding logical files, few things need to be checked in the current version.

  - **Ensure that time zone in /srv/salt/pxe/ks.cfg.jinja is the same as the one you used to deploy saltmaster and master. If not, slurm (munge) will not be able to authenticate.** Default is America/New\_York.
  - If you are using servers with BMC, edit default.jinja2 in /srv/salt/pxe and add console=tty0 console=ttyS1,115200 at the end of line with APPEND. This should allow ipmi console (you may need to change ttyS1 to ttyS0 or ttyS2 depending on your hardware).

Finaly, generate a munge key using:

    dd if=/dev/urandom bs=1 count=1024 > /srv/salt/slurm/munge.key

You shouldn't need to edit other files, except for debugging purposes.

## 2.3 Deploy master

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

Install manually a minimal system on master node, and configure static ip on it to be reachable by saltmaster. We will assume here that interface is enp0s8. Edit /etc/sysconfig/network-scripts/ifcfg-enp0s8 as following:

    TYPE=Ethernet
    BOOTPROTO=static
    NAME=enp0s8
    DEVICE=enp0s8
    ONBOOT=yes
    IPADDR=10.1.0.1
    NETMASK=255.255.0.0

And start interface:

    ifup enp0s8

Then stop and disable network manager and firewall:

    systemctl stop NetworkManager
    systemctl disable NetworkManager
    systemctl stop firewalld
    systemctl disable firewalld

On saltmaster, deploy local ssh key on master:

    ssh-copy-id 10.1.0.1

We now need to copy huge files on master. This means os\_dvd and banquise repository. Choice was to not do this step using Salt Stack as it is not made to copy such number of large files (this would needs a LOT of RAM).

From saltmaster:

    ssh 10.1.0.1 mkdir -p /var/www/html/
    scp -r /root/banquise 10.1.0.1:/var/www/html/banquise.local.repo
    scp -r /var/www/html/os_dvd.local.repo 10.1.0.1:/var/www/html/os_dvd.local.repo
    ssh 10.1.0.1 restorecon -r /var/www/html/

Depending on your hardware, it could take a while...

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

Now, from saltmaster, boostrap the master, using (root password of master will be asked, and accept deploying the key):

    salt-ssh "master.sphen.local" state.apply bootstrap -l debug

Note: if Salt complains about not knowing "boostrap", use "boostrap.init" instead in the previous command.

Check that master tried to register on salt-master (salt-minion service running on master), using:

    salt-key

If yes, accept the key (if not, ensure that on master salt-minion service is installed and running, and that "salt" and "saltmaster" are set in /etc/hosts, also check you disabled firewall on saltmaster and that salt-master service is running on saltmaster. Also, you can restart salt-minion on master to retry to register on saltmaster):

    salt-key -a master.sphen.local

And ask salt to deploy repository server on master, to ensure all goes well after boostrap (mandatory for the following):

    salt "master*" state.apply repository.server -l debug -v

Before last step, **ensure the directories to be exported by your nfs configuration exists** (for example, in default configuration, ensure /soft and /user-home exist on master node).


                                            Now please read the next part entirely before any action. 
                                           /        ?         
                                       ('<       <°)        ?
                                       /V\       (V)     <°)
                                      <(_)     ]/__)>    (V) 
                                        ~~             ]/__)>

--- START ---

Finally, you can deploy master. In normal time, you will use from saltmaster 'salt "master*" state.highstate' to apply configuration or changes on the master. However, because this is the first install you should ssh on master and use salt-call to display all information on what is going on, and to prevent time out of salt-minion.

ssh on master (ssh 10.1.0.1) and use when logged on master:

    salt-call state.highstate -l debug

If it starts, you can go take a coffee. This step is not that long, but depending of your hardware, it could take around 1 to 20 minutes.

Once finished, exit master and from saltmaster ensure all is ok:

    salt "master*" state.highstate -v

If all is green, you are OK, and your master is ready. If not, do not hesitate to ask for help (see mail at top).

--- END ---

**BUG FIX**: please ssh on master, and restart shinken to enable Webui2 interface: systemctl restart shinken*

Install firefox and xauth on master to reach phpldapadmin and shinken web interface later.

    yum install firefox xauth

You are done with the master.

                                           Time to go take a cofee... 
                                          /                 
                                       <`)      <`)        
                                       /V\      /V\     <`)
                                      \(_)>    \(_)>    /V\ 
                                       ~~       ~~     \(_)>
                                                        ~~

## 2.4 Deploy cluster

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

Nodes will have to be deployed this way: io nodes (if exist), **then** login nodes (if exist), **then** compute nodes. For each, **first step** is to have the node to boot on PXE and install the basic OS and salt-minion. **Second step** is to register the new node on saltmaster. **Last step** is to ask Salt from saltmaster to deploy the node.

In the current state (Alpha 2), Banquise does not incorporate a way to help administrator to manage computes nodes PXE. All nodes that boot on PXE will reinstall their OS. This limitation will be removed in next release.

To deploy a node in the current version, simply ask the node to boot on PXE, and once OS is installed, set node to boot on local disk (or you can play with file /var/lib/tftpboot/pxelinux.cfg/default on master, by switching manually the default action).

Once the node has booted, it should automatically try to register on salt-master. From saltmaster, use "salt-key" to display information, and "salt-key -a node.sphen.local" to accept a new key or "salt-key -d node.sphen.local" to delete one (if you want to update a key, delete it, then ssh on the node and restart salt-minion, the new key should be on saltmaster now).

Io, Login and Computes nodes do not need to be bootstraped like master, as salt-minion is automatically deploy and enabled during kickstart process. Master public key is also installed.

**Note**: for io nodes, before deploying configuration, ensure that directories/mounting points to be exported by nfs exist.

Example for compute1, once OS is installed through PXE.

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

Then simply apply configuration on node. From saltmaster use (you can use regex for names in salt, here *):

    salt "compute1.sphen.local" state.highstate -v

You can deploy all nodes this way. If something fail, try launching deploy again. If not resolved, ssh on node and use salt-call like for master deploy step to get more information. If still not resolved, please contact me.

Once finished, cluster is ready.

                                            Now we need to learn how to use this cluster.
                                           /
                                       ('< ~   ~ <`)    
                                       / \>U   U<( )   ~ <`)
                                      <(_)     ]/__)>  U<( ) 
                                        ~~             ]/__)>

## 2.5 Manage cluster

### 2.5.1 Slurm

Once installed, you can ssh on master and enable node(s) into slurm. Check nodes state using:

    sinfo

And move down/drain nodes to compute pool (assuming you just installed compute1, compute2 and compute3):

    scontrol update nodename=compute[1-3] state=idle

And try to launch a job on it:

    srun -N 3 hostname

If the job is executed, you have installed the cluster correctly.

### 2.5.2 Users

We can now create users. 

Log out, and login again with -X (assuming you used -X also to reach saltmaster, it's like a chain, you have to be -X from your system to master):

    ssh 10.1.0.1 -X

And on master, launch firefox (command: firefox). Then, in firefox, go to http://localhost/phpldapadmin .In this interface, login using cn=Manager,dc=sphen,dc=local as login, and the password you generated before for ldap (default is "toto" if you did not changed it).

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702685/71103e9a-30d2-11e7-8b42-41c5b31ee96d.png)](https://cloud.githubusercontent.com/assets/929620/25702685/71103e9a-30d2-11e7-8b42-41c5b31ee96d.png)


To create a user, create first a group for the user.

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702681/710cfb68-30d2-11e7-87e8-9a3358e692c3.png)](https://cloud.githubusercontent.com/assets/929620/25702681/710cfb68-30d2-11e7-87e8-9a3358e692c3.png)

Choose Generic Posix Group, then set user name as group name: oxedion, then click Create Object, then Commit.

Then create the user (like for group, on the left part, select ou=People, and Create a Child Entry, then choose generic User account. Fill form, and ensure User id is the user name, then set password, then choose gid number, the group created before, then set home directory, /home/oxedion, then for login shell select bash, and click Create object and then commit).

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702682/710d7bb0-30d2-11e7-9ebb-d9b969d6ba57.png)](https://cloud.githubusercontent.com/assets/929620/25702682/710d7bb0-30d2-11e7-9ebb-d9b969d6ba57.png)

Do not forget to create the home directory of the user on a login node or a compute node, and to set the good rights:

    ssh 10.1.0.1
    mkdir /home/oxedion
    chown -R oxedion:oxedion /home/oxedion

### 2.5.3 Monitoring with shinken

Still in firefox, go to http://localhost:7767 (it may take some minutes to be up after shinken start/restart). This is shinken webui2 interface.

Login using nagiosadmin/nagiosadmin.

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702683/710dd9b6-30d2-11e7-83f2-5e1db7e918d2.png)](https://cloud.githubusercontent.com/assets/929620/25702683/710dd9b6-30d2-11e7-83f2-5e1db7e918d2.png)

You can visualize cluster status here. For the time being, Banquise do not deploy any probes, only basic ping.

[![Banquise](https://cloud.githubusercontent.com/assets/929620/25702684/710f4e5e-30d2-11e7-87d0-9d35c285cf6b.png)](https://cloud.githubusercontent.com/assets/929620/25702684/710f4e5e-30d2-11e7-87d0-9d35c285cf6b.png)

## 2.6 Update cluster

To update cluster, simple edit the files on saltmaster in /srv/pillar. Once done, from saltmaster, simply run:

    salt "*" state.highstate -v

And wait. This command ask Salt to update all nodes, including master. You can replay this command as many time as you need.



**Thank you for reading this documentation and using Banquise**. Feel free to contact me for any questions/queries.

                              Any questions?
                                               Me. Can we have a nyancat at user logins on login nodes?
                                               It would be very cool!!
                              ... -_-' simply uncomment nyancat line inside pillar/logins_states.sls...
                             /                /  
                         ('<       <`)      A 
                         /V\       (V)     <`)
                        <(_)     ]/__)>    ( ) 
                          ~~             ]/__)>


# To be done

  - Missing SSL for ldap
  - Missing iptables
  - Missing interconnect (need hardware)
  - Missing PXE and Basic configuration files generator scrip (dialog based)
  - Missing basic probes for Shinken
  - Debian and SLES integration (pkgs only today, and nothing inside)

