#!/bin/bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    apt-get -y update
    apt-get -y install nginx
fi

# Create necessary directories if they don't exist
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create a fake HTML file
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" > /data/web_static/releases/test/index.html

# Create or recreate the symbolic link
rm -f /data/web_static/current
ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
if [[ -f $config_file ]]; then
    sed -i '/location \/hbnb_static {/a \
        alias /data/web_static/current/;' $config_file
fi

# Restart Nginx
service nginx restart

exit 0
