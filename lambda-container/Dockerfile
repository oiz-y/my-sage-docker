FROM sagemath/sagemath

WORKDIR /var/task

RUN sudo chmod 777 -R /home/sage/sage/local/var/lib/
RUN sudo chmod 777 /home/sage/sage/local/var
RUN sudo chmod 777 /home/sage/sage/local
RUN sudo chmod 777 /home/sage/sage
RUN sudo chmod 777 /home/sage
RUN sudo chmod 777 /home
RUN sudo chmod 777 /var/task
RUN mkdir /home/sage/.sage
RUN sudo chmod 777 /home/sage/.sage

RUN sudo apt-get update \
 && sudo apt-get install -y jq

COPY polynomial_factorization.sage ./polynomial_factorization.sage
COPY run.sh ./run.sh
COPY hello.py /tmp/hello.py
COPY ./sagebin/* /usr/local/bin/
COPY ./sagebin/* /home/sage/sage/src/bin/

CMD ["sh", "run.sh"]
