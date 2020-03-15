# Dockerfile for ELK stack
# Elasticsearch

# Build with:
# docker build -t <repo-user>/elasticsearch .

# Run with:
# docker run -p 9200:9200 -it --name elk <repo-user>/elasticsearch

FROM arm32v7/ubuntu
MAINTAINER vsegdacocacola
ENV \
 REFRESHED_AT=2020-03-15


###############################################################################
#                                INSTALLATION
###############################################################################

### install prerequisites (cURL, gosu, JDK, tzdata)

RUN set -x \
 && apt update -qq \
 && apt install -qqy --no-install-recommends ca-certificates curl gosu tzdata openjdk-8-jdk cron libjna-java vim wget \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && gosu nobody true \
 && set +x

### install Elasticsearch
ARG ELK_VERSION=7.6.1
ENV \
 ES_VERSION=${ELK_VERSION} \
 ES_HOME=/opt/elasticsearch \
 LOGSTASH_VERSION=${ELK_VERSION} \
 LOGSTASH_HOME=/opt/logstash

# note you can't define an env var that references another one in the same block (docker layer)
ENV \
 JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf/jre \
 ES_PACKAGE=elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
 ES_GID=991 \
 ES_UID=991 \
 ES_PATH_CONF=/etc/elasticsearch \
 ES_PATH_BACKUP=/var/backups \
 KIBANA_VERSION=${ELK_VERSION}
RUN echo "${ELK_VERSION} ${ES_VERSION} https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} to ${ES_HOME}"
RUN DEBIAN_FRONTEND=noninteractive \
 && mkdir -p ${ES_HOME}/tmp \
 && curl -O https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} \
 && tar xzf ${ES_PACKAGE} -C ${ES_HOME} --strip-components=1 \
 && rm -f ${ES_PACKAGE} \
 && groupadd -r elasticsearch -g ${ES_GID} \
 && useradd -r -s /usr/sbin/nologin -M -c "Elasticsearch service user" -u ${ES_UID} -g elasticsearch elasticsearch \
 && mkdir -p /var/log/elasticsearch ${ES_PATH_CONF} ${ES_PATH_CONF}/scripts /var/lib/elasticsearch ${ES_PATH_BACKUP} \
 && chown -R elasticsearch:elasticsearch ${ES_HOME} /var/log/elasticsearch /var/lib/elasticsearch ${ES_PATH_CONF} ${ES_PATH_BACKUP}

###############################################################################
#                              START-UP SCRIPTS
###############################################################################

### Elasticsearch

ADD ./elasticsearch-init /etc/init.d/elasticsearch
RUN sed -i -e 's#^ES_HOME=$#ES_HOME='$ES_HOME'#' /etc/init.d/elasticsearch \
 && chmod +x /etc/init.d/elasticsearch

###############################################################################
#                               CONFIGURATION
###############################################################################

### configure Elasticsearch
ADD ./elasticsearch.yml ${ES_PATH_CONF}/elasticsearch.yml
ADD ./elasticsearch-default /etc/default/elasticsearch
RUN cp ${ES_HOME}/config/log4j2.properties ${ES_HOME}/config/jvm.options \
    ${ES_PATH_CONF} \
 && chown -R elasticsearch:elasticsearch ${ES_PATH_CONF} \
 && chmod -R +r ${ES_PATH_CONF}


### ARM workaround
#### jna things
RUN mkdir -p /opt/elasticsearch/lib/tmp
RUN cp /opt/elasticsearch/lib/jna-4.5.1.jar /opt/elasticsearch/lib/tmp/jna-4.5.1.jar
RUN cd /opt/elasticsearch/lib/tmp && jar xf jna-4.5.1.jar
RUN cd /opt/elasticsearch/lib/tmp && rm -f jna-4.5.1.jar
RUN mkdir -p /opt/elasticsearch/lib/tmp/com/sun/jna/linux-arm
RUN cp /usr/lib/arm-linux-gnueabihf/jni/libjnidispatch.system.so /opt/elasticsearch/lib/tmp/com/sun/jna/linux-arm/libjnidispatch.so
RUN cd /opt/elasticsearch/lib/tmp && jar cf ../jna-4.5.1.jar *
RUN rm -rf /opt/elasticsearch/lib/tmp

###############################################################################
#                                   START
###############################################################################

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 9200
VOLUME /var/lib/elasticsearch

CMD [ "/usr/local/bin/start.sh" ]