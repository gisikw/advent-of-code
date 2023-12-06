#!/bin/bash

apk add wget unzip openjdk11 bash
mkdir /var/kotlin
(
  cd /var/kotlin
  wget https://github.com/JetBrains/kotlin/releases/download/v1.9.21/kotlin-compiler-1.9.21.zip
  unzip kotlin-compiler-1.9.21.zip
)
export PATH=/var/kotlin/kotlinc/bin:$PATH

kotlinc solution.kt -include-runtime -d solution.jar
java -jar solution.jar "$@"
