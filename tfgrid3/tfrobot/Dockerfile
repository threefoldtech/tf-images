FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget software-properties-common curl openssh-server ufw

# Download and install latest zinit
RUN curl -s https://api.github.com/repos/threefoldtech/zinit/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    wget -qi - -O /sbin/zinit
    
RUN chmod +x /sbin/zinit
COPY scripts/ufw.sh /usr/local/bin/
COPY scripts/tfrobot.sh /usr/local/bin/

# Adding zinit config files
ADD zinit  /etc/zinit/    

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Starting Command
CMD ["/sbin/zinit", "init", "--container"]
