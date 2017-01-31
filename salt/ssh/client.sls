root_public_key:
  ssh_auth.present:
    - names:
      - {{salt['pillar.get']('ssh_public:ssh_master_public_key')}}
      - {{salt['pillar.get']('ssh_public:ssh_salt_public_key')}}
    - user: root
    - config: '/root/.ssh/authorized_keys'
