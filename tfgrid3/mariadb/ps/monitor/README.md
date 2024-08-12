# Monitor

this image include prometheus and grafana that visualize a monitor with a full node dashboard.

## Envvars

- `PROM_TARGETS`: comma-separated string of hosts for prometheus to scrap
- `SSH_KEY`

## Ports

- `3000` for grafana dashboard
- `9090` for prometheus web ui
