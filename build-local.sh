#!/bin/bash
set -euo pipefail

IMAGE=glove80-perkey-rgb
ZMK_DIR="$(cd "$(dirname "$0")/../darknao-zmk" && pwd)"

if [ ! -d "$ZMK_DIR" ]; then
    echo "Error: ZMK sources not found at $ZMK_DIR" >&2
    echo "Clone darknao/zmk first: git clone --branch rgb-layer-24.12 https://github.com/darknao/zmk.git ../darknao-zmk" >&2
    exit 1
fi

echo "Building with local ZMK sources from $ZMK_DIR" >&2

docker build -t "$IMAGE" .
docker run --rm \
  -v "$PWD:/config" \
  -v "$ZMK_DIR:/src:ro" \
  -e UID="$(id -u)" \
  -e GID="$(id -g)" \
  --entrypoint /bin/bash \
  "$IMAGE" \
  -c 'cd /config && nix-build ./config --arg firmware "import /src/default.nix {}" -j2 -o /tmp/combined --show-trace && install -o "$UID" -g "$GID" /tmp/combined/glove80.uf2 ./glove80.uf2'
