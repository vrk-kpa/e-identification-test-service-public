# Pull base image
FROM e-identification-docker-virtual.vrk-artifactory-01.eden.csc.fi/e-identification-tomcat-apache2-shibd-sp-base-image
COPY target/site /site

COPY conf/shibboleth/attribute-map.xml /etc/shibboleth/attribute-map.xml
RUN mkdir -p /etc/shibboleth/idp-metadata
RUN mkdir -p /opt/tomcat/logs
RUN chown -R tomcat:tomcat /opt/tomcat
RUN mkdir -p /opt/templates
COPY target/kapa-service-provider.war /opt/service-provider/
COPY conf/tomcat/sp.xml /usr/share/tomcat/conf/Catalina/localhost/
WORKDIR /opt/service-provider
RUN jar -xvf kapa-service-provider.war
COPY conf/tomcat/server.xml /usr/share/tomcat/conf/
COPY conf/tomcat/logging.properties /usr/share/tomcat/conf/logging.properties
COPY conf/apache/envvars /etc/apache2/envvars
COPY conf/shibboleth/shibd.logger /etc/shibboleth/shibd.logger
COPY html/dist /var/www/dist

# Templates
COPY conf/shibboleth/shibboleth2.xml.template /data00/templates/store/
COPY conf/apache/default-ssl.conf.template /data00/templates/store/
COPY conf/tomcat/service-provider.properties.template /data00/templates/store/
COPY conf/shibboleth/sp-setenv.sh.template /data00/templates/store/
COPY conf/logging/log4j.properties.template /data00/templates/store/
COPY conf/ansible /data00/templates/store/ansible
COPY conf/dist/* /data00/templates/store/

RUN \
    chown -R tomcat:tomcat /opt/service-provider && \
    chown -R tomcat:tomcat /usr/share/tomcat && \
    chown -R _shibd:_shibd /etc/shibboleth/idp-metadata/

RUN rm -fr /usr/share/tomcat/webapps/* && \
    rm -fr /usr/share/tomcat/server/webapps/* && \
    rm -fr /usr/share/tomcat/conf/Catalina/localhost/host-manager.xml && \
    rm -fr /usr/share/tomcat/conf/Catalina/localhost/manager.xml

RUN  ln -sf /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
RUN  ln -sf /data00/deploy/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

RUN mkdir -p /opt/service-provider-properties/
RUN mkdir -p /usr/share/tomcat/properties

RUN ln -sf /data00/deploy/service-provider.properties /opt/service-provider-properties/service-provider.properties
RUN ln -sf /data00/deploy/shibboleth2.xml /etc/shibboleth/shibboleth2.xml
RUN ln -sf /data00/deploy/sp-setenv.sh /usr/share/tomcat/bin/setenv.sh
RUN ln -sf /data00/deploy/kapa-ca /opt/kapa-ca
RUN ln -sf /data00/deploy/tomcat_keystore /usr/share/tomcat/properties/tomcat_keystore
RUN ln -sf /data00/deploy/index.html /var/www/index.html
RUN ln -sf /data00/deploy/uloskirjautunut.html /var/www/uloskirjautunut.html
RUN ln -sf /data00/deploy/virhe.html /var/www/virhe.html

CMD \
    mkdir -p /data00/logs && \
    chown -R tomcat:tomcat /data00/deploy && \
    chmod -R 777 /data00/logs && \
    ln -sf /data00/deploy/sp_metadata/* /etc/shibboleth/ && \
    ln -sf /data00/deploy/service-idp-metadata.xml /etc/shibboleth/idp-metadata/ && \
    cp -pf /data00/deploy/tunnistautunut.ftlh /opt/templates/tunnistautunut.ftlh && \
    service apache2 restart && service shibd restart && \
    service tomcat restart && tail -f /etc/hosts
