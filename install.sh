#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive

NVIM_APPIMAGE="/opt/nvim.appimage"
DFUSER=dfuser
PACKAGES_DIR="packages"
FINAL_DOTFILE_PACKAGE="dotfiles.tar.gz"

DEFAULT_TAR_EXCLUDES=(--exclude='*.pyc' --exclude='*.log')

declare -a PACKAGES

# Array of (local path, tarball, sudo) pairs. Paths are relative to $HOME
PACKAGES[0]=".local/share/fonts;fonts.tar.gz;0"
PACKAGES[1]=".oh-my-zsh;oh-my-zsh.tar.gz;0"
PACKAGES[2]=".tmux;tmux.tar.gz;0"
PACKAGES[3]=".nvm;nvm.tar.gz;0"
PACKAGES[4]=".cabal;cabal.tar.gz;0"
PACKAGES[5]=".local/share/nvim;nvim.tar.gz;0"
PACKAGES[6]="$NVIM_APPIMAGE;nvim-app.tar.gz;1"
PACKAGES[7]="/usr/local/go;go.tar.gz;1"
# TODO: $GOMODCACHE?

echo "IN_DOCKER? $IN_DOCKER"


create_package () {
    build_dir="$(mktemp -d)"
    packages_full_dir="$build_dir/dotfiles/$PACKAGES_DIR"

    # Clear out the existing packeg if it exists
    rm -rf "$FINAL_DOTFILE_PACKAGE"

    # Add dotfiles to the build
    cp -r "$(pwd)" "$build_dir"

    # Create the packages dir
    mkdir -p "$packages_full_dir"

    for package in "${PACKAGES[@]}"; do
        IFS=";" read -r -a arr <<< "${package}"

        dir_path="${arr[0]}"
        tar_path="$PACKAGES_DIR/${arr[1]}"

        tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" -czf "$packages_full_dir/$tar_path" "$dir_path"
    done

    # Build final package
    tar -C "$build_dir" -czf "$FINAL_DOTFILE_PACKAGE" "dotfiles"
    echo "Done packing: $FINAL_DOTFILE_PACKAGE"
}

unpack_package() {
    for package in "${PACKAGES[@]}"; do
        IFS=";" read -r -a arr <<< "${package}"

        tar_path="$PACKAGES_DIR/${arr[1]}"
        use_sudo="${arr[2]}"

        if [ "$use_sudo" -eq 1 ]; then
            sudo_cmd="sudo"
        else
            sudo_cmd=""
        fi

        "$sudo_cmd" tar -xf "$PACKAGES_DIR/tar_path" -C "$HOME"
    done

    echo "Done unpacking"
}

fixup_mason () {
    if [ "$(whoami)" != "$DFUSER" ]; then
        # Mason installs packages in a way that some of them will reference /home/$DFUSER instead of ~.
        # This command is a little risky, but so far it works
        find ~/.local/share/nvim \
            -type f -exec sed -i -e "s/\/home\/$DFUSER/\/home\/$(whoami)/g" "{}" \;

        # Fix mason symlinks
        for link in ~/.local/share/nvim/mason/bin/*; do
            new_target=$(readlink "$link" | sed "s/$DFUSER/$(whoami)/g")
            ln -fs "$new_target" "$link"
        done
    fi

}

install_apt_packages () {
    sudo apt-get update

    sudo apt-get install -y \
        unzip \
        wget \
        xclip \
        xsel \
        lua5.1 \
        liblua5.1-dev \
        ripgrep \
        python3 \
        python3-pip \
        python3-venv \
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
}

install_pip_packages () {
    python3 -m pip install \
        neovim \
        pylint \
        pycodestyle \
        robotframework-robocop \
        black
}

install_manual_deps () {
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share/fonts"

    # Install the nerd font
    wget -O "/tmp/CascadioCodeNerd.zip" \
        'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip'
    unzip "/tmp/CascadioCodeNerd.zip" -d "$HOME/.local/share/fonts"

    # install ohmyzsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # zsh-syntax highlighting and autosuggustion plugins aren't available via ohmyzsh for some reason
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    # install luarocks
    wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
    tar -zxpf luarocks-3.11.1.tar.gz
    pushd luarocks-3.11.1
    ./configure && make && sudo make install
    popd
    rm -rf luarocks*

    # install go
    wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
    rm go1.23.0.linux-amd64.tar.gz

    # install nvm (nodejs installer)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    nvm install node

    # install tpm (tmux plugin manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # install ghcup (haskell version manager)
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
        BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest \
        BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 \
        BOOTSTRAP_HASKELL_INSTALL_HLS=0 BOOTSTRAP_HASKELL_ADJUST_BASHRC=0 sh
    source "$HOME/.ghcup/env"

    # install nvim
    wget -O /tmp/nvim.appimage 'https://github.com/neovim/neovim/releases/latest/download/nvim.appimage'
    chmod +x /tmp/nvim.appimage
    sudo mv /tmp/nvim.appimage "$NVIM_APPIMAGE"
}

fixup_nvim () {
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
}

link_dotfiles () {
    ln -fs "$(pwd)/zshrc" ~/.zshrc
    ln -fs "$(pwd)/tmux.conf" ~/.tmux.conf
    ln -fs "$(pwd)/nvim" ~/.config/nvim
}

install_plugins () {
    # Install plugins using zsh so that all the env variables are correct
    /bin/zsh -c "source ~/.zshrc ; omz update"
    /bin/zsh -c "source ~/.zshrc ; ~/.tmux/plugins/tpm/bin/install_plugins"
    /bin/zsh -c "source ~/.zshrc ; nvim --headless '+Lazy! sync' +qa"
    /bin/zsh -c "source ~/.zshrc ; nvim --headless '+MasonInstallAll' +qa"
    /bin/zsh -c "source ~/.zshrc ; nvim --headless '+MasonToolsInstallSync' +qa"
}

online_install () {
    install_apt_packages
    install_pip_packages
    install_manual_deps
    fixup_nvim
    link_dotfiles
    install_plugins
}

if [ "$#" -eq 0 ]; then
    online_install
    exit
elif [ "$1" = "package" ]; then
    create_package
elif [ "$1" = "unpack" ]; then
    # Offline install still assumes there is a pip and apt mirror
    install_apt_packages
    install_pip_packages
    unpack_package
    fixup_nvim
    fixup_mason
    link_dotfiles
else
    echo "Invalid command: $1"
fi
