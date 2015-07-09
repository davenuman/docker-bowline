#!/bin/bash -e
set -e

source /opt/rh/php55/enable

# Create required directories just in case.
mkdir -p /var/www/logs /var/www/files-private
echo "*" > /var/www/logs/.gitignore

# Set the apache user and group to match the host user.
OWNER=$(stat -c '%u' /var/www)
GROUP=$(stat -c '%g' /var/www)
if [ "$OWNER" != "0" ]; then
  usermod -o -u $OWNER apache
  usermod -s /bin/bash apache
  groupmod -o -g $GROUP apache
  usermod -d /var/www apache
  useradd -o -u $OWNER -g $GROUP -M -d /var/www www-data
  chown -R --silent apache:apache /var/www
fi
echo The apache user and group has been set to the following:
id apache

exec "$@"
