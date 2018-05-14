# Prepare installation

## Download needed elements

The management nodes needs a Centos Everything DVD iso. It is possible to download one from `http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7/isos/x86_64/`

Clients nodes need a Centos Everything DVD iso or a Fedora iso (one depending of the desktop you whish: gnome, xfce, kde, etc).
For Centos, see above to download. For Fedora, see at https://getfedora.org/ or https://spins.fedoraproject.org/ . Note that for very large network, you may need for Fedora an Everything iso also to lower web bandwith usage.

Get also Banquise repositories:
```bash
wget --reject="index.html*" -nH -r --no-parent https://repo.saltstack.com/yum/redhat/7/x86_64/2016.11/
```
