uwsgi:
    pkg.installed:
        # Executes after all.
        - name: uwsgi
    service.running:
        - enable: True
        - reload: True
        - require:
            - file: uwsgi-apps-available
        - mod_watch:
            - file: uwsgi-apps-available
            - file: uwsgi.ini
            - file: /etc/default/uwsgi

uwsgi.ini:
    file.managed:
    # Executes before uwsgi is installed.
        - name: /etc/uwsgi/uwsgi.ini
        - source: salt://uwsgi_django/conf/uwsgi.ini
        - template: jinja
        - user: root
        - group: root
        - require:
            - pkg: uwsgi 

uwsgi-apps-available:
    file.managed:
        - name: /etc/uwsgi/apps-available/{{ pillar["django"]["domain"] }}.ini
        - source: salt://uwsgi_django/conf/apps-available/site.com.ini
        - template: jinja
        - user: root
        - group: root
        - dir_mode: 0644
        - file_mode: 0644
        - require:
            - pkg: uwsgi

uwsgi-apps-enabled:
    file.symlink:
        # Executes after osf-site
        - name: /etc/uwsgi/apps-enabled/{{ pillar["django"]["domain"] }}.ini
        - target: ../apps-available/{{ pillar["django"]["domain"] }}.ini
        - require:
              - file: uwsgi-apps-available

/etc/default/uwsgi:
      file.sed:  
        - before: '/usr/share/uwsgi/conf/default.ini'  
        - after: '/etc/uwsgi/uwsgi.ini'
        - limit: '^INHERITED_CONFIG='
        - require:
              - pkg: uwsgi
