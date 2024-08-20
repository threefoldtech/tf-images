FROM ubuntu

RUN apt update
RUN apt -y install wget openssh-server
RUN apt -y install gnupg

RUN wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

RUN echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

RUN apt-get update
RUN apt -y install jenkins

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && chmod +x /sbin/zinit
COPY rootfs /

EXPOSE 8080
ENTRYPOINT [ "/sbin/zinit", "init" ]
