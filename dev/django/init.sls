include:
    - requirements_django
    - nginx_django
    - uwsgi_django
    - postgresql_django

create Django project:
    cmd.run: 
        - user: {{ pillar["django"]["user"] }} 
        - name: "virtualenv {{ pillar["django"]["documentroot"] }} && . {{ pillar["django"]["documentroot"] }}/bin/activate && cd {{ pillar["django"]["documentroot"] }} && pip install django psycopg2 && django-admin.py startproject project"
        - require:
            - pkg: python-dev
            - pkg: python-virtualenv
            - file: pg_hba.conf

djangouser:
    postgres_user.present:
        - name: {{ pillar["django"]["dbuser"] }}
        - password: {{ pillar["django"]["dbpassword"] }}
        - runas: postgres
        - require:
            - service: postgresql

djangodb:
    postgres_database.present:
        - name: {{ pillar["django"]["dbname"] }}
        - encoding: UTF8
        - lc_ctype: en_US.UTF8
        - lc_collate: en_US.UTF8
        - template: template0
        - owner: {{ pillar["django"]["dbuser"] }}
        - runas: postgres
        - require:
            - postgres_user: djangouser

settings.py:
    file.managed:
        - name: {{ pillar["django"]["documentroot"] }}/project/project/settings.py
        - source: salt://django/settings.py
        - template: jinja
        - user: {{ pillar["django"]["user"] }}
        - require:
            - postgres_user: djangouser
