FROM centos
RUN set -ex; \
 yum install -y epel-release; \
 yum install -y make gcc m4 pcre-static bzip2 git texlive texlive-comment texlive-preprint hevea
WORKDIR /opt/src
RUN set -ex; \
 curl -L http://caml.inria.fr/pub/distrib/ocaml-3.10/ocaml-3.10.2.tar.gz | tar xz; \
 curl -L http://download.camlcity.org/download/findlib-1.1.2pl1.tar.gz | tar xz; \
 git clone https://github.com/mmottl/pcre-ocaml.git; \
 curl -L http://caml.inria.fr/pub/old_caml_site/distrib/bazar-ocaml/camlidl-1.05.tar.gz | tar xz; \
 curl -L http://prdownloads.sourceforge.net/camomile/camomile-0.7.1.tar.bz2 | tar xj; \
 curl -L https://sourceforge.net/projects/ocamlnet/files/ocamlnet/2.2.8.1/ocamlnet-2.2.8.1.tar.gz/download | tar xz; \
 curl -L http://www.ocaml-programming.de/packages/pxp-1.2.0test1.tar.gz | tar xz; \
 curl -L http://sourceforge.net/projects/galax/files/galax-1.0.1-src.tar.gz/download | tar xz
WORKDIR /opt/src/ocaml-3.10.2
RUN set -ex; \
 ./configure -prefix /opt/ocaml ; \
 make world; \
 make opt; \
 make install; \
 make clean
ENV PATH="/opt/ocaml/bin:${PATH}"
WORKDIR /opt/src/findlib-1.1.2pl1 
RUN set -ex; \
 ./configure ; \
 make all; \
 make opt; \
 make install; \
 make clean
WORKDIR /opt/src/pcre-ocaml
RUN set -ex; \
 git fetch --tags; \
 git checkout v5.15.0; \
 make; \
 make install; \
 make clean
WORKDIR /opt/src/camlidl-1.05
RUN set -ex; \
 cp config/Makefile.unix config/Makefile; \
 sed -i 's:\(^OCAMLLIB=\).*:\1/opt/ocaml/lib/ocaml:' config/Makefile; \
 sed -i 's:\(^BINDIR=\).*:\1/opt/ocaml/bin:' config/Makefile; \
 make all; \
 make install; \
 make clean
WORKDIR /opt/src/camomile-0.7.1
RUN set -ex; \
 mkdir /opt/bin; \
 ./configure -prefix /opt; \
 make; \
 make install; \
 make clean
WORKDIR /opt/src/ocamlnet-2.2.8.1
RUN set -ex; \
 ./configure ; \
 sed -i 's:\(^OCAMLC_OPTIONS\).*:\1 = -ccopt -D_GNU_SOURCE:' Makefile.conf; \
 make all; \
 make opt; \
 make install; \
 make clean
WORKDIR /opt/src/pxp-1.2.0test1
RUN set -ex; \
 ./configure ; \
 make all; \
 make opt; \
 make install; \
 make clean
WORKDIR /opt/src/galax-1.0.1-src
RUN set -ex; \
 sed -i 's:3.11:3.10:' configure; \
 ./configure -galax-home /opt/galax; \
 sed -i '126s:^\s:\t:' tools/escaping/Makefile; \
 sed -i '114s:^\s:\t:' tools/ucs2_to_utf8/Makefile; \
 make -k 2>make-error.log || true; \
 make 2>make2-error.log; \
 make install 2>make3-error.log; \
 
FROM centos:7
COPY --from=0 /opt /opt
