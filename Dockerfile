FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y build-essential git libopencv-dev && \
    apt-get install -y libgomp1 wget unzip && \
    apt-get install -y --no-install-recommends python3-pip && \
    apt-get install -y python3-setuptools && \
    pip3 install --no-cache-dir wheel && \
    rm -rf /var/lib/apt/lists

# Compile with cuda support
ARG cuda=1
# Compile with tensor core support
ARG cuda_tc=0
# Build shared library libdarknet.so for python bindings
ARG libso=1

# Compile darknet
WORKDIR /container
RUN git clone -n https://github.com/AlexeyAB/darknet.git
WORKDIR /container/darknet
RUN git checkout ac8ebca0639f445ae456a1da05a13496ae0fcdc2

RUN sed -i -e "s!OPENMP=0!OPENMP=1!g" Makefile && \
    sed -i -e "s!OPENCV=0!OPENCV=1!g" Makefile && \
    sed -i -e "s!AVX=0!AVX=1!g" Makefile && \
    sed -i -e "s!LIBSO=0!LIBSO=${libso}!g" Makefile && \
    sed -i -e "s!GPU=0!GPU=${cuda}!g" Makefile && \
    sed -i -e "s!CUDNN=0!CUDNN=${cuda}!g" Makefile && \
    sed -i -e "s!CUDNN_HALF=0!CUDNN_HALF=${cuda_tc}!g" Makefile && \
    make

# CMD ["nvidia-smi"]

# Setup jupyterlab for testing
ENV PYTHONUNBUFFERED 1
COPY entrypoint.sh /usr/local/bin
COPY jupyter.requirements.txt jupyter.requirements.txt
RUN pip3 install --no-cache -r jupyter.requirements.txt

WORKDIR /container
ENV SHELL=/bin/bash
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]