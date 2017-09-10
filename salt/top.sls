base:

# masters
{% for master, sta in salt['pillar.get']('masters_states').items() %}
  '{{master}}.{{salt['pillar.get']('engine:network:domaine_name')}}':
  {% for st in sta %}
    - {{ st }}
  {% endfor %}
{% endfor %}

{%- for type in salt['pillar.get']('core:types') %}
# {{type}} nodes
{% for group, args in salt['pillar.get'](type).items() %}
{% for node, argo in args.items() %}
  {% if salt['pillar.get'](type~'_states:'~group) is not none %}
  '{{node}}.{{salt['pillar.get']('engine:network:domaine_name')}}':
  {% for st in salt['pillar.get'](type~'_states:'~group) %}
    - {{ st }}
  {% endfor %}
  {% endif %}
{% endfor %}
{% endfor %}
{%- endfor %}

