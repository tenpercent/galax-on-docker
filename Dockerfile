FROM busybox:glibc
COPY --from=tenpercent/galax-on-docker:1.0.1.sf \
 /opt/galax/bin/galax-run \
 /opt/galax/bin/galax-run.opt \
 /opt/galax/bin/
COPY --from=tenpercent/galax-on-docker:1.0.1.sf \
 /lib64/libm.so.6 \
 /lib64/libdl.so.2 \
 /lib64/libpthread.so.0 \
 /lib64/libc.so.6 \
 /lib64/ld-linux-x86-64.so.2 \
 /lib64/librt.so.1 \
 /lib64/libpcre.so.1 \
 /lib64/
ARG CDB=/opt/share/camomile/database
COPY --from=tenpercent/galax-on-docker:1.0.1.sf \
 $CDB/general_category.mar \
 $CDB/scripts.mar \
 $CDB/combined_class.mar \
 $CDB/decomposition.mar \
 $CDB/composition_exclusion.mar \
 $CDB/composition.mar \
 $CDB/
RUN set -ex; \
 ln -s /opt/galax/bin/galax-run /bin/galax; \
 echo "<doc><li>Hello</li><li>Galax</li></doc>" > test.xml; \
 echo "//li/data()" > test.xq; \
 galax -context-item test.xml test.xq
