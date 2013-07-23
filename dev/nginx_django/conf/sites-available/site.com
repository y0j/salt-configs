server {
    listen  80;
    server_name {{ pillar["django"]["domain"] }} www.{{ pillar["django"]["domain"] }};

    access_log {{ pillar["django"]["documentroot"] }}/logs/access.log;
    error_log {{ pillar["django"]["documentroot"] }}/logs/error.log;

    location / {
        uwsgi_pass  unix:///tmp/{{ pillar["django"]["domain"] }}.sock;
        include     uwsgi_params;
    }

    location /media/  {
        alias {{ pillar["django"]["documentroot"] }}/project/project/media/;
    }

    location  /static/ {
        alias  {{ pillar["django"]["documentroot"] }}/project/project/static/;
    }
}
