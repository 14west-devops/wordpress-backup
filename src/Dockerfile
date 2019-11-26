FROM centos:centos7

LABEL name="14WestDevOps/wordpress-backup" \
      maintainer="DevOps <devops@14west.us>" \
      vendor="14West" \
      version="1" \
      release="1" \
      summary="Backup/Restore wordpress sites" \
      description="Used to backup/restore a given wordpress site defined by environment variables"

#add backup user
RUN groupadd -r wp-backup && useradd -r -g wp-backup wp-backup

#patch away
RUN date &&\
    yum -y update && \
    yum -y install wget mysql-client cron bzip2 -y && \
    yum clean all

# install go-cron
ENV GOCROND_VERSION=0.6.0
RUN wget -O /usr/local/bin/go-crond https://github.com/webdevops/go-crond/releases/download/$GOCROND_VERSION/go-crond-64-linux &&\
    chmod +x /usr/local/bin/go-crond

#create backup folder and give user access
RUN mkdir /backups
RUN chown -R wp-backup:wp-backup /backups &&\
    chown -R wp-backup:wp-backup /usr/local/bin &&\
    chmod +rwx /usr/local/bin
    
ENV MYSQL_ENV_MYSQL_HOST mysql-db
ENV BACKUP_TIME "0 3 * * *"

# copy in and allow execute of scripts
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY backup restore /usr/local/bin/
RUN chmod +x /usr/local/bin/backup &&\
    chmod +x /usr/local/bin/restore

### Setup user for build execution and application runtime
ENV APP_ROOT=/usr/local
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

USER 999
WORKDIR ${APP_ROOT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
VOLUME /backups

CMD ["go-crond"]
