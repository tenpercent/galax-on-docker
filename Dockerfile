FROM centos:7
RUN set -ex; \
yum install -y gcc pcre-devel bzip2 file which tar wget make m4 patch yes; \
curl http://download.camlcity.org/download/godi-rocketboost-20080630.tar.gz | tar -xz
ENV GODI_HOME=/opt/godi
ENV PATH=$PATH:$GODI_HOME/bin:$GODI_HOME/sbin
WORKDIR godi-rocketboost-20080630
RUN set -ex; \
mkdir $GODI_HOME; \
yes | ./bootstrap -prefix $GODI_HOME; \
./bootstrap_stage2; \
godi_console update; \
godi_console perform -build godi-galax || true
WORKDIR $GODI_HOME/build/godi/godi-galax
COPY galax.patch .
RUN set -ex; \
patch -p0 -i galax.patch; \
godi_make && godi_make install
