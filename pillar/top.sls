{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/core.sls' as cor %}

base:
# Allowed to all hosts
  '*':
    - general/*
{%- for types in cor.core.types %}
    - cluster/nodes/{{types}}
    - cluster/nodes/{{types}}_states
    - cluster/nodes/{{types}}_system
{%- endfor %}
    - cluster/io/nfs
    - cluster/network
    - cluster/masters/masters
    - cluster/masters/masters_states
    - cluster/masters/masters_system
#    - engine/engine # Should be removed soon
    - cluster/core
    - cluster/authentication/ssh_public
    - cluster/authentication/passwords_public
    - cluster/authentication/ldap_public
    - engine/engine_connect
    - engine/engine_monitoring
    - engine/engine_reverse
    - engine/engine_network
    - engine/equipment
    - engine/system
    - cluster/monitoring
# Allowed to masters only, secure passwords and ssh private key
{% for master in mas.masters %}
  '{{master}}.{{net.network.global_parameters.domain_name}}':
    - cluster/authentication/ssh_private
    - cluster/authentication/ldap_private
{% endfor %}
