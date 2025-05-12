FROM osrm/osrm-backend

WORKDIR /data

# Install wget so we can download from Google Drive
RUN apt-get update && apt-get install -y wget

# Download Lucena map and prepare OSRM
RUN wget "https://drive.google.com/uc?export=download&id=1k3yHd8dY00SplyZ_H0B-GDdKiAcOID30" -O lucena.osm.pbf && \
    osrm-extract -p /opt/car.lua lucena.osm.pbf && \
    osrm-partition lucena.osrm && \
    osrm-customize lucena.osrm

EXPOSE 5000

CMD ["osrm-routed", "--algorithm", "mld", "lucena.osrm"]
