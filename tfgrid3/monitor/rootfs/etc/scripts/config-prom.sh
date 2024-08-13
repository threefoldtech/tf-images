#!/bin/bash

# Check if the PROM_TARGETS environment variable is set
if [ -z "$PROM_TARGETS" ]; then
  echo "PROM_TARGETS environment variable is not set."
  exit 1
fi

# Split the PROM_TARGETS string into an array
IFS=',' read -ra TARGETS <<< "$PROM_TARGETS"

mkdir -p /etc/prometheus
touch /etc/prometheus/prometheus.yml

# Generate the Prometheus config with dynamic targets
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'mariadb-exporter'
    static_configs:
      - targets: [$(printf "'%s'," "${TARGETS[@]}" | sed 's/,$//')]
EOF

echo "Prometheus configuration generated successfully."
