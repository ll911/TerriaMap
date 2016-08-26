FROM openshift/base-centos7
MAINTAINER leo.lou@gov.bc.ca

RUN curl -sL https://rpm.nodesource.com/setup_6.x | bash -
ENV NODEJS_VERSION=6

LABEL summary="Platform for building and running Node.js 6 applications" \
      io.k8s.description="Platform for building and running Node.js 6 applications" \
      io.k8s.display-name="Node.js 6" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs4" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="gdal nodejs npm" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --enablerepo=epel && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

ADD . /opt/app-root
RUN git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g gulp serve
RUN npm install
RUN gulp

WORKDIR /opt/app-root
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER 1001
EXPOSE 8080
CMD npm start
