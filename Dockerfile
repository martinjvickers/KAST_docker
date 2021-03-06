################## BASE IMAGE ######################
FROM ubuntu:latest

################## METADATA ######################
LABEL base_image="ubuntu:latest"
LABEL version="1"
LABEL software="KAST"
LABEL software.version="1.0.0"
LABEL about.summary="Perform Alignment-free k-tuple frequency comparisons from sequences."
LABEL about.home="https://github.com/martinjvickers/KAST"
LABEL about.documentation="https://github.com/martinjvickers/KAST/wiki"
LABEL about.license_file="https://github.com/martinjvickers/KAST/LICENSE"
LABEL about.license="MIT"
LABEL extra.identifiers.biotools="KAST"
LABEL about.tags="Genomics"

################## MAINTAINER ######################
MAINTAINER Martin Vickers <martinj.vickers@gmail.com>

################## INSTALLATION ######################

ENV DEBIAN_FRONTEND noninteractive

## Update and install packages
RUN apt-get update -y && apt-get install -y tzdata git g++ build-essential cmake zlib1g-dev libbz2-dev libboost-all-dev wget git-lfs

## Temp directory
RUN mkdir /opt/software

## Download everything
RUN cd /opt/software && git clone https://github.com/seqan/seqan.git seqan && wget https://github.com/martinjvickers/KAST/archive/refs/tags/testing_0.0.34.tar.gz && git clone https://github.com/martinjvickers/KAST_figures.git

## Make kast
RUN cd /opt/software && tar xvfz testing_0.0.34.tar.gz && cd KAST-testing_0.0.34 && cmake ../KAST-testing_0.0.34 -DCMAKE_MODULE_PATH=../seqan/util/cmake -DSEQAN_INCLUDE_PATH=../seqan/include -DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_BUILD_TYPE=Release && make

## Install kast
RUN ln -s /opt/software/KAST-testing_0.0.34/kast /usr/local/bin/

## Extract scripts/data
RUN cd /opt/software/KAST_figures && ls -lath && tar xvfz dna-example-lite.tar.gz && tar xvfz aa-example-lite.tar.gz && tar xvfz Figures.tar.gz

WORKDIR /data/

CMD ["kast"]
