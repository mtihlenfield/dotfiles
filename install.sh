#!/bin/bash
set -xe

export DEBIAN_FRONTEND=noninteractive
export GOMODCACHE=~/.go

NVIM_APPIMAGE="/opt/nvim.appimage"
HADOLINT_BIN="/opt/hadolint"
DFUSER=dfuser
PACKAGES_DIR="packages"
FINAL_DOTFILE_PACKAGE="dotfiles.tar.gz"

DEFAULT_TAR_EXCLUDES=(--exclude='*.pyc' --exclude='*.log')

declare -a PACKAGES

# Array of (local path, tarball, global) pairs. Paths are relative to $HOME
# NOTE: Global assumes the path is relative to / and will require sudo
PACKAGES[0]=".local/share/fonts;fonts.tar.gz;0"
PACKAGES[1]=".oh-my-zsh;oh-my-zsh.tar.gz;0"
PACKAGES[2]=".tmux;tmux.tar.gz;0"
PACKAGES[3]=".nvm;nvm.tar.gz;0"
PACKAGES[4]=".local/share/nvim;nvim.tar.gz;0"
PACKAGES[5]="$NVIM_APPIMAGE;nvim-app.tar.gz;1"
PACKAGES[6]="$HADOLINT_BIN;hadolint-app.tar.gz;1"
PACKAGES[7]="/usr/local/go;go.tar.gz;1"

echo "IN_DOCKER? $IN_DOCKER"


create_package () {
    build_dir="$(mktemp -d)"

    # Clear out the existing packeg if it exists
    rm -rf "$FINAL_DOTFILE_PACKAGE"

    # Add dotfiles to the build
    cp -r "$(pwd)" "$build_dir"

    # Create the packages dir
    packages_full_dir="$build_dir/dotfiles/$PACKAGES_DIR"
    mkdir -p "$packages_full_dir"

    for package in "${PACKAGES[@]}"; do
        IFS=";" read -r -a arr <<< "${package}"

        dir_path="${arr[0]}"
        tar_path="$packages_full_dir/${arr[1]}"
        global="${arr[2]}"

        if [ "$global" -eq 1 ]; then
            tar "${DEFAULT_TAR_EXCLUDES[@]}" -C / -czf "$tar_path" "$dir_path"
        else
            tar "${DEFAULT_TAR_EXCLUDES[@]}" -C "$HOME" -czf "$tar_path" "$dir_path"
        fi

    done

    # Build final package
    tar -C "$build_dir" -czf "$FINAL_DOTFILE_PACKAGE" "dotfiles"
    echo "Done packing: $FINAL_DOTFILE_PACKAGE"
}

unpack_package() {
    mkdir -p ~/.config

    for package in "${PACKAGES[@]}"; do
        IFS=";" read -r -a arr <<< "${package}"

        tar_path="$PACKAGES_DIR/${arr[1]}"
        global="${arr[2]}"

        if [ "$global" -eq 1 ]; then
            sudo tar -xf "$tar_path" -C /
        else
            tar -xf "$tar_path" -C "$HOME"
        fi
    done
}

fixup_mason () {
    if [ "$(whoami)" != "$DFUSER" ]; then
        # Mason installs packages in a way that some of them will reference /home/$DFUSER instead of ~.
        # This command is a little risky, but so far it works
        find ~/.local/share/nvim/mason \
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

    # install hadolint
    wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
    chmod +x hadolint-Linux-x86_64
    sudo mv hadolint-Linux-x86_64 /opt/hadolint

    # install nvim
    wget -O /tmp/nvim.appimage 'https://github.com/neovim/neovim/releases/latest/download/nvim.appimage'
    chmod +x /tmp/nvim.appimage
    sudo mv /tmp/nvim.appimage "$NVIM_APPIMAGE"
}

link_binaries () {
    # appimages require fuse file system support, which we won't have
    # in a docker container. So instead we extract the contents of the
    # appimage
    if [[ -v IN_DOCKER ]]; then
        sudo "$NVIM_APPIMAGE" --appimage-extract

        sudo mv squashfs-root /opt/nvim
        sudo ln -s /opt/nvim/AppRun /usr/bin/nvim
    else
        sudo ln -s "$NVIM_APPIMAGE" /usr/bin/nvim
    fi

    sudo ln -s "$HADOLINT_BIN" /usr/bin/hadolint
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
    link_binaries
    link_dotfiles
    install_plugins
}

offline_install () {
    # Offline install still assumes there is a pip and apt mirror
    install_apt_packages
    install_pip_packages
    unpack_package
    link_binaries
    fixup_mason
    link_dotfiles
}

if [ "$#" -eq 0 ]; then
    online_install
elif [ "$1" = "package" ]; then
    create_package
elif [ "$1" = "unpack" ]; then
    if [ ! -d "$PACKAGES_DIR" ]; then
        echo "Missing $PACKAGES_DIR dir!"
        exit 1
    fi

    offline_install
else
    echo "Invalid command: $1"
fi
