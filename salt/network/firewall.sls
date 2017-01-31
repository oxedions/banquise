firewall:
  pkg.removed:
    - name: {{ pillar['pkgs']['firewall'] }}
    - require:
      - sls: repository.client
