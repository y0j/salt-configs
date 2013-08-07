include: 
    - nginx_phpfpm 

phpfpm:
  pkg:
    - latest
    - names:
      - php5-fpm

user.conf:
    file.managed:
        - name: /etc/php5/fpm/pool.d/{{ pillar["nginx_phpfpm"]["user"] }}.conf
        - source: salt://phpfpm/fpm/pool.d/user.conf
        - template: jinja
        - user: root
        - group: root
        - file_mode: 644
        - require:
            - pkg: phpfpm
