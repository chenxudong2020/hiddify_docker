FROM debian:buster-slim AS builder

ARG HIDDIFY_VERSION=3.1.8
ARG SOCKS5_TO_HTTP_PROXY_VERSION=0.5.0-beta2

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

RUN mkdir -p /root/hiddify && cd /root/hiddify && wget --no-check-certificate -O hiddify_linux.tar.gz -c https://github.com/hiddify/hiddify-core/releases/download/v${HIDDIFY_VERSION}/hiddify-cli-linux-amd64.tar.gz \
    && tar zxvf hiddify_linux.tar.gz && rm -rf hiddify_linux.tar.gz \
    && mkdir -p /root/socks-to-http-proxy && cd /root/socks-to-http-proxy \
    && wget --no-check-certificate -O sthp-linux -c https://github.com/KaranGauswami/socks-to-http-proxy/releases/download/${SOCKS5_TO_HTTP_PROXY_VERSION}/sthp-linux \
    && chmod +x ./sthp-linux

RUN mkdir -p /tmp/libs/ && \
    cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /tmp/libs/


RUN mkdir -p /tmp/libs/


FROM busybox:stable-glibc


COPY --chmod=755 ./rootfs /
COPY --from=builder /tmp/libs/* /lib
COPY --from=builder /root/hiddify /etc/s6-overlay/s6-rc.d/hiddify/
COPY --from=builder /root/socks-to-http-proxy /etc/s6-overlay/s6-rc.d/socks-to-http-proxy/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENV SUB_URL="" \
 WEB_SECRET="hiddify" \
 PROXY_USER="hiddify" \
 PROXY_PASS="hiddify" \
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
EXPOSE 2335
#web端口
EXPOSE 6756

HEALTHCHECK --interval=10s --timeout=5s CMD /healthcheck.sh

ENTRYPOINT ["/init"]