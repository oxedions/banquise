networkmanager_service:
  service:
    - name: {{ pillar['services']['networkmanager'] }}
    - dead
    - disabled: True

networkmanager:
  pkg.removed:
    - name: {{ pillar['pkgs']['networkmanager'] }}
    - require:
      - sls: repository.client
      - service: networkmanager_service
