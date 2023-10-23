FROM bats/bats:latest

# Install dependencies
RUN apk add --no-cache \
    curl \
    docker-cli \
    py3-pip && \
    pip3 install --upgrade pip && \
    pip3 install yq
