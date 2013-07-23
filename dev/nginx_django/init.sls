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
        - source: salt://nginx_django/conf/nginx.conf
        - user: root
        - group: root
        - file_mode: 0644
        - require:
            - pkg: nginx

site:
    file.managed:
        - name: /etc/nginx/sites-available/{{ pillar["django"]["domain"] }}
        - source: salt://nginx_django/conf/sites-available/site.com
        - template: jinja
        - user: root
        - group: root
        - file_mode: 0644
        - require:
            - pkg: nginx

site-enabled:
    file.symlink:
        # Executes after osf-site
        - name: /etc/nginx/sites-enabled/{{ pillar["django"]["domain"] }}
        - target: ../sites-available/{{ pillar["django"]["domain"] }}
        - makedirs: True
        - require:
              - pkg: nginx
              - file: site

logs:
    file.directory:
        - name: {{ pillar["django"]["documentroot"] }}/logs
        - user: root
        - group: root
        - mode: 0755
        - makedirs: True

access.log:
    file.managed:
        - name: {{ pillar["django"]["documentroot"] }}/logs/access.log
        - user: root
        - group: root

error.log:
    file.managed:
        - name: {{ pillar["django"]["documentroot"] }}/logs/error.log
        - user: root
        - group: root

static:
    file.directory:
        - name: {{ pillar["django"]["documentroot"] }}/project/project/static
        - user: {{ pillar["django"]["user"] }}
        - group: {{ pillar["django"]["group"] }}
        - mode: 755
        - makedirs: True

media:
    file.directory:
        - name: {{ pillar["django"]["documentroot"] }}/project/project/media
        - user: {{ pillar["django"]["user"] }}
        - group: {{ pillar["django"]["group"] }}
        - mode: 755
        - makedirs: True

templates:
    file.directory:
        - name: {{ pillar["django"]["documentroot"] }}/project/project/templates
        - user: {{ pillar["django"]["user"] }}
        - group: {{ pillar["django"]["group"] }}
        - mode: 755 
        - makedirs: True

