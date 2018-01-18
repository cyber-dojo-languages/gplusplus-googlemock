FROM  cyberdojofoundation/gplusplus:7.2
LABEL maintainer=estermann.michel@gmail.com

ADD install.sh /

RUN /install.sh \
  && rm -f /install.sh

COPY red_amber_green.rb /usr/local/bin
