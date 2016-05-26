# Docker image for forked primary national map application server from australia gov
FROM node:0.10-onbuild
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
RUN npm start
RUN gulp watch

RUN useradd -ms /bin/bash terriamp \
  && chown -R terriamp:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER terriamp
WORKDIR /usr/src/app
EXPOSE 3001
CMD npm start
