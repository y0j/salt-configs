bind9:
    pkg.installed:
        - name: bind9
    service.running:
        - enable: True
        - reload: True
        - watch:
            - file: domain_zone
            - file.append: vhosts 

named.conf:
    file.append:
        - name: /etc/bind/named.conf
        - text: |
            include "/etc/bind/vhosts.conf";
        - require:
            - pkg: bind9

domain_zone:
    file.managed:
        - name: /etc/bind/primary/{{ pillar["bind9"]["domain_zone"] }}
        - source: salt://bind9/primary/domain.zone
        - template: jinja
        - user: root
        - group: bind
        - mode: 0644
        - require:
            - pkg: bind9
            - file: named.conf

add_vhosts_file:
    file.managed:
        - name: /etc/bind/vhosts.conf
        - require:
            - pkg: bind9

vhosts:
    file.append:
        - name: /etc/bind/vhosts.conf
        - text: |  
       
            zone "{{ pillar["bind9"]["domain"] }}" {
              type master;
              file "/etc/bind/primary/{{ pillar["bind9"]["domain_zone"] }}"; 
            };
        - require:
            - file: add_vhosts_file
