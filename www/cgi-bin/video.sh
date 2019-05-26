#!/bin/sh

if [[ "$PATH_INFO" != /* ]]; then
	exit 1
fi

cd ..
NAME=${PATH_INFO:1}

cat cgi-bin/head.html

echo "<title>$NAME</title>"
echo "<h1>$NAME</h1>"

echo "<video src=\"/store/$NAME\" controls style=\"width: 100%; height: auto;\">"
echo "Sorry, but video playback is not supported by your browser."
echo "</video>"

cd tags
echo "<p>"
for i in */"$NAME"; do
	tag=$(dirname "$i")
	tags="$tags $tag"
	echo "<a href=\"/cgi-bin/index.sh/$tag\">$tag</a>"
done

echo "<form action=\"/cgi-bin/edit-tags.sh/$NAME\" method=\"post\" enctype=\"text/plain\">"
echo "<label for=\"tags\">Tags</label><br>"
echo "<textarea id=\"tags\" name=\"tags\">"
for i in */"$NAME"; do
	echo $tags
done
echo "</textarea><br>"
echo "<button type=\"submit\">Edit tags</button>"
echo "</form>"
