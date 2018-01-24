FROM centos:7
MAINTAINER twm <vnaga6810@gmail.com>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs upgrade && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum -y --setopt=tsflags=nodocs install unzip && \
    yum clean all

RUN mkdir -p /DT/doc_root/dotcom_web/

COPY  _ui.zip /DT/doc_root/dotcom_web/

RUN  cd /DT/doc_root/dotcom_web/ && unzip _ui.zip && rm -rf _ui.zip

RUN cd /etc/httpd/ && rm -rf conf conf.d conf.modules.d

#cd /etc/httpd/ && rm -rf conf conf.d conf.modules.d
COPY httpd.zip /opt/

RUN  cd /opt/ && unzip httpd.zip

RUN  cd /opt/httpd/ && mv conf conf.d conf.modules.d /etc/httpd/

RUN mkdir -p /apps/apache-http-server/logs/

EXPOSE 80

EXPOSE 443

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
