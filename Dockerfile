FROM centos:7
MAINTAINER Maksim Podkorytov <max.podkorytoff@gmail.com>
RUN yum install -y gcc pcre-devel bzip2 file which tar wget make m4 patch yes
RUN wget http://download.camlcity.org/download/godi-rocketboost-20080630.tar.gz
RUN tar xvf godi-rocketboost-20080630.tar.gz
ENV GODI_HOME=/opt/godi
RUN mkdir $GODI_HOME
ENV PATH=$PATH:$GODI_HOME/bin:$GODI_HOME/sbin
WORKDIR godi-rocketboost-20080630
RUN yes | ./bootstrap -prefix $GODI_HOME
RUN ./bootstrap_stage2
RUN godi_console update
RUN godi_console perform -build godi-galax || true
WORKDIR $GODI_HOME/build/godi/godi-galax
COPY galax.patch .
RUN patch -p0 -i galax.patch
RUN godi_make && godi_make install
ENTRYPOINT ["/bin/bash", "-l", "-c"]
