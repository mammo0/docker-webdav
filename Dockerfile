FROM arm32v6/alpine:latest
MAINTAINER Jeroen Geusebroek <me@jeroengeusebroek.nl>
MAINTAINER Andreas Sehr <andreas@softbrix.se>
MAINTAINER Marc Ammon <marc.ammon@fau.de>

EXPOSE 80

VOLUME [ "/webdav" ]

ENV HTPASSWD=webdav:kK1eUy0t2agv6 \
    PACKAGE_LIST="lighttpd lighttpd-mod_webdav lighttpd-mod_auth logrotate" \
    REFRESHED_AT='2017-10-20'

ADD ./entrypoint.sh /entrypoint.sh

RUN chmod u+x  /entrypoint.sh && \
    apk add --no-cache ${PACKAGE_LIST}

ADD files/ /

ENTRYPOINT ["/entrypoint.sh"]
