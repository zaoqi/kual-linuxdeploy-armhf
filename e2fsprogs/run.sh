#!/bin/sh
set -e
img="$(basename "$(mktemp -u)")"
docker build -t "$img" .
rm -fr out
mkdir out
docker run -it --rm -v "$(pwd)/out:/out" "$img" cp -vr /src/ /out/
docker rmi "$img"
