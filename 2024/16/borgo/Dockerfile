FROM golang:latest
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"
RUN cargo install --git https://github.com/borgo-lang/borgo
