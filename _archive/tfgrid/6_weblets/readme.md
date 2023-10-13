# grid_weblets builder

## Dockerfile

The standard `nodejsbuilder` is insufficient as there is a dependency on [node-gyp](https://github.com/nodejs/node-gyp) (through `node-sass`) which requires Python, make and a C/C++ compiler toolchain.
