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


