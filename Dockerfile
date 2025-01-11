FROM debian:buster-slim AS builder

RUN apt-get update && apt-get install -y \
    ca-certificates \
    build-essential \
    libprotobuf-dev \
    protobuf-compiler \
    libstdc++6 \
	libgcc1 \
	zlib1g \
    curl \
    wget

COPY --chmod=755 hiddify-cli-linux-amd64.tar.gz /

RUN mkdir -p /root/hiddify && cd /root/hiddify && mv /hiddify-cli-linux-amd64.tar.gz /hiddify_linux.tar.gz \
    && mv /hiddify_linux.tar.gz /root/hiddify \
    && tar zxvf hiddify_linux.tar.gz && rm -rf hiddify_linux.tar.gz

RUN mkdir -p /tmp/libs/ && \
    cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /tmp/libs/


RUN mkdir -p /tmp/libs/


FROM busybox:stable-glibc


COPY --chmod=755 ./rootfs /
COPY --from=builder /tmp/libs/* /lib
COPY --from=builder /root/hiddify /etc/s6-overlay/s6-rc.d/hiddify/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENV SUB_URL="" \
 WEB_SECRET="hiddify" \
 PROXY_USER="hiddify" \
 PROXY_PASS="hiddify" \
 REGION="cn" \
 BASE_PATH="/etc/s6-overlay/s6-rc.d" \
 S6_OVERLAY_VERSION="3.2.0.2"


RUN wget -O /tmp/s6-overlay-noarch.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxf /tmp/s6-overlay-noarch.tar.xz \
    && rm -f /tmp/s6-overlay-noarch.tar.xz \
    && wget -O /tmp/s6-overlay-x86_64.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz \
    && tar -C / -Jxf /tmp/s6-overlay-x86_64.tar.xz \
    && rm -f /tmp/s6-overlay-x86_64.tar.xz \
    && ln -sf /run /var/run
 

#代理端口
EXPOSE 2334
#web端口
EXPOSE 6756

HEALTHCHECK --interval=10s --timeout=5s CMD /healthcheck.sh

ENTRYPOINT ["/init"]
