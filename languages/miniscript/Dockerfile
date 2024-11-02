FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y cmake build-essential git bash && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/JoeStrout/miniscript.git && \
    sed -i 's/initialE.scanCode/static_cast<int>(initialE.scanCode)/' miniscript/MiniScript-cpp/src/Key.cpp && \
    sed -i '321d' miniscript/MiniScript-cpp/src/MiniScript/SimpleString.cpp && \
    cd miniscript/MiniScript-cpp && \
    mkdir build && \
    cd build && \
    cmake ../.. && \
    cmake --build . --config Release && \
    cp miniscript /usr/local/bin/miniscript
