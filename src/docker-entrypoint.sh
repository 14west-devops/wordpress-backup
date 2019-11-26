#!/bin/bash

if ! whoami &> /dev/null; then
  echo 'Setting up etc/passwd for artibtrary user'
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

if ! [ -f backup-cron ]
then
  echo "Creating go-crond entry to start backup at: $BACKUP_TIME"
  # Note: Must use tabs with indented 'here' scripts.
  cat <<-EOF >> /usr/local/bin/backup-cron
#START
SHELL=/bin/bash
MYSQL_ENV_MYSQL_HOST=$MYSQL_ENV_MYSQL_HOST
MYSQL_ENV_MYSQL_USER=$MYSQL_ENV_MYSQL_USER
MYSQL_ENV_MYSQL_DATABASE=$MYSQL_ENV_MYSQL_DATABASE
MYSQL_ENV_MYSQL_PASSWORD=$MYSQL_ENV_MYSQL_PASSWORD
EOF

  if [[ $CLEANUP_OLDER_THAN ]]
  then
    echo "CLEANUP_OLDER_THAN=$CLEANUP_OLDER_THAN" >> /usr/local/bin/backup-cron
  fi
  echo "$BACKUP_TIME backup > /usr/local/bin/backup.log" >> /usr/local/bin/backup-cron
  echo "#END" >> /usr/local/bin/backup-cron

  #cat bin/backup-cron

  go-crond --allow-unprivileged --verbose wp-backup:/usr/local/bin/backup-cron 
fi

echo "Current go-crond:"
go-crond --version

exec "$@"
