{% import_yaml 'masters.sls' as mas %}
{% import_yaml 'network.sls' as net %}

base:
# Allowed to all hosts
  '*':
    - pkgs
    - services
    - computes
    - nfs
    - network
    - masters
    - engine
    - core
    - ssh_public
    - passwords_public
    - ldap_public
# Allowed to masters only
{% for master in mas.masters %}
  '{{master}}.{{net.network.domaine_name}}':
    - ssh_private
    - ldap_private
{% endfor %}
