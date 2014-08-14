FROM ubuntu:14.04
MAINTAINER Michaël Faille <michael.faille@nuagebec.ca> 

# Install packages
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen supervisor git curl tar vim-nox vim-syntax-go && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#https://github.com/docker/docker/issues/6103
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /data/run.sh

ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

RUN chmod a+x /data/*.sh

EXPOSE 22
CMD ["/data/run.sh"]