FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    libbz2-dev \
    libstxxl-dev \
    libxml2-dev \
    libzip-dev \
    libboost-all-dev \
    lua5.2 \
    liblua5.2-dev \
    libtbb-dev \
    libprotobuf-dev \
    protobuf-compiler

# Clone and build OSRM
RUN git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && \
    mkdir -p build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build .

# Set working directory
WORKDIR /data

# Copy the .osm.pbf file into the container
# If you have the file locally, you can add it during the build
# COPY lucena.osm.pbf /data/

# Expose the OSRM port
EXPOSE 5000

# Default command
CMD ["/osrm-backend/build/osrm-routed", "--algorithm", "mld", "lucena.osrm"]
