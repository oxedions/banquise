{% import 'engine/yaml_macros.sls' as yaml_macros %}

{% import_yaml 'engine/equipment.sls' as equipment %}

all_system:

{% for current_equipment in equipment.equipment_list %}

{% import_yaml ("cluster/equipment/"+current_equipment+"/system.sls") as current_system %}

{{yaml_macros.write_yaml(current_system.system)}}

{% endfor %}


