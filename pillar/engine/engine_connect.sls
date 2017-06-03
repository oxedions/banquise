{% import_yaml 'cluster/network.sls' as net %}
{% import_yaml 'cluster/masters/masters.sls' as mas %}
{% import_yaml 'cluster/masters/masters_states.sls' as mas_states %}
{% import_yaml 'cluster/core.sls' as cor %}
{% import_yaml 'cluster/connect.sls' as con %}

engine_connect:

{% for server, server_args in con.connect.items() %}

# External ip, use provided values for ip(s) and host(s)
{% if server_args.management == "external" %}
  {{server~"_ip"}}:
  {% for ip in server_args.ip_value %}
    - {{ip}}
  {% endfor %}
  {{server~"_host"}}:
  {% for host in server_args.host_value %}
    - {{host}}
  {% endfor %}
{% endif %}

# Auto ip, get who install the to check state
{% if server_args.management == "auto" %}
  {{server~"_ip"}}:
  {% for masst, masst_args in mas_states.masters_states.items() %}
    {% for states in masst_args %}
      {% if states == server_args.state_to_watch %}
        {% for masters, masters_args in mas.masters.items() %}
          {% if masters == masst %}
    - {{masters_args.network.net0.ip}}
          {% endif %}
        {% endfor %}
      {% endif %}
    {% endfor %}
  {% endfor %}
  {{server~"_host"}}:
  {% for masst, masst_args in mas_states.masters_states.items() %}
    {% for states in masst_args %}
      {% if states == server_args.state_to_watch %}
    - {{masst}}
      {% endif %}
    {% endfor %}
  {% endfor %}

{% endif %}

{% endfor %}





