FROM  cyberdojofoundation/gplusplus
LABEL maintainer=estermann.michel@gmail.com

COPY gmock-1.7.0.zip /usr/src

ADD install.sh /

RUN /install.sh \
  && rm -f /install.sh

COPY red_amber_green.rb /usr/local/bin
