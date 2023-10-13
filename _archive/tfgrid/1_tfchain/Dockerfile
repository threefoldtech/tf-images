FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install git wget curl -y

# Install rust

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.67.0 \
    rustArch='x86_64-unknown-linux-gnu' 

RUN curl https://sh.rustup.rs -sSf | sh -s --  -y --no-modify-path --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; 

# Substrate's wasm builder requires a nightly release of rust 
# https://github.com/paritytech/substrate/blob/cb4f2491b00af7d7817f3a54209c26b20faa1f51/utils/wasm-builder/src/prerequisites.rs
# ( seems like this will be fixed one of these days: https://github.com/paritytech/substrate/issues/1252 )
RUN rustup install nightly-2022-11-15 
RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2022-11-15

# Extra substrate/tfchain requirements
RUN apt-get install -y librocksdb-dev libclang-dev  clang lldb lld build-essential protobuf-compiler

COPY --from=rustbuilder /bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]