FROM ubuntu:18.04
LABEL MAINTAINER=lucian.neghina@esolutions.ro

ENV CM_MAJOR_VERSION=6 \
    CM_MINOR_VERSION=3 \
    CM_PATCH_VERSION=1

ENV DEBIAN_FRONTEND noninteractive

ENV CM_VERSION=${CM_MAJOR_VERSION}.${CM_MINOR_VERSION}.${CM_PATCH_VERSION}
ENV CLOUDERA_BASE_URL=https://archive.cloudera.com/cm${CM_MAJOR_VERSION}/${CM_VERSION}/ubuntu1804/apt/

# Install Java8(OpenJDK), MySQL and configure Cloudera Repo
RUN apt-get update &&\
    apt-get install --quiet --no-install-recommends --yes \
    	sudo \
        wget \
        gnupg2 \
        ntp \ 
        net-tools \
        less \
        ca-certificates \
        openjdk-8-jdk \
        mysql-server \
        openssh-server \
        libmysql-java &&\
    wget -q ${CLOUDERA_BASE_URL}/cloudera-manager.list -P /etc/apt/sources.list.d &&\
    wget -q ${CLOUDERA_BASE_URL}/archive.key -O - | apt-key add - &&\ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install cloudera-manager-{server,daemons,agent}
RUN apt-get update &&\
    apt-get install -y oracle-j2sdk1.8 &&\
    apt-get install --yes cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH access
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 

COPY ./sql.sql /sql.sql
COPY ./mysqld_cloudera.cnf /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN service mysql stop && \ 
	chmod 644 /etc/mysql/mysql.conf.d/mysqld_cloudera.cnf && \ 
    update-rc.d mysql defaults && \
	service mysql start && \ 
	mysql < /sql.sql && \ 
	/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm scm && \
    wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /bin/systemctl && \
    chmod +x /bin/systemctl && \    
	chmod +x /docker-entrypoint.sh

EXPOSE 7180 7182

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start"]