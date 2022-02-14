################## BASE IMAGE ######################
FROM ubuntu:latest

################## METADATA ######################
LABEL base_image="biocontainers:v1.0.0_cv4"
LABEL version="2"
LABEL software="KAST"
LABEL software.version="1.0.0"
LABEL about.summary="Perform Alignment-free k-tuple frequency comparisons from sequences."
LABEL about.home="https://github.com/martinjvickers/KAST"
LABEL about.documentation="https://github.com/martinjvickers/KAST"
LABEL about.license_file="https://github.com/martinjvickers/KAST"
LABEL about.license="MIT"
LABEL extra.identifiers.biotools="KAST"
LABEL about.tags="Genomics"

################## MAINTAINER ######################
MAINTAINER Martin Vickers <martinj.vickers@gmail.com>

################## INSTALLATION ######################

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata git g++ build-essential cmake zlib1g-dev libbz2-dev libboost-all-dev
RUN git clone https://github.com/seqan/seqan.git seqan
RUN git clone https://github.com/martinjvickers/KAST.git
RUN cd KAST
RUN cmake ../KAST -DCMAKE_MODULE_PATH=../seqan/util/cmake -DSEQAN_INCLUDE_PATH=../seqan/include -DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_BUILD_TYPE=Release
RUN make
RUN mv kast /usr/local/bin

WORKDIR /data/

CMD ["kast"]
