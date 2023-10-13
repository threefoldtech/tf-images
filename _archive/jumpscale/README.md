# Jumpscale

Jumpscale builder which is based on [python builder](../python/README.md).

### Prerequisites

[Building](../python/README.md#building) python builder first.

### Building

```
bash ./build.sh
```

### Connecting

```
bash ./connect.sh
```

### Code and configuration directories

All related directories can be found at `~/myhost` in the host. Inside the container, this directory is mounted at `/myhost`.

The directory will contain the following:

* `code`: contains related repositories ready for changes
* `config`: will contain related jumpscale configuration to work later even if the container is deleted.
* `jsng`: will contain the shell configuration (history files...etc)

### Tools

Once you're connected, `poetry` and `jsng` will be available.

```
bash ./connect.sh
...
...
THREEFOLD JUMPSCALE DEV ENV WELCOMES YOU
jumpscale:~# jsng
JS-NG> j.clients.redis.list_all()
{'hamadaellol', 'main'}
```
