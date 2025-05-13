# updated
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    libbz2-dev \
    libstxxl-dev \
    libstxxl1v5 \
    libxml2-dev \
    libzip-dev \
    libboost-all-dev \
    lua5.2 \
    liblua5.2-dev \
    libprotobuf-dev \
    protobuf-compiler \
    pkg-config \
    zlib1g-dev \
    ca-certificates

# Install Intel TBB (from source, because apt version is broken/missing headers)
WORKDIR /deps
RUN git clone https://github.com/oneapi-src/oneTBB.git && \
    cd oneTBB && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DTBB_TEST=OFF && \
    make -j$(nproc) && make install

# Build OSRM (checkout stable release)
WORKDIR /app
RUN git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && \
    git checkout v5.27.1 && \
    mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build .

# Prepare data directory
WORKDIR /data
RUN wget "https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osm.pbf"

# Preprocess map data
RUN /app/osrm-backend/build/osrm-extract -p /app/osrm-backend/profiles/car.lua lucena.osm.pbf && \
    /app/osrm-backend/build/osrm-partition lucena.osrm && \
    /app/osrm-backend/build/osrm-customize lucena.osrm

EXPOSE 5000

# Run the OSRM server
CMD ["/app/osrm-backend/build/osrm-routed", "--algorithm", "mld", "lucena.osrm"]
