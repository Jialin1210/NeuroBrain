FROM nvidia/cuda:11.5.0-devel-ubuntu20.04

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get clean && apt-get update
RUN apt-get install -yqq python3 python3-pip python3-dev build-essential \
    python3-setuptools python3-numpy python3-scipy \
    libatlas-base-dev \
    git wget gfortran libatlas-base-dev libatlas3-base libhdf5-dev \
    libfreetype6-dev libpng-dev pkg-config libxml2-dev libxslt-dev \
    libboost-program-options-dev zlib1g-dev libboost-python-dev

ADD scripts /scripts

# RUN pip3 install -U numpy
RUN pip3 install --upgrade pip
COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip3 install -U -r /tmp/requirements.txt

EXPOSE 8888
VOLUME ["/notebook", "/scripts"]
WORKDIR /scripts

ADD test_scripts /test_scripts
COPY .theanorc /root/.theanorc
ADD jupyter /jupyter
ENV JUPYTER_CONFIG_DIR="/jupyter"

CMD ["jupyter", "notebook", "--ip=localhost"]
