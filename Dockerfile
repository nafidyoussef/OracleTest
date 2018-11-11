FROM oraclelinux:latest
USER root

# Install haproxy and apache
RUN yum -y install httpd 
RUN yum -y install haproxy \
  && rm -rf /var/cache/yum/*

RUN [ -d /var/log/httpd ] || mkdir /var/log/httpd
RUN [ -d /var/run/httpd ] || mkdir /var/run/httpd
RUN [ -d /var/lock/httpd ] || mkdir /var/lock/httpd

# add self-signed certificat
ADD mycerts/ /etc/ssl/certs/mycerts/
ADD conf/haproxy.cfg /tmp/haproxy.cfg

RUN cat /tmp/haproxy.cfg > /etc/haproxy/haproxy.cfg
ADD Breakout/ /var/www/html/Breakout
ADD conf/vhost.conf /etc/httpd/conf.d/

EXPOSE 80 443

COPY scripts/ /scripts

CMD sh /scripts/services-wrapper.sh
