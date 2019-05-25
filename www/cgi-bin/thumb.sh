#!/bin/sh

if [[ "$PATH_INFO" != /* ]]; then
	exit 1
fi

cd ..
NAME=${PATH_INFO:1}

echo HTTP/1.1 200 OK
echo Content-Type: image/jpeg
echo

if [[ "store/$NAME" -nt "thumbs/$NAME.jpg" ]]; then
	# out.jpg is a symlink to /dev/stdout
	# it's a hack, because I don't know yet a ffmpeg option
	# for the thumbnail format
	ffmpeg -y -i "store/$NAME" -vf "thumbnail,scale=320:240" -frames:v 1 cgi-bin/out.jpg | tee "thumbs/$NAME.jpg"
else
	cat "thumbs/$NAME.jpg"
fi
