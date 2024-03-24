FROM dokken/centos-stream-8

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y  openssh-server wget unzip \
    yum install -y glibc-locale-source \
    localedef --no-archive -i en_US -f UTF-8 en_US.UTF-8
    
ENV LANG en_US.utf8
ARG ngrokid
ARG Password
ENV Password=${Password}
ENV ngrokid=${ngrokid}
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    echo "./ngrok config add-authtoken ${ngrokid} &&" >> /1.sh && \
    echo "./ngrok tcp 22 &>/dev/null &" >> /1.sh && \
    mkdir /run/sshd && \
    echo '/usr/sbin/sshd -D' >> /1.sh && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo root:${Password} | chpasswd && \
    systemctl enable sshd
RUN chmod 755 /1.sh
