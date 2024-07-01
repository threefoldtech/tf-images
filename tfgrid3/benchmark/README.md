# Benchmark

A small flist used to benchmark nodes and how a normal workload would perform. It uses [cpubench](https://github.com/threefoldtech/cpu-benchmark-simple) and [fio](https://fio.readthedocs.io/en/latest/fio_doc.html) and pushes the result to an [influxdb](https://docs.influxdata.com/influxdb/v2/) instance.

It depends on `jq` to parse json output of benchmarks and `crond` to run benchmarks periodically every 15 minutes.

## How to use

- Run `build.sh` with `sudo` and a tarball should be created called `benchmark.tar.gz`.
- Upload the archive to hub.grid.tf with either the UI or curl with [API token](https://hub.grid.tf/token).

## Environment Variables

In order for this flist to work properly, a set of environment variables needs to be provided:

- `INFLUX_URL`: URL of the running influxdb instance. Example: `influx.example.org:8086`
- `INFLUX_ORG`: organization specified when running influxdb instance.
- `INFLUX_TOKEN`: influxdb access token.
- `INFLUX_BUCKET`: influxdb bucket where results will reside.
- `NODE_ID`: node id of the running VM to filter results.
- `FARM_ID`: farm id of the running VM to filter results.

## Testing

An instance of benchmark flist can be found [here](https://hub.grid.tf/aelawady.3bot/benchmark.flist.md). You will need to run it after deploying an influxdb instance and provide the needed environment variables.

You can run an influxdb instance with docker like this

```console
$ docker run --rm --name influx -p 8086:8086 \            
  -e DOCKER_INFLUXDB_INIT_MODE=setup \
  -e DOCKER_INFLUXDB_INIT_USERNAME=abc \
  -e DOCKER_INFLUXDB_INIT_PASSWORD=12345678 \
  -e DOCKER_INFLUXDB_INIT_ORG=tf \
  -e DOCKER_INFLUXDB_INIT_BUCKET=init \
  -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=123 \
  influxdb:2
```

For more details on influxdb docker image check out [influxdb](https://hub.docker.com/_/influxdb).
