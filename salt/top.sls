<<<<<<< HEAD
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

=======
base:

# masters
{% for master, sta in salt['pillar.get']('masters_states').items() %}
  '{{master}}.{{salt['pillar.get']('network:domaine_name')}}':
  {% for st in sta %}
    - {{ st }}
  {% endfor %}
{% endfor %}

# compute nodes
{% for compute, sta in salt['pillar.get']('computes_states').items() %}
  '{{compute}}.{{salt['pillar.get']('network:domaine_name')}}':
  {% for st in sta %}
    - {{ st }}
  {% endfor %}
{% endfor %}

# login nodes
{% for login, sta in salt['pillar.get']('logins_states').items() %}
  '{{login}}.{{salt['pillar.get']('network:domaine_name')}}':
  {% for st in sta %}
    - {{ st }}
  {% endfor %}
{% endfor %}

# ios nodes
{% for io, sta in salt['pillar.get']('ios_states').items() %}
  '{{io}}.{{salt['pillar.get']('network:domaine_name')}}':
  {% for st in sta %}
    - {{ st }}
  {% endfor %}
{% endfor %}


>>>>>>> fd940a25f1140ac17f02364496b45f25fb24a45f
