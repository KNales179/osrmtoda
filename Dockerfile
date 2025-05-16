FROM debian:bullseye

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    wget \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    liblua5.2-0 \
    libstxxl1v5 \
    libxml2 \
    zlib1g \
    && apt-get clean

# Working directory
WORKDIR /app

# Download your own prebuilt osrm-routed binary (from your repo)
RUN wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/osrm-routed && \
    chmod +x osrm-routed

# Download preprocessed OSRM data
WORKDIR /data
RUN wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.partition && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.properties && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.edges && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.ebg_nodes && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.mldgr && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.geometry

EXPOSE 5000

# Start OSRM with MLD algorithm
CMD ["/app/osrm-routed", "--algorithm", "mld", "/data/lucena.osrm"]
