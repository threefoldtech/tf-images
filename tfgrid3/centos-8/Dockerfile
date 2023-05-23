FROM centos:8
RUN yum install -y openssh-server && yum clean all

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN rm -f /run/nologin
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"">/etc/default/local

ENTRYPOINT ["/entrypoint.sh"]