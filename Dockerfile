FROM innovanon/xorg-base:latest as builder-01
COPY --from=innovanon/util-macros /tmp/util-macros.txz /tmp/
COPY --from=innovanon/xorgproto   /tmp/xorgproto.txz   /tmp/
COPY --from=innovanon/libxau      /tmp/libXau.txz      /tmp/
COPY --from=innovanon/libxdmcp    /tmp/libXdmcp.txz    /tmp/
RUN extract.sh

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
RUN sleep 31                                                                               \
 && git clone --depth=1 --recursive https://gitlab.freedesktop.org/xorg/proto/xcbproto.git \
 && cd                                                                        xcbproto     \
 && ./autogen.sh                                                                           \
 && ./configure $XORG_CONFIG                                                               \
 && make DESTDIR=/tmp/xcbproto install                                                     \
 && rm -rf                                                                    xcbproto     \
 && cd           /tmp/xcbproto                                                             \
 && strip.sh .                                                                             \
 && tar acf        ../xcbproto.txz .                                                       \
 && cd ..                                                                                  \
 && rm -rf       /tmp/xcbproto

FROM scratch as final
COPY --from=builder-01 /tmp/xcbproto.txz /tmp/

