FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y wget software-properties-common curl ssh ufw

# Download and install latest zinit
RUN wget --progress=bar:force:noscroll -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit && \
    chmod +x /sbin/zinit
    
COPY scripts/ufw.sh /usr/local/bin/
COPY scripts/ssh-init.sh /usr/local/bin/

# Adding zinit config files
ADD zinit  /etc/zinit/    

# Download and install latest Bitcoin Core latest verson
RUN latest_release=$(curl -s https://api.github.com/repos/bitcoin/bitcoin/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | sed 's/^v//') && \
    wget https://bitcoincore.org/bin/bitcoin-core-${latest_release}/bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${latest_release}/bin/*

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  bitcoin-*

# Copy the bitcoin.conf file to the container
COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

# Starting Command to run Bitcoind and ssh 
RUN chmod +x /sbin/zinit && chmod +x /usr/local/bin/ufw.sh && chmod +x /usr/local/bin/ssh-init.sh
CMD ["/sbin/zinit", "init", "--container"]
#ENTRYPOINT  ["zinit", "init"]
