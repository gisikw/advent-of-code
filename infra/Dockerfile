FROM nixos/nix:2.29.0

# Set flakes support, disable syscall filtering for container support
RUN cat <<-EOF >> /etc/nix/nix.conf
experimental-features = nix-command flakes
filter-syscalls = false
EOF

# Install `script` via nix-env for inspectable TTY
RUN nix-env -iA nixpkgs.util-linux 

# Copy in flake files for the purpose of warming dependencies into the image
COPY . /infra/
WORKDIR /infra
RUN nix flake show >/dev/null 2>&1

# Declare /nix as a volume to persist the store across runs
VOLUME ["/nix"]

# Set /code as the workdir
WORKDIR /code
