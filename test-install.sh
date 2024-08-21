#!/bin/bash
set -xe

if [ ! -f "dotfiles.tar.gz" ]; then
    echo "Missing dotfiles.tar.gz!"
    exit 1
fi

docker build --no-cache -t dotfiles:latest .

docker run \
    --net=host \
    -it \
    --rm \
    -u user \
    -v "$(pwd)/dotfiles.tar.gz":/root/dotfiles.tar.gz \
    dotfiles:latest \
    /bin/zsh
