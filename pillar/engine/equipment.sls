{% import_yaml 'cluster/settings/general_settings.sls' as general_settings %}

equipment_list:
# Allowed to all hosts
{% set buffer_list = [] %}

{% for nodes_group in general_settings.general_settings.nodes_groups %}
{% import_yaml ("cluster/nodes/"+nodes_group+".sls") as current_group %}
{% for group, group_args in current_group.items() %}
{% for equipment in group_args %}
{% if equipment not in buffer_list %}
{% do buffer_list.append(equipment|string) %}
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}

{% for equipment in buffer_list %}
  - {{equipment}}
{% endfor %}
