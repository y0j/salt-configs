nginx:
    pkg.installed:
        # Executed first for this file.
        - name: nginx
    service.running:
        # Executes last.
        - enable: True
        - reload: True
        - require:
            - file: site-enabled 
        - watch:
            - file: nginx.conf
            - file: site
            - file: site-enabled

nginx.conf:
    file.managed:
       # executes after package is installed
        - name: /etc/nginx/nginx.conf
        - source: salt://nginx_phpfpm/conf/nginx.conf
        - user: root
        - group: root
        - file_mode: 0644
        - require:
            - pkg: nginx

site:
    file.managed:
        - name: /etc/nginx/sites-available/{{ pillar["nginx_phpfpm"]["domain"] }}
        - source: salt://nginx_phpfpm/conf/sites-available/site.com
        - template: jinja
        - user: root
        - group: root
        - file_mode: 0644
        - require:
            - pkg: nginx

site-enabled:
    file.symlink:
        # Executes after site
        - name: /etc/nginx/sites-enabled/{{ pillar["nginx_phpfpm"]["domain"] }}
        - target: ../sites-available/{{ pillar["nginx_phpfpm"]["domain"] }}
        - makedirs: True
        - require:
              - pkg: nginx
              - file: site

logs:
    file.directory:
        - name: {{ pillar["nginx_phpfpm"]["documentroot"] }}/logs
        - user: root
        - group: root
        - mode: 0755
        - makedirs: True

access.log:
    file.managed:
        - name: {{ pillar["nginx_phpfpm"]["documentroot"] }}/logs/access.log
        - user: root
        - group: root

error.log:
    file.managed:
        - name: {{ pillar["nginx_phpfpm"]["documentroot"] }}/logs/error.log
        - user: root
        - group: root

html:
    file.directory:
        - name: {{ pillar["nginx_phpfpm"]["documentroot"] }}/html
        - user: {{ pillar["nginx_phpfpm"]["user"] }}
        - group: {{ pillar["nginx_phpfpm"]["group"] }}
        - mode: 755
        - makedirs: True

