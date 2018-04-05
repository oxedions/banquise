{% set subtype = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':subtype') %}
{% set type = salt['pillar.get']('engine_reverse:'~salt['grains.get']('id')~':type') %}

{% set hostname = (salt['grains.get']('id')|replace("."~salt['pillar.get']('engine:network:domaine_name'),'')) %}

{% if type == "masters" %}
{% set netpath = type~":"~hostname~":network" %}
{% else %}
{% set netpath = type~":"~subtype~":"~hostname~":network" %}
{% endif %}
