FROM ubuntu:bionic
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y nginx openssl software-properties-common openssh-server netcat&&\
    add-apt-repository -y ppa:certbot/certbot &&\
    apt-get update &&\
    apt-get -y install certbot python-certbot-nginx
RUN mkdir /config
COPY ["nginx-https.conf", "nginx.conf", "/config/"]
COPY ["startup.sh", "trc", "/usr/local/bin/"]
RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/trc
RUN  mkdir -p /root/.ssh/ &&\
     touch /root/.ssh/authorized_keys
