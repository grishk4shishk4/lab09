FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY CMakeLists.txt CPackConfig.cmake ./
COPY cmake ./cmake
COPY include ./include
COPY sources ./sources
COPY demo ./demo

RUN cmake -B . -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF && \
    cmake --build . --target demo

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/demo /usr/local/bin/demo

ENTRYPOINT ["/usr/local/bin/demo"]
