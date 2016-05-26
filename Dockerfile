# Docker image for forked primary national map application server from australia gov
FROM node:onbuild
MAINTAINER leo.lou@gov.bc.ca

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    gdal-bin \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g gulp \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \  
  && rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /usr/src/app
RUN npm install
RUN gulp lint

RUN useradd -ms /bin/bash tmap \
  && chown -R tmap:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER tmap
WORKDIR /usr/src/app
EXPOSE 3001
CMD npm start && gulp watch
