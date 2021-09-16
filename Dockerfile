FROM sagemath/sagemath

COPY ./src /src

WORKDIR /src

RUN sudo chmod 777 /src/*

CMD pwd;ls -l;sh run.sh
