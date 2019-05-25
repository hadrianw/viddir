#!/bin/sh

cd ..
echo $PWD > /dev/stderr

cat cgi-bin/head.html

echo "<title>Index</title>"
echo "<h1>Index</h1>"

echo "<ul>"

cgi-bin/index store 1 10

echo "</ul>"
