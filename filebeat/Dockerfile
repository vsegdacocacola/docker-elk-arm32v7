FROM arm32v7/ubuntu

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y --no-install-recommends install gcc git make wget \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && set -x 

RUN set +x \
  && cd /root \
  && wget https://dl.google.com/go/go1.12.5.linux-arm64.tar.gz \
  && tar -xzf go1.12.5.linux-arm64.tar.gz \
  && mkdir go_projects \
  && set -x 

ENV \
  GOROOT=$HOME/go \
  PATH=$PATH:$GOROOT/bin \
  GOPATH=$HOME/go_projects \
  PATH=$GOPATH/bin:$PATH

RUN set +x \
  && echo -e "export GOROOT=$HOME/go" | tee -a ~/.profile \
  && echo -e "export PATH=$PATH:$GOROOT/bin" | tee -a ~/.profile \
  && echo -e "export GOPATH=$HOME/go_projects" | tee -a ~/.profile \
  && echo -e "export PATH=$PATH:$GOPATH/bin" | tee -a ~/.profile \
  && set -x 

RUN set +x \
  && go get github.com/elastic/beats \
  && cd $GOPATH/src/github.com/elastic/beats \
  && git fetch \
  && git checkout 03b3db2 \
  && set -x 

CMD "tail -f /dev/null"