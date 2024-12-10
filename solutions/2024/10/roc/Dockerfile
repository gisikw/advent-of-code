FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  pkg-config \
  libgcc-10-dev \
  libstdc++-10-dev \
  libc6-dev \
  zlib1g-dev \
  git

RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Enable Flakes and nix-command experimental features
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

ENV PATH="/root/.nix-profile/bin:/root/.nix-profile/sbin:/usr/local/bin:$PATH"

WORKDIR /roc

RUN git clone https://github.com/roc-lang/roc.git .

RUN nix develop

RUN nix-shell --run "cargo build --release"

ENV PATH="/roc/target/release:$PATH"
