<<<<<<< HEAD
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/core.sls' as cor %}

base:
# Allowed to all hosts
  '*':
    - cluster/pkgs
    - cluster/services
{%- for types in cor.core.types %}
    - cluster/nodes/{{types}}
    - cluster/nodes/{{types}}_states
{%- endfor %}
    - cluster/io/nfs
    - cluster/network
    - cluster/masters/masters
    - cluster/masters/masters_states
    - engine/engine
    - cluster/core
    - cluster/authentication/ssh_public
    - cluster/authentication/passwords_public
    - cluster/authentication/ldap_public
    - engine/engine_connect
    - engine/engine_monitoring
    - engine/engine_reverse
#    - engine/engine_ip
    - engine/engine_network
    - cluster/monitoring
# Allowed to masters only, secure passwords and ssh private key
{% for master in mas.masters %}
  '{{master}}.{{cor.core.domain_name}}':
    - cluster/authentication/ssh_private
    - cluster/authentication/ldap_private
{% endfor %}
=======
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
    - logins
    - ios
    - engine
    - core
    - ssh_public
    - passwords_public
    - ldap_public
    - masters_states
    - computes_states
    - logins_states
    - ios_states
# Allowed to masters only, secure passwords and ssh private key
{% for master in mas.masters %}
  '{{master}}.{{net.network.domaine_name}}':
    - ssh_private
    - ldap_private
{% endfor %}
>>>>>>> fd940a25f1140ac17f02364496b45f25fb24a45f
