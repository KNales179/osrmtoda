FROM debian:bullseye-slim

# Install OSRM + dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    g++ \   <-- this is the fix
    git \
    cmake \
    pkg-config \
    libprotoc-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libosmpbf-dev \
    libstxxl-dev \
    libstxxl1v5 \
    libxml2-dev \
    libzip-dev \
    libboost-all-dev \
    lua5.3 \
    liblua5.3-dev \
    libtbb-dev \
    && apt-get clean

# Clone and build OSRM
WORKDIR /app
RUN git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && mkdir -p build && cd build && \
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
