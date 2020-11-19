#!/bin/sh
set -x

# Force user and group because lighttpd runs as webdav
USERNAME=webdav
GROUP=webdav

# Add user if it does not exist
if ! id -u "${USERNAME}" >/dev/null 2>&1; then
    groupadd -o -g ${USER_GID} ${GROUP}
    useradd -o -g ${GROUP} -M -u ${USER_UID} ${USERNAME}
fi

chown ${USERNAME}:${GROUP} /var/log/lighttpd

if [ -n "$WHITELIST" ]; then
    sed -i "s/WHITELIST/${WHITELIST}/" /etc/lighttpd/webdav.conf
fi

if [ "$READWRITE" == "true" ]; then
    # enable write permissions on file system
    chown -R ${USERNAME}:${GROUP} /webdav
    # apply write config
    sed -i "s/is-readonly = \"\\w*\"/is-readonly = \"disable\"/" /etc/lighttpd/webdav.conf
else
    sed -i "s/is-readonly = \"\\w*\"/is-readonly = \"enable\"/" /etc/lighttpd/webdav.conf
fi

echo $HTPASSWD > /etc/lighttpd/htpasswd

# start cron daemon with logging
/usr/sbin/crond -L /var/log/cron.log

# this function is called on 'docker stop'
function _term() {
    echo "Caught SIGTERM signal!"

    kill $LIGHTTPD_PID
    kill $TAIL_PID
}
trap _term SIGTERM

# start lighttpd
lighttpd -D -f /etc/lighttpd/lighttpd.conf &
LIGHTTPD_PID=$!

# Hang on a bit while the server starts
sleep 5

# start logging
tail -f /var/log/lighttpd/*.log &
TAIL_PID=$!

# wait for the lighttpd process
wait "$LIGHTTPD_PID"
