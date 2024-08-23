#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

echo "IN_DOCKER? $IN_DOCKER"

PACKAGES_DIR="packages"
NVIM_APPIMAGE="/opt/nvim.appimage"
OFFLINE_INSTALL=0

if [[ -d "$PACKAGES_DIR" ]]; then
    OFFLINE_INSTALL=1
fi

sudo apt-get update

sudo apt-get install -y \
    unzip \
    luarocks \
    golang \
    ripgrep \
    python3 \
    python3-pip \
    python3-venv \
    xsel \
    fd-find \
    shellcheck \
    yamllint \
    zsh \
    tmux \
    fzf \
    fuse \
    libfuse2 \
    git \
    curl \
    build-essential \
    libffi-dev \
    libgmp-dev \
    libgmp10 \
    libncurses-dev \
    libncurses5 \
    libtinfo5 \
    zlib1g-dev

python3 -m pip install \
    neovim \
    pylint \
    pycodestyle \
    robotframework-robocop \
    black

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share/fonts"

if [ "$OFFLINE_INSTALL" -eq 1 ]; then
    tar -xf "$PACKAGES_DIR/tmux/tmux-cache.tar.gz" -C "$HOME"
    tar -xf "$PACKAGES_DIR/zsh/ohmyzsh-cache.tar.gz" -C "$HOME"
    tar -xf "$PACKAGES_DIR/neovim/neovim-cache.tar.gz" -C "$HOME"
    tar -xf "$PACKAGES_DIR/neovim/nvm-cache.tar.gz" -C "$HOME"
    tar -xf "$PACKAGES_DIR/neovim/cabal-cache.tar.gz" -C "$HOME"

    sudo mv "$PACKAGES_DIR/neovim/nvim.appimage" "$NVIM_APPIMAGE"

    # TODO unpack font

else
    # Install the nerd font
    wget -O "/tmp/CascadioCodeNerd.zip" \
        'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip'
    unzip "/tmp/CascadioCodeNerd.zip" -d "$HOME/.local/share/fonts"

    # install ohmyzsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # zsh-syntax highlighting plugin isn't available via ohmyzsh for some reason
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    # install nvm (nodejs installer)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    nvm install node

    # install tpm (tmux plugin manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    install ghcup (haskell version manager)
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
        BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest \
        BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 \
        BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=P sh
    source "$HOME/.ghcup/env"

    # install nvim
    wget -O /tmp/nvim.appimage 'https://github.com/neovim/neovim/releases/latest/download/nvim.appimage'
    chmod +x /tmp/nvim.appimage
    sudo mv /tmp/nvim.appimage "$NVIM_APPIMAGE"
fi

# appimages require fuse file system support, which we won't have
# in a docker container. So instead we extract the contents of the
# appimage
if [[ -v IN_DOCKER ]]; then
    "$NVIM_APPIMAGE" --appimage-extract

    sudo mv squashfs-root /opt/nvim
    sudo ln -s /opt/nvim/AppRun /usr/bin/nvim
else
    sudo ln -s "$NVIM_APPIMAGE" /usr/bin/nvim
fi

ln -fs "$(pwd)/zshrc" ~/.zshrc
ln -fs "$(pwd)/tmux.conf" ~/.tmux.conf
ln -fs "$(pwd)/nvim" ~/.config/nvim

if [ "$OFFLINE_INSTALL" -eq 1 ]; then
    # Mason installs packages in a way that some of them will reference /home/matt instead of ~.
    # This command is a little risky, but so far it works
    find ~/.local/share/nvim \
        -type f -exec sed -i -e "s/\/home\/matt/\/home\/$(whoami)/g" "{}" \;

    # Fix mason symlinks
    for link in ~/.local/share/nvim/mason/bin/*; do
        new_target=$(readlink "$link" | sed "s/matt/$(whoami)/g")
        ln -fs "$new_target" "$link"
    done
else
    # Install zsh plugins
    /bin/zsh -c "source ~/.zshrc && omz update"
    /bin/zsh -c "source ~/.zshrc && /.tmux/plugins/tpm/bin/install_plugins'"
    /bin/zsh -c "source ~/.zshrc && nvim --headless '+Lazy! sync' +qa"
    # TODO install mason plugins
fi

