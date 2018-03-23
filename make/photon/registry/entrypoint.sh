#!/bin/sh

set -e

if [ -d /etc/registry ]; then
    chown 10000:10000 -R /etc/registry
fi
if [ -d /var/lib/registry ]; then
    chown 10000:10000 -R /var/lib/registry
fi
if [ -d /storage ]; then
    if ! stat -c '%u:%g' /storage | grep -q '10000:10000' ; then
        # 10000 is the id of harbor user/group.
        # Usually NFS Server does not allow changing owner of the export directory,
        # so need to skip this step and requires NFS Server admin to set its owner to 10000.
        chown 10000:10000 -R /storage
    fi
fi

case "$1" in
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

sudo -E -u \#10000 "$@"
