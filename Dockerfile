FROM openshift/base-centos7
MAINTAINER leo.lou@gov.bc.ca

#RUN rm -rf /usr/lib/node_modules && rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*} && \
#    curl -sL https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install -y epel-release nodejs npm
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="gdal" && \
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
