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
RUN yum -y update &&\
    yum -y install rsync &&\
    yum -y install wget mysql bzip2 -y &&\
    yum clean all

# install go-cron
ENV GOCROND_VERSION=0.6.0
RUN wget -O /usr/local/bin/go-crond https://github.com/webdevops/go-crond/releases/download/$GOCROND_VERSION/go-crond-64-linux &&\
    chmod +x /usr/local/bin/go-crond

# install oc client tools for assist in restore
# ENV OC_VERSION=openshift-origin-client-tools-v3.11.0-0731b2f-347-linux-64bit
# RUN wget -O /tmp/openshift.tar.gz https://artifacts-openshift-release-3-11.svc.ci.openshift.org/zips/${OC_VERSION}.tar.gz &&\
#     cd /tmp &&\
#     ls -lsa

# RUN tar -xvf /tmp/openshift.tar.gz -C /tmp

# RUN rm /tmp/openshift.tar.gz &&\
#     cp -rpv /tmp/${OC_VERSION}/* /usr/local/bin &&\
#     rm -R /tmp/${OC_VERSION}

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

USER 0
WORKDIR ${APP_ROOT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
VOLUME /backups

CMD ["go-crond"]
