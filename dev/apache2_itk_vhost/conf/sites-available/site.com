<VirtualHost {{ pillar["apache2_itk_vhost"]["vhost_ip"] }}:80>

<IfModule mpm_itk_module>
          AssignUserId {{ pillar["apache2_itk_vhost"]["user"] }} {{ pillar["apache2_itk_vhost"]["group"] }}
</IfModule>

  ServerName {{ pillar["apache2_itk_vhost"]["domain"] }}
  ServerAlias {{ pillar["apache2_itk_vhost"]["alias"] }}

DocumentRoot {{ pillar["apache2_itk_vhost"]["documentroot"] }}/html
ErrorLog {{ pillar["apache2_itk_vhost"]["documentroot"] }}/logs/error.log
CustomLog {{ pillar["apache2_itk_vhost"]["documentroot"] }}/logs/access.log common

SetEnvIfNoCase Referer "{{ pillar["apache2_itk_vhost"]["domain"] }}" local_ref=1
SetEnvIfNoCase Referer "{{ pillar["apache2_itk_vhost"]["alias"] }}" local_ref=1
SetEnvIfNoCase referer "^$" local_ref=1

<FilesMatch "\.(gif|jpg|jpeg|png|ico|bmp|mpg|mp3|mpeg|avi|wmv|js|css)$">
  Order Allow,Deny
  Allow from env=local_ref
</FilesMatch>

<Directory />
    Options All -Indexes
    AllowOverride All
</Directory>

  RewriteEngine on
  RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
  RewriteRule .* - [F]

</VirtualHost>
