munge:
  pkg.installed:
    - name: {{ pillar['pkgs']['munge'] }}
    - require:
      - sls: repository.client

/etc/munge/munge.key:
  file.managed:
    - source: salt://slurm/munge.key
    - mode: '0400'
    - user: munge
    - group: munge
    - require:
      - pkg: munge

/var/run/munge:
  file.directory:
    - user: munge
    - group: munge
    - mode: 755
    - require:
      - pkg: munge

mungeservice:
  service:
    - name: {{ pillar['services']['munge'] }}
    - running
    - enable: True
    - watch:
      - file: /etc/munge/munge.key
    - require:
      - pkg: {{ pillar['pkgs']['munge'] }}
      - file: /etc/munge/munge.key

slurm:
  pkg.installed:
    - name: {{ pillar['pkgs']['slurm'] }}
    - require:
      - sls: repository.client

slurm-munge:
  pkg.installed:
    - name: {{ pillar['pkgs']['slurm_munge'] }}
    - require:
      - sls: repository.client

/etc/slurm/slurm.conf:
  file.managed:
    - source: salt://slurm/slurm.conf.jinja
    - template: jinja
    - require:
      - pkg: {{ pillar['pkgs']['slurm'] }}

/etc/slurm/slurm.epilog.clean:
  file.managed:
    - source: salt://slurm/slurm.epilog.clean
    - mode: '0700'
    - user: slurm
    - group: slurm
    - require:
      - pkg: {{ pillar['pkgs']['slurm'] }}

slurm-group:
  group.present:
    - gid: 567
    - name: slurm

slurm-user:
  user.present:
    - name: slurm
    - fullname: slurm user
    - shell: /bin/false
    - home: /etc/slurm
    - uid: 567
    - gid: 567
    - require:
      - group: slurm-group

/var/spool/slurm:
  file.directory:
    - user: slurm
    - group: slurm
    - mode: 755
    - require:
      - user: slurm-user

/var/log/slurm:
  file.directory:
    - user: slurm
    - group: slurm
    - require:
      - user: slurm-user

/var/spool/slurm/savestate:
  file.directory:
    - user: slurm
    - group: slurm
    - require:
      - user: slurm-user
      - file: /var/spool/slurm

slurmservice:
  service:
    - name: {{ pillar['services']['slurmclient'] }}
    - running
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['slurm'] }}
      - pkg: {{ pillar['pkgs']['slurm_munge'] }}
      - service: mungeservice
      - file: /var/spool/slurm/savestate
      - file: /var/log/slurm
      - file: /etc/slurm/slurm.epilog.clean
      - file: /var/spool/slurm
      - file: /etc/slurm/slurm.conf
      - sls: dns.client
      - sls: network.static
