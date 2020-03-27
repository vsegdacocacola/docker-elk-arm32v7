FROM golang:latest

ENV \
  ELK_VERSION=7.6.1 \
  GOARCH=arm

RUN \
  echo "Go get github.com/elastic/beats" \
  && go get github.com/elastic/beats; exit 0 \
  && cd /go/src/github.com/elastic/beats/filebeat/ \
  && echo "git checkout v${ELK_VERSION}" \
  && git checkout "v${ELK_VERSION}" \
  && echo "git build" \
  && GOARCH=arm go build \
  && echo "build done" 

RUN \
  wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ELK_VERSION}-amd64.deb \
  && dpkg -i --force-all filebeat-${ELK_VERSION}-amd64.deb 
#  && cp -r /go/src/github.com/elastic/beats/filebeat/filebeat /usr/share/filebeat/bin/ \

 RUN \
   git clone https://github.com/tsg/go-daemon.git \
   && cd go-daemon \
   && cp src/god.c ./ \
   && make \
   && make install

CMD "/bin/bash"