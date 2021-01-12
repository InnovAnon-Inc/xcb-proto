FROM innovanon/xorg-base:latest as builder-01
COPY --from=innovanon/util-macros /tmp/util-macros.txz /tmp/
COPY --from=innovanon/xorgproto   /tmp/xorgproto.txz   /tmp/
COPY --from=innovanon/libxau      /tmp/libXau.txz      /tmp/
COPY --from=innovanon/libxdmcp    /tmp/libXdmcp.txz    /tmp/
RUN cat   /tmp/*.txz  \
  | tar Jxf - -i -C / \
 && rm -v /tmp/*.txz

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
 && tar acf        ../xcbproto.txz .                                                       \
 && cd ..                                                                                  \
 && rm -rf       /tmp/xcbproto

