#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_HOME=${CONDA_PREFIX}/.cargo.$(uname)
export CARGO_CONFIG=${CARGO_HOME}/config
export RUSTUP_HOME=${CARGO_HOME}/rustup


if [[ "$c_compiler" == "clang" ]]; then
  echo "-L$BUILD_PREFIX/lib -Wl,-rpath,$BUILD_PREFIX/lib" > $BUILD_PREFIX/bin/$BUILD.cfg
  echo "-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib" > $BUILD_PREFIX/bin/$HOST.cfg
fi

# build statically linked binary with Rust
cargo install --verbose --locked --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/cargo-bundle-licenses"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"
