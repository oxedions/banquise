#!/bin/sh

echo "Please enter ldap Manager password:"
read ldap_pass
ldap_pass_hash="'"$(slappasswd -s $ldap_pass)"'"

echo 'ldap_private:' > ../pillar/cluster/authentication/ldap_private.sls
echo "  ldap_admin_pass: $ldap_pass           # this administration password will only be used during ldap server installation, and is protected by pillar/top.sls" >> ../pillar/cluster/authentication/ldap_private.sls

echo 'ldap_public:' > ../pillar/cluster/authentication/ldap_public.sls
echo "  ldap_admin_pass_ssha: $ldap_pass_hash      # Hash obtained using slappasswd with the password defined in private part" >> ../pillar/cluster/authentication/ldap_public.sls
echo '  dc:                                                         # Use your domain name here if you don t know what is dc for ldap (cut your domaine name at ".", here sphen.local is cut in two parts)' >> ../pillar/cluster/authentication/ldap_public.sls
echo '    - sphen' >> ../pillar/cluster/authentication/ldap_public.sls
echo '    - local' >> ../pillar/cluster/authentication/ldap_public.sls

rm -f /tmp/id_rsa*
ssh-keygen -N "" -f /tmp/id_rsa

echo "ssh_private:" > ../pillar/cluster/authentication/ssh_private.sls
echo "  # Put here your ssh private key. It will be installed on the master and used to login on nodes installed thanks to PXE. Note: beware, you need to indent like wiht this example." >> ../pillar/cluster/authentication/ssh_private.sls
echo "  ssh_master_private_key: |" >> ../pillar/cluster/authentication/ssh_private.sls
cat /tmp/id_rsa | sed 's/^/    /' >> ../pillar/cluster/authentication/ssh_private.sls

echo "ssh_public:" > ../pillar/cluster/authentication/ssh_public.sls
echo "  # This is the ssh public key related to private key given in private part of ssh." >> ../pillar/cluster/authentication/ssh_public.sls
echo "  ssh_master_public_key: $(cat /tmp/id_rsa.pub)" >> ../pillar/cluster/authentication/ssh_public.sls 

echo "Please enter root password for nodes (not master):"
read root_pass
root_pass="'"$root_pass"'"
root_pass_hash=$(python -c "import crypt,random,string; print crypt.crypt($root_pass, '\$6\$' + ''.join([random.choice(string.ascii_letters + string.digits) for _ in range(16)]))")
echo "passwords_public:" > ../pillar/cluster/authentication/passwords_public.sls
echo "  root_password_hash: $root_pass_hash   # This password hash will be the root password of all nodes installed" >> ../pillar/cluster/authentication/passwords_public.sls

