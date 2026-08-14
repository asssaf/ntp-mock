FROM alpine:edge

# latest certs
RUN apk add ca-certificates --no-cache && update-ca-certificates

# timezone support
ENV TZ=UTC
RUN apk add --update tzdata --no-cache &&\
    cp /usr/share/zoneinfo/${TZ} /etc/localtime &&\
    echo $TZ > /etc/timezone

# install chrony and place default conf which can be overridden with volume
RUN apk add --no-cache chrony libfaketime
RUN mkdir -p /etc/chrony
COPY chrony.conf /etc/chrony/.

ENV LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1

# port exposed
EXPOSE 123/udp

HEALTHCHECK CMD chronyc tracking || exit 1

# start
CMD [ "/usr/sbin/chronyd", "-d", "-s", "-x"]
