FROM golang:1.22.1-alpine3.19 as builder

ARG GO111MODULE=on
ARG GOPROXY=https://goproxy.io

WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache make \
    && rm -rf /var/cache/apk/*

COPY . /app

RUN CGO_ENABLED=0 GOOS=linux go build -o simple-web-server .

#----------------------------------------------------------------

FROM alpine:3.19

LABEL .image.authors="ichaff1997@gmail.com"

ARG USER="ichaff"

WORKDIR /app

COPY --from=builder /app/simple-web-server /app/simple-web-server

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache tzdata\
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/* \
    && adduser -D $USER \
    && chown $USER:$USER /app/simple-web-server \
    && chmod 700 /app/simple-web-server

USER $USER

ENTRYPOINT ["/app/simple-web-server"]