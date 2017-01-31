/etc/resolv.conf:
  file:
    - managed
    - source: salt://dns/resolv.conf.jinja
    - template: jinja
    - require:
      - sls: network.nmanager
