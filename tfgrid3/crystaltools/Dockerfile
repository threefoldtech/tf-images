FROM ubuntu:22.04
# the commit that works in crystaltools, just in case someone broke the code again 448adb9f38e4dbbe34bf5c48e95f1ca376577201
ENV PBRANCH=development
ENV TERM=xterm
RUN apt update && \
  apt -y install curl wget git make build-essential sudo unzip vim libgc-dev
RUN wget 'https://github.com/vlang/v/releases/download/weekly.2022.16/v_linux.zip' && unzip v_linux.zip && cd v &&  sudo ./v symlink
RUN wget 'https://raw.githubusercontent.com/freeflowuniverse/crystaltools/development/install.sh'
RUN bash install.sh

