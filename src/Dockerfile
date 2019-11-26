FROM ubuntu

LABEL maintainer="DevOps <devops@14west.us>"

#run setup as user
USER root

#add backup user
RUN groupadd -r wp-backup && useradd -r -g wp-backup wp-backup

#patch away
RUN apt-get update && \
    apt-get install mysql-client cron bzip2 -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#create backup folder and give user access
RUN mkdir /backups
RUN chown -R wp-backup:wp-backup /backups
    
ENV MYSQL_ENV_MYSQL_HOST mysql-db
ENV BACKUP_TIME "0 3 * * *"

# copy in and allow execute of scripts
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY backup restore /bin/
RUN chmod +x /bin/backup &&\
    chmod +x /bin/restore

VOLUME /backups

USER wp-backup
ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron", "-f"]
