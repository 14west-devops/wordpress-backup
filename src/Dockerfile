FROM ubuntu

LABEL maintainer="DevOps <devops@14west.us>"

#run setup as user
USER root

#add backup user
RUN groupadd -r wp-backup && useradd -r -g wp-backup wp-backup

#patch away
RUN date &&\
    apt-get update && \
    apt-get install wget mysql-client cron bzip2 -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install go-cron
ENV GOCROND_VERSION=0.6.0
RUN wget -O /usr/local/bin/go-crond https://github.com/webdevops/go-crond/releases/download/$GOCROND_VERSION/go-crond-64-linux &&\
    chmod +x /usr/local/bin/go-crond

#create backup folder and give user access
RUN mkdir /backups
RUN chown -R wp-backup:wp-backup /backups &&\
    chown -R wp-backup:wp-backup /bin
    
ENV MYSQL_ENV_MYSQL_HOST mysql-db
ENV BACKUP_TIME "0 3 * * *"

# copy in and allow execute of scripts
COPY docker-entrypoint.sh bin/entrypoint.sh
RUN chmod +x bin/entrypoint.sh

COPY backup restore /bin/
RUN chmod +x /bin/backup &&\
    chmod +x /bin/restore

VOLUME /backups

#adding a user to this image adds it at 999
#using uid is recommended for openshift
USER 999
ENTRYPOINT ["bin/entrypoint.sh"]

CMD ["go-crond"]
