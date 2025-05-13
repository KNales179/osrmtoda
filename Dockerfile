FROM debian:bullseye

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    libboost-all-dev \
    libstxxl1v5 \
    lua5.2 \
    liblua5.2-dev \
    libprotobuf-dev \
    zlib1g-dev \
    libxml2-dev \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Download prebuilt osrm-routed binary
RUN wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/osrm-routed && \
    chmod +x osrm-routed

# Download preprocessed OSRM map data
WORKDIR /data
RUN wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.partition && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.properties && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.edges && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.ebg_nodes && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.mldgr && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.geometry

EXPOSE 5000

# Start the prebuilt OSRM server
CMD ["/app/osrm-routed", "--algorithm", "mld", "/data/lucena.osrm"]
