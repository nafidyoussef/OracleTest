FROM oraclelinux:latest
USER root

# Install haproxy and apache
RUN yum -y install httpd 
RUN yum -y install haproxy \
  && rm -rf /var/cache/yum/*

# add self-signed certificat
ADD mycerts/ /etc/ssl/certs/mycerts/
ADD conf/haproxy.cfg /tmp

RUN cat /tmp/haproxy.cfg > /etc/haproxy/haproxy.cfg
RUN /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg

RUN [ -d /var/log/httpd ] || mkdir /var/log/httpd
RUN [ -d /var/run/httpd ] || mkdir /var/run/httpd
RUN [ -d /var/lock/httpd ] || mkdir /var/lock/httpd

ADD Breakout/ /var/www/html/Breakout

EXPOSE 80 443

COPY scripts/ /scripts

CMD sh /scripts/services-wrapper.sh
