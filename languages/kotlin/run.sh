#!/bin/bash

# Compile is slow, and this unfortunately doesn't seem to meaningfully help
export JAVA_OPTS="-Xmx2048m -Xms1024m"

kotlinc solution.kt -include-runtime -d solution.jar
java -jar solution.jar "$@"
