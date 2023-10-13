# Grid SDK

Grid-sdk builder which is based on [jumpscale builder](../jumpscale/README.md).

### Prerequisites

[Building](../jumpscale/README.md#building) jumpscale builder first.

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

Once you're connected, `poetry`, `jsng` and `threebot` will be available.

```
bash ./connect.sh
...
...
THREEFOLD JUMPSCALE DEV ENV WELCOMES YOU
jumpscale:~# jsng
JS-NG> j.core.identity.me
...
...
jumpscale.core.exceptions.exceptions.Value: No configured identity found

No configured identity found
```

Changes to jumpscale code will be reflected directly in sdk, not need to do any extra setup.


### Threebot

Theebot can be started from inside the container (after connecting):

```
jumpscale:~# threebot start
```

After successful start, it can be accessed at https://localhost:5012.

