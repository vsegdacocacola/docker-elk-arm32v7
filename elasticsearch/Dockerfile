FROM arm32v7/ubuntu

RUN set +x \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install curl wget -y \
  && apt-get install openjdk-11-jdk -y \
  && apt clean \
  && set -x 

ENV ELK_VERSION=7.6.1

ENV \
  ES_VERSION=${ELK_VERSION} \
  ES_HOME=/usr/share/elasticsearch \
  JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf \
  ES_PACKAGE=elasticsearch-${ELK_VERSION}-no-jdk-amd64.deb

RUN set +x \
  && echo "Create ${ES_HOME}" \
  && mkdir -p ${ES_HOME} \
  && echo "Download from  https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} to ${ES_HOME}" \
  && wget -O "${ES_HOME}\${ES_PACKAGE}" https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} \
  && echo "Install ${ES_PACKAGE} to ${ES_HOME}" \
  && dpkg -i --force-all --ignore-depends=lib6c ${ES_HOME}\${ES_PACKAGE} \
  && set -x

#TODO: Fix dpkg status /var/lib/dpkg/status
#Status: install ok installed
#Depends: bash (>= 4.1), lsb-base (>= 4), adduser, coreutils (>= 8.4)

COPY ./elasticsearch.yml /etc/elasticsearch/

COPY ./jvm.options /etc/elasticsearch/

RUN set +x \
  && echo "Starting elasticsearch service" \
  && service elasticsearch start \
  && set -x


