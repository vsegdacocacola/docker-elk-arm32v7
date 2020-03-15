FROM arm32v7/ubuntu

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y install curl wget xz-utils \
  && apt-get -qq -y install openjdk-11-jdk \
  && apt clean \
  && set -x 

ENV ELK_VERSION=7.6.1

ENV \
  KIBANA_HOME=/usr/share/kibana \
  KIBANA_PACKAGE=kibana-${ELK_VERSION}-amd64.deb

RUN set +x \
  && echo "Create ${KIBANA_HOME}" \
  && mkdir -p ${KIBANA_HOME} \
  && echo "Download from  https://artifacts.elastic.co/downloads/kibana/${KIBANA_PACKAGE} to ${KIBANA_HOME}" \
  && wget -q -O "${KIBANA_HOME}\${KIBANA_PACKAGE}" https://artifacts.elastic.co/downloads/kibana/${KIBANA_PACKAGE} \
  && echo "Install ${KIBANA_PACKAGE} to ${KIBANA_HOME}" \
  && dpkg -i --force-all --ignore-depends=lib6c ${ES_HOME}\${ES_PACKAGE} \
  && set -x

ADD ./kibana.yml ${KIBANA_HOME}/config/kibana.yml

RUN cd /root && curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-armv7l.tar.xz && tar -xvf node-v12.16.1-linux-armv7l.tar.xz
ADD ./kibana.sh ${KIBANA_HOME}/bin/kibana
RUN chmod a+x ${KIBANA_HOME}/bin/kibana

EXPOSE 5601