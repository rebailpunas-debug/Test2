FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

# Create grafana user and group
RUN groupadd -r grafana && \
    useradd -r -g grafana grafana

# Create necessary directories
RUN mkdir -p /usr/share/grafana /etc/grafana /var/lib/grafana /var/log/grafana && \
    chown -R grafana:grafana /var/lib/grafana /var/log/grafana

# Copy your pre-built Grafana files
COPY bin/ /usr/share/grafana/bin/
COPY conf/ /etc/grafana/
COPY public/ /usr/share/grafana/public/
COPY plugins-bundled/ /usr/share/grafana/plugins-bundled/
COPY scripts/ /usr/share/grafana/scripts/

# Copy data if you have custom plugins there
COPY data/ /var/lib/grafana/ 

# Make grafana-server executable
RUN chmod +x /usr/share/grafana/bin/grafana-server && \
    chown -R grafana:grafana /usr/share/grafana /etc/grafana

# Set working directory
WORKDIR /usr/share/grafana

# Expose Grafana port
EXPOSE 3000

# Switch to grafana user
USER grafana

# Start Grafana using your grafana-server binary
CMD ["/usr/share/grafana/bin/grafana-server", \
     "--homepath=/usr/share/grafana", \
     "--config=/etc/grafana/grafana.ini"]
