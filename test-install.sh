#!/bin/bash

./package-dockerized.sh

docker run \
    --net=host \
    -it \
    --rm \
    -u dfuser \
    -v "$(pwd)/dotfiles.tar.gz:/home/dfuser/dotfiles.tar.gz" \
    dotfiles-base:latest \
    "tar -xf dotfiles.tar.gz && cd dotfiles && ./install.sh unpack"
