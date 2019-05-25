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

cgi-bin/index "$DIR" 1 10

echo "</ul>"
