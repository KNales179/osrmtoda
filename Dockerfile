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
RUN curl -L -o tbb.tar.gz https://github.com/oneapi-src/oneTBB/archive/refs/tags/2020.3.tar.gz && \
    tar -xvzf tbb.tar.gz && \
    cd oneTBB-2020.3 && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && make install

# Build OSRM
WORKDIR /app
RUN git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && \
    mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build .

# Prepare data directory
WORKDIR /data
RUN wget "https://drive.google.com/uc?export=download&id=1k3yHd8dY00SplyZ_H0B-GDdKiAcOID30" -O lucena.osm.pbf

# Preprocess map data
RUN /app/osrm-backend/build/osrm-extract -p /app/osrm-backend/profiles/car.lua lucena.osm.pbf && \
    /app/osrm-backend/build/osrm-partition lucena.osrm && \
    /app/osrm-backend/build/osrm-customize lucena.osrm

EXPOSE 5000

# Run the OSRM server
CMD ["/app/osrm-backend/build/osrm-routed", "--algorithm", "mld", "lucena.osrm"]
