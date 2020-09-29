FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash curl
WORKDIR /go/src/v2ray.com/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine

ENV PORT    3000
ENV UUID    c95ef1d4-f3ac-4586-96e9-234a37dda068
ENV PROTOCOL    vmess

COPY --from=builder /tmp/v2ray.tgz /tmp
RUN tar xvfz /tmp/v2ray.tgz -C /usr/bin && \
    rm -rf /tmp/v2ray.tgz

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
