{% import_yaml 'masters.sls' as mas %}
{% import_yaml 'network/network.sls' as net %}

base:
# Allowed to all hosts
  '*':
    - pkgs
    - services
    - nodes/switchs
    - nodes/switchs_states
    - nodes/computes
    - nodes/computes_states
#    - engine/computes_gather
    - nodes/logins
    - nodes/logins_states
#    - engine/logins_gather
    - nodes/ios
    - nodes/ios_states
#    - engine/ios_gather
    - io/nfs
    - network/network
    - masters
    - masters_states
    - engine/engine
    - core
    - authentication/ssh_public
    - authentication/passwords_public
    - authentication/ldap_public
    - engine/engine_monitoring
    - engine/engine_reverse
    - monitoring
# Allowed to masters only, secure passwords and ssh private key
{% for master in mas.masters %}
  '{{master}}.{{net.network.net0.domaine_name}}':
    - authentication/ssh_private
    - authentication/ldap_private
{% endfor %}
