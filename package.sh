#!/bin/bash
set -xe

FONT_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip'
NVIM_URL='https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'

BUILD_DIR="$(mktemp -d)"
PACKAGES_DIR="packages"
PACKAGES_FULL_DIR="$BUILD_DIR/dotfiles/$PACKAGES_DIR"
FINAL_DOTFILE_PACKAGE="dotfiles.tar.gz"

# Clear out the existing packeg if it exists
rm -rf "$FINAL_DOTFILE_PACKAGE"

# Add dotfiles to the build
cp -r "$(pwd)" "$BUILD_DIR"

# Create the packages dir
mkdir -p "$PACKAGES_FULL_DIR"

# Setup font
wget -O "$PACKAGES_FULL_DIR/CascadioCodeNerd.zip" "$FONT_URL"

# Setup neovim
NVIM_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/neovim"
mkdir -p "$NVIM_PACKAGES_FULL_DIR"

tar -C "$HOME" -czf "$NVIM_PACKAGES_FULL_DIR/nvm.tar.gz" .nvm
tar -C "$HOME" -czf "$NVIM_PACKAGES_FULL_DIR/neovim-cache.tar.gz" .local/share/nvim
wget -O "$NVIM_PACKAGES_FULL_DIR/neovim" "$NVIM_URL"

# Setup zsh
ZSH_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/zsh"
mkdir -p "$ZSH_PACKAGES_FULL_DIR"

tar -C "$HOME" -czf "$ZSH_PACKAGES_FULL_DIR/ohmyzsh-cache.tar.gz" .oh-my-zsh

# Setup tmux
TMUX_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/tmux"
mkdir -p "$TMUX_PACKAGES_FULL_DIR"

tar -C "$HOME" -czf "$TMUX_PACKAGES_FULL_DIR/tmux-cache.tar.gz" .tmux

# Build final package
tar -C "$BUILD_DIR" -czf "$FINAL_DOTFILE_PACKAGE" "dotfiles"
echo "Done: $FINAL_DOTFILE_PACKAGE"
