#!/bin/sh
mkdir -p www/{store,thumbs}
exec busybox httpd -p 8989 -h www -f
