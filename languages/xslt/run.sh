#!/bin/sh

java net.sf.saxon.Transform -s:"$1" -xsl:"solution.xsl" -o:"output.xml" part="$2" && \
cat output.xml
