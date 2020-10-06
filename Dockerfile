FROM --platform=$TARGETPLATFORM alpine:latest
MAINTAINER Jeroen Geusebroek <me@jeroengeusebroek.nl>
MAINTAINER Andreas Sehr <andreas@softbrix.se>
MAINTAINER Marc Ammon <marc.ammon@fau.de>

ARG BUILD_DATE=None

ENV HTPASSWD=webdav:kK1eUy0t2agv6
ENV BUILD_DATE=$BUILD_DATE

RUN apk add --no-cache \
        lighttpd \
        lighttpd-mod_webdav \
        lighttpd-mod_auth \
        # to avoid big log files
        logrotate

# copy relevant files
ADD files/ /
ADD ./entrypoint.sh /entrypoint.sh

EXPOSE 80
VOLUME [ "/webdav" ]
ENTRYPOINT ["/entrypoint.sh"]
