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

RUN /home/sage/sage/local/var/lib/sage/venv-python3.10.5/bin/pip3 install boto3

COPY polynomial_factorization.sage ./polynomial_factorization.sage
COPY hello.sage ./hello.sage
COPY utils.py ./utils.py
COPY dynamodb_operation.py ./dynamodb_operation.py
COPY run.sh ./run.sh
COPY ./sagebin/* /usr/local/bin/
COPY ./sagebin/* /home/sage/sage/src/bin/

CMD ["sh", "run.sh"]
