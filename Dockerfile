FROM --platform=$TARGETPLATFORM alpine:latest
MAINTAINER Jeroen Geusebroek <me@jeroengeusebroek.nl>
MAINTAINER Andreas Sehr <andreas@softbrix.se>
MAINTAINER Marc Ammon <marc.ammon@fau.de>

ARG BUILD_DATE=None

EXPOSE 80

VOLUME [ "/webdav" ]

ENV HTPASSWD=webdav:kK1eUy0t2agv6 \
    PACKAGE_LIST="lighttpd lighttpd-mod_webdav lighttpd-mod_auth logrotate" \
    BUILD_DATE=$BUILD_DATE

ADD ./entrypoint.sh /entrypoint.sh

RUN chmod u+x  /entrypoint.sh && \
    apk add --no-cache ${PACKAGE_LIST}

ADD files/ /

ENTRYPOINT ["/entrypoint.sh"]
