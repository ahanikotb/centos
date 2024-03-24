FROM dokken/centos-stream-8

# Install required packages and set locale
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y openssh-server wget unzip glibc-langpack-en glibc-locale-source && \
    localedef --no-archive -i en_US -f UTF-8 en_US.UTF-8

# Set environment variables
ENV LANG en_US.UTF-8

# Set arguments and environment variables
ARG ngrokid
ARG Password
ENV Password=${Password}
ENV ngrokid=${ngrokid}

# Download ngrok and configure SSH
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    echo "./ngrok config add-authtoken ${ngrokid}" >> /1.sh && \
    echo "./ngrok tcp 22 &>/dev/null &" >> /1.sh && \
    mkdir /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo root:${Password} | chpasswd && \
    ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:${Password}" | chpasswd && \
    mkdir -p /var/run/sshd && \
    chmod 755 /1.sh
    
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD ["/usr/sbin/sshd", "-D"]
