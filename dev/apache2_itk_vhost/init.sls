include:
    - apache2

site:
    file.managed:
        - name: /etc/apache2/sites-available/{{ pillar["apache2_itk_vhost"]["domain"] }}
        - source: salt://apache2_itk_vhost/conf/sites-available/site.com
        - template: jinja
        - user: root
        - group: root
        - file_mode: 0644
        - require:
             - pkg: apache2

site-enabled:
    file.symlink:
        # Executes after site
        - name: /etc/apache2/sites-enabled/{{ pillar["apache2_itk_vhost"]["domain"] }}
        - target: ../sites-available/{{ pillar["apache2_itk_vhost"]["domain"] }}
        - makedirs: True
        - require:
            - pkg: apache2
            - file: site
html:
    file.directory:
        - name: {{ pillar["apache2_itk_vhost"]["documentroot"] }}/html
        - user: {{ pillar["apache2_itk_vhost"]["user"] }}
        - group: {{ pillar["apache2_itk_vhost"]["group"] }}
        - mode: 0755
        - makedirs: True

logs:
    file.directory:
        - name: {{ pillar["apache2_itk_vhost"]["documentroot"] }}/logs
        - user: root
        - group: root
        - mode: 0750
        - makedirs: True

access.log:
    file.managed:
        - name: {{ pillar["apache2_itk_vhost"]["documentroot"] }}/logs/access.log
        - user: root
        - group: root
        - mode: 640

error.log:
    file.managed:
        - name: {{ pillar["apache2_itk_vhost"]["documentroot"] }}/logs/error.log
        - user: root
        - group: root
        - mode: 640
