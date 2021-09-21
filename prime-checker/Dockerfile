FROM sagemath/sagemath

COPY ./src /src

WORKDIR /src

RUN sudo apt-get update && sudo apt-get install -y \
    ca-certificates \
    curl \
    unzip \
 && sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && sudo unzip awscliv2.zip \
 && sudo ./aws/install -i /usr/local/aws-cli -b /usr/bin \
 && sudo chmod 777 /src/*

CMD pwd;ls -l;sh run.sh
