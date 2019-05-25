#!/bin/sh

if [[ -z "$PATH_INFO" ]]; then
	PATH_INFO="/"
fi

if [[ "$PATH_INFO" != /* ]]; then
	exit 1
fi

cd ..

if [[ "$PATH_INFO" == "/" ]]; then
	DIR=store
elif [[ -d "tags$PATH_INFO" ]]; then
	DIR="tags$PATH_INFO"
fi

cat cgi-bin/head.html

echo "<title>Index</title>"
echo "<h1>Index</h1>"

echo "<ul>"

if [[ -z "$QUERY_STRING" ]]; then
	page=1
else
	page=${QUERY_STRING##*=}
fi
cgi-bin/index "$DIR" "$page" 30

echo "</ul>"

prev=$(($page - 1))
next=$(($page + 1))
if [[ "$prev" -gt 0 ]]; then
echo "<a href=\"$SCRIPT_NAME$PATH_INFO?p=$prev\">Prev ($prev)</a>"
fi
echo $page
echo "<a href=\"$SCRIPT_NAME$PATH_INFO?p=$next\">Next ($next)</a>"
