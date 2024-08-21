FROM ubuntu

RUN apt update
RUN apt -y install wget openssh-server

RUN wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
RUN echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

RUN apt-get update && apt-get -y install jenkins default-jre

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && chmod +x /sbin/zinit

COPY rootfs /

RUN mkdir -p /root/.jenkins/init.groovy.d
COPY /set-admin-user.groovy /root/.jenkins/init.groovy.d/set-admin-user.groovy

EXPOSE 9090

ENTRYPOINT [ "/sbin/zinit", "init" ]
