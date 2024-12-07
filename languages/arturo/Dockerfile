FROM nimlang/nim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl gtk+-3.0 webkit2gtk-4.0 libgmp-dev libmpfr-dev

WORKDIR /arturo
RUN git clone https://github.com/arturo-lang/arturo.git . && ./build.nims --install
ENV PATH="/root/.arturo/bin:$PATH"
