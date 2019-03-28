FROM centos
MAINTAINER leo.lou@gov.bc.ca

RUN rm -rf /usr/lib/node_modules && rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*} && \
    curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y nodejs && \
    yum install -y centos-release-scl-rh epel-release && \
    INSTALL_PKGS="gdal git wget" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --enablerepo=epel && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN npm install -g gulp serve && \   
    git config --global url.https://github.com/.insteadOf git://github.com/ && \
    mkdir -p /opt/tmap && \
    git clone https://github.com/TerriaJS/TerriaMap.git /tmp/src && cp -r /tmp/src/* /opt/tmap && rm -rf /tmp/src && \
    wget -O /opt/tmap/wwwroot/init/terria.json https://raw.githubusercontent.com/ll911/TerriaMap/master/wwwroot/init/terria.json

WORKDIR /opt/tmap
RUN npm install && \
    npm run gulp release

RUN chown -R 1001:0 /opt/tmap && chmod -R ug+rwx /opt/tmap
USER 1001
EXPOSE 3001
CMD node node_modules/terriajs-server/lib/app.js --config-file devserverconfig.json
