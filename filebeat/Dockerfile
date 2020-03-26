FROM arm32v7/ubuntu

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y --no-install-recommends install gcc git make wget ca-certificates apt-transport-https golang \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && set -x 

CMD "tail -f /dev/null"