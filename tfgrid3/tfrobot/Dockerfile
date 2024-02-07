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

# Adding zinit config files
ADD zinit  /etc/zinit/    

# Install latest tfrobot
RUN tfrobot_version=$(curl -s https://api.github.com/repos/threefoldtech/tfgrid-sdk-go/releases/latest | grep 'tag_name' | cut -d '"' -f 4 ) && \
    wget "https://github.com/threefoldtech/tfgrid-sdk-go/releases/download/${tfrobot_version}/tfgrid-sdk-go_Linux_x86_64.tar.gz" && \
    tar -xzf tfgrid-sdk-go_Linux_x86_64.tar.gz -C /usr/local/bin/

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* tfgrid-sdk-go_Linux_x86_64.tar.gz

# Starting Command
CMD ["/sbin/zinit", "init", "--container"]
