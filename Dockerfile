FROM debian:bullseye

<<<<<<< HEAD
<<<<<<< HEAD
# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    wget \
    libboost-program-options1.83.0 \
    libboost-filesystem1.83.0 \
    libboost-system1.83.0 \
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
=======
=======
>>>>>>> a5038f69662611fb9583fe22c17aa2059fe712d5
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
<<<<<<< HEAD
>>>>>>> a5038f69662611fb9583fe22c17aa2059fe712d5
=======
>>>>>>> a5038f69662611fb9583fe22c17aa2059fe712d5
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.properties && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.edges && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.ebg_nodes && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.mldgr && \
    wget https://github.com/KNales179/osrmtoda/releases/download/v1.0/lucena.osrm.geometry

EXPOSE 5000

<<<<<<< HEAD
<<<<<<< HEAD
# Start OSRM with MLD algorithm
CMD ["/app/osrm-routed", "--algorithm", "mld", "/data/lucena.osrm"]

=======
# Start the prebuilt OSRM server
CMD ["/app/osrm-routed", "--algorithm", "mld", "/data/lucena.osrm"]
>>>>>>> a5038f69662611fb9583fe22c17aa2059fe712d5
=======
# Start the prebuilt OSRM server
CMD ["/app/osrm-routed", "--algorithm", "mld", "/data/lucena.osrm"]
>>>>>>> a5038f69662611fb9583fe22c17aa2059fe712d5
