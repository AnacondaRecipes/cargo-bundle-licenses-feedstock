#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Set up rust environment
export CARGO_HOME=${CONDA_PREFIX}/.cargo.$(uname)
export CARGO_CONFIG=${CARGO_HOME}/config
export RUSTUP_HOME=${CARGO_HOME}/rustup
export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

# On macOS, reserve space so conda's install_name_tool can fix rpaths/install names later
if [[ "$(uname)" == "Darwin" ]]; then
  export RUSTFLAGS="${RUSTFLAGS:-} -C link-arg=-Wl,-headerpad_max_install_names"
fi

# build statically linked binary with Rust
cargo auditable install --no-track --verbose --locked --root "$PREFIX" --path .
