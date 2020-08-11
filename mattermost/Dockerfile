FROM mysql:5.7

RUN apt-get update && apt-get install -y ca-certificates openssh-server

RUN mkdir -p /root/.ssh/ &&\
    touch /root/.ssh/authorized_keys

# Configure Mattermost
WORKDIR /mm

# Copy over files
ADD https://releases.mattermost.com/5.24.2/mattermost-team-5.24.2-linux-amd64.tar.gz .
RUN tar -zxvf ./mattermost-team-5.24.2-linux-amd64.tar.gz
ADD config_docker.json ./mattermost/config/config_docker.json
ADD start_mattermost.sh .

RUN chmod +x ./start_mattermost.sh
ENTRYPOINT ./start_mattermost.sh

# Create default storage directory
RUN mkdir ./mattermost-data
VOLUME /mm/mattermost-data

# Ports
EXPOSE 8065
