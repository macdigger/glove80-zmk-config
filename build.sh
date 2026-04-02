#!/bin/bash

set -euo pipefail

IMAGE=glove80-perkey-rgb
BRANCH="${1:-rgb-layer-24.12}"

docker build -t "$IMAGE" .
docker run --rm -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" -e BRANCH="$BRANCH" "$IMAGE"
