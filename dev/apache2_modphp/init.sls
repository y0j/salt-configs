{% if grains['os'] == 'Debian' %}

apache2:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: apache2

php5-pkgs:
  pkg.installed:
    - names:
      - php5
      - libapache2-mod-php5
      - dh-make-php
      - php5-imagick
      - php5-imap
      - php5-mcrypt
      - php5-mysql
      - php5-snmp
      - php5-suhosin
      - php5-xmlrpc
      - php5-xsl                
      - php5-mysql
      - php5-curl
      - php5-cli
      - php5-cgi
      - php5-dev
      - php-pear
      - php5-gd
      - php-pear

{% endif %}
