#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

sudo apt update 

sudo apt install -y \
    unzip \
    luarocks \
    golang \
    ripgrep \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    xsel \
    fd-find \
    shellcheck \
    yamllint \
    zsh \
    tmux \
    fzf \
    fuse \
    libfuse2 \
    git

python3 -m pip install \
    neovim \
    pylint \
    pycodestyle \
    robotframework-robocop \
    black

mkdir -p "$HOME/.config"

# Setup zsh
ln -s "$(pwd)/zshrc" ~/.zshrc
tar -xf packages/zsh/ohmyzsh-cache.tar.gz -C "$HOME"

# Setup tmuz
ln -s "$(pwd)/tmux.conf" ~/.tmux.conf
tar -xf packages/tmux/tmux-cache.tar.gz -C "$HOME"

# Setup neovim
ln -s "$(pwd)/nvim" ~/.config/nvim

if [[ -v $IN_DOCKER ]]; then
    chmod +x packages/neovim/nvim
    ./packages/neovim/nvim --appimage-extract
    
    # Optional: exposing nvim globally.
    sudo mv squashfs-root /opt/nvim
    sudo ln -s /opt/nvim/AppRun /usr/bin/nvim
else
    sudo cp packages/neovim/neovim /usr/bin/nvim
    sudo chmod +x /usr/bin/nvim
fi
tar -xf packages/neovim/neovim-cache.tar.gz -C "$HOME"
tar -xf packages/neovim/nvm.tar.gz -C "$HOME"
