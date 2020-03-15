FROM arm32v7/ubuntu

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y install curl wget \
  && apt-get -qq -y install openjdk-11-jdk \
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
  && wget -q -O "${ES_HOME}\${ES_PACKAGE}" https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} \
  && echo "Install ${ES_PACKAGE} to ${ES_HOME}" \
  && dpkg -i --force-all --ignore-depends=lib6c ${ES_HOME}\${ES_PACKAGE} \
  && set -x

RUN set +x \
  && echo "vm.max_map_count=262144" >> /etc/sysctl.conf

#TODO: Fix dpkg status /var/lib/dpkg/status
#Status: install ok installed
#Depends: bash (>= 4.1), lsb-base (>= 4), adduser, coreutils (>= 8.4)

COPY ./elasticsearch.yml /etc/elasticsearch/

COPY ./jvm.options /etc/elasticsearch/

COPY ./elasticsearch /etc/default/

COPY ./99-docker.conf /etc/sysctl.d/

RUN sysctl -w vm.max_map_count=262144

EXPOSE 9200

VOLUME /var/lib/elasticsearch

CMD [ "service elasticsearch start" ]

CMD ["/bin/bash"]
