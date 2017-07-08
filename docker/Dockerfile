FROM       cyberdojofoundation/gplusplus:7.1
MAINTAINER Michel Estermann <estermann.michel@gmail.com>

WORKDIR /usr/src

RUN apt-get update && apt-get install -y \
  wget \
  cmake \
  unzip

RUN wget http://pkgs.fedoraproject.org/repo/pkgs/gmock/gmock-1.7.0.zip/073b984d8798ea1594f5e44d85b20d66/gmock-1.7.0.zip
RUN unzip gmock-1.7.0.zip

RUN cd /usr/src/gmock-1.7.0 && cmake DCMAKE_CXX_FLAGS='-Wno-unused-local-typedefs' .
RUN cd /usr/src/gmock-1.7.0 && make
RUN cd /usr/src/gmock-1.7.0 && mv libg* /usr/lib && cp -rf include/gmock /usr/include
RUN cd /usr/src/gmock-1.7.0/gtest && mv libg* /usr/lib && cp -rf include/gtest /usr/include

COPY red_amber_green.rb /usr/local/bin
