nyancat:
  pkg.installed:
    - name: nyancat
    - require:
      - sls: repository.client
        
/etc/profile.d/nyancat_login.sh:
  file:                                    
    - managed                               
    - source: salt://nyancat/nyancat_login.sh
    - mode: 555 
    - require:
      - pkg: nyancat

