#!/bin/bash

docker build --no-cache --target dotfiles-base -t dotfiles-base:latest .
docker build --no-cache -t dotfiles:latest .

docker run \
    --net=host \
    -it \
    --rm \
    -u dfuser \
    -v "$(pwd):/home/dfuser/dotfiles" \
    dotfiles:latest \
    ./install.sh package
