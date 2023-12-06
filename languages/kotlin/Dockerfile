FROM alpine:latest
RUN apk add openjdk11 wget unzip bash

# Download and install Kotlin compiler
ENV KOTLIN_VERSION=1.9.21
ENV KOTLIN_HOME=/usr/local/kotlinc
RUN mkdir -p "$KOTLIN_HOME" && \
    wget "https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip" -O kotlin-compiler.zip && \
    unzip kotlin-compiler.zip -d /usr/local && \
    rm kotlin-compiler.zip

# Add Kotlin compiler to PATH
ENV PATH="$KOTLIN_HOME/bin:$PATH"
