FROM sagemath/sagemath

COPY ./src /src

WORKDIR /src

CMD pwd;sh run.sh
