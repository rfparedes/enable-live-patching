#!/usr/bin/env bash

. /etc/os-release

# Clean the environment
PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/bin:/usr/bin
test -n "$TERM" || TERM=raw
LANG=POSIX
export PATH TERM LANG

case $VERSION_ID in
  
  "15" | "15.1" | "15.2")
    MODNAME="sle-module-live-patching"
    ;;

  "12.3" | "12.4" | "12.5")
    MODNAME="sle-live-patching"
    ;;

  *)
    echo "Not a supported OS version."
    exit

esac    

tmpfile=$(mktemp /tmp/inst-metadata.XXXXXX)
metadata(){
cut -d "=" /etc/regionserverclnt.cfg -f 2 | grep metadata
}
$(metadata) >& "$tmpfile"

SUSEConnect -p "$MODNAME"/"$VERSION_ID"/x86_64 --instance-data "$tmpfile"
rm "$tmpfile"
