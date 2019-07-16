#!/bin/bash
set -e
img="temp${RANDOM}temp${RANDOM}temp${RANDOM}temp"
rm -fr out
docker build -t "$img" .
mkdir out
docker run --rm -v "$(pwd)/out:/out" "$img" sh -c "cp -vr /src/* /out/ && chown -R $(id -u):$(id -g) /out/*"
docker rmi "$img"
