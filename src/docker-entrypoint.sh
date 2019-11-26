#!/bin/bash
if ! [ -f backup-cron ]
then
  echo "Creating go-crond entry to start backup at: $BACKUP_TIME"
  # Note: Must use tabs with indented 'here' scripts.
  cat <<-EOF >> bin/backup-cron
#START
SHELL=/bin/bash
MYSQL_ENV_MYSQL_HOST=$MYSQL_ENV_MYSQL_HOST
MYSQL_ENV_MYSQL_USER=$MYSQL_ENV_MYSQL_USER
MYSQL_ENV_MYSQL_DATABASE=$MYSQL_ENV_MYSQL_DATABASE
MYSQL_ENV_MYSQL_PASSWORD=$MYSQL_ENV_MYSQL_PASSWORD
EOF

  if [[ $CLEANUP_OLDER_THAN ]]
  then
    echo "CLEANUP_OLDER_THAN=$CLEANUP_OLDER_THAN" >> bin/backup-cron
  fi
  echo "$BACKUP_TIME backup > bin/backup.log" >> bin/backup-cron
  echo "#END" >> bin/backup-cron

  #cat bin/backup-cron

  go-crond wp-backup:bin/backup-cron --allow-unprivileged
fi

echo "Current go-crond:"
go-crond --version

exec "$@"
