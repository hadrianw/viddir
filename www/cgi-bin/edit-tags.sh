#!/bin/bash

if [[ "$PATH_INFO" != /* ]]; then
	exit 1
fi

cd ..
NAME=${PATH_INFO:1}

comm -3 \
<(cd tags
for i in */"$NAME"; do
	tag=$(dirname "$i")
	if [[ -d "$tag" ]]; then
		echo $tag
	fi
done) \
<(sed '1 s/^tags=//' |
while read line; do
	for tag in $line; do
		if [[ "$tag" == *[A-Za-z0-9]* ]]; then
			echo $tag
		fi
	done
done | sort -u) | awk -v NAME="$NAME" '
BEGIN {
	RS="\r?\n"
}

{
	if($0 ~ /^\t/) {
		system("mkdir -p \"tags/" $1 "/\"")
		system("ln -s \"../../store/" NAME "\" \"tags/" $1 "/\"")
	} else {
		system("rm \"tags/" $1 "/" NAME "\"")
	}
}'

echo HTTP/1.1 302 OK
echo Status: 302 Moved
echo Location: /cgi-bin/video.sh/$NAME
echo
