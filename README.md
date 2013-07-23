Saltstack config files
======================

Configure a Debian/Ubuntu development environment with salt.

Directories:

base - for production sceneries

dev - for testing sceneries

Setup
-----

   git clone https://github.com/y0j/salt-configs.git /srv/salt/


``/etc/salt/master``:

	pillar_roots:
  		base:
    		- /srv/salt/base/pillar
  		dev:
    		- /srv/salt/dev/pillar

	file_roots:
  		base:
    		- /srv/salt/base
  		dev:
    		- /srv/salt/dev


There may not be a need to follow the structure above, but I do it to
separate production and testing environment.
