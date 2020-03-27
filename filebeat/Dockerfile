FROM golang:latest

ENV \
  ELK_VERSION=7.6.1

RUN set +x \
  && go get github.com/elastic/beats \
  && cd /go/src/github.com/elastic/beats/filebeat/ \
  && git checkout "v${ELK_VERSION}" \
  && GOARCH=arm go build \
  && set -x

RUN set +x \
  && wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ELK_VERSION}-amd64.deb \
  && dpkg -i --force-all filebeat-${ELK_VERSION}-amd64.deb \
  && cp -r ./filebeat /usr/share/filebeat/bin/ \
  && set -x

RUN set +x \
  && git get github.com/sevlyar/go-daemon \
  && cd ./go-daemon \
  && cp src/god.c ./ \
  && make \
  && make install \
  && set -x

CMD "tail -f /dev/null"