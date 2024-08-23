#!/bin/bash
set -xe

BUILD_DIR="$(mktemp -d)"
PACKAGES_DIR="packages"
PACKAGES_FULL_DIR="$BUILD_DIR/dotfiles/$PACKAGES_DIR"
FINAL_DOTFILE_PACKAGE="dotfiles.tar.gz"

DEFAULT_TAR_EXCLUDES=(--exclude='*.pyc' --exclude='*.log')

# Clear out the existing packeg if it exists
rm -rf "$FINAL_DOTFILE_PACKAGE"

# Add dotfiles to the build
cp -r "$(pwd)" "$BUILD_DIR"

# Create the packages dir
mkdir -p "$PACKAGES_FULL_DIR"

# Setup font
# TODO: package up my fonts dir

# Setup neovim
NVIM_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/neovim"
mkdir -p "$NVIM_PACKAGES_FULL_DIR"

# TODO package cabal
tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" \
    -czf "$NVIM_PACKAGES_FULL_DIR/nvm-cache.tar.gz" .nvm
tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" \
    -czf "$NVIM_PACKAGES_FULL_DIR/neovim-cache.tar.gz" .local/share/nvim
wget -O "$NVIM_PACKAGES_FULL_DIR/nvim.appimage" "$NVIM_URL"

# Setup zsh
ZSH_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/zsh"
mkdir -p "$ZSH_PACKAGES_FULL_DIR"

tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" \
    -czf "$ZSH_PACKAGES_FULL_DIR/ohmyzsh-cache.tar.gz" .oh-my-zsh

# Setup tmux
TMUX_PACKAGES_FULL_DIR="$PACKAGES_FULL_DIR/tmux"
mkdir -p "$TMUX_PACKAGES_FULL_DIR"

tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" \
    -czf "$TMUX_PACKAGES_FULL_DIR/tmux-cache.tar.gz" .tmux

# Build final package
tar -C "$BUILD_DIR" -czf "$FINAL_DOTFILE_PACKAGE" "dotfiles"
echo "Done: $FINAL_DOTFILE_PACKAGE"
