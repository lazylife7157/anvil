#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace


PYTHON_VERSION=3.7.3
PLATFORM=`uname -s`
[`whoami` != "root"] && sudo="sudo" || sudo=""


initialize_arch() {
    pacman -Sy --needed --noconfirm git
    if [ ! -x "$(command -v yay)"]; then
        YAY_DIR=${HOME}/.yay
        git clone https://aur.archlinux.org/yay.git ${YAY_DIR}
        cd ${YAY_DIR}
        makepkg -si
        cd ..
        rm -rf ${YAY_DIR}
    fi

    pacman -Sy --needed --noconfirm tmux exa fd yarn neovim tig

    pacman -Sy --needed --noconfirm libglvnd xf86-video-nouveau mesa
    pacman -Sy --needed --noconfirm sway swayidle swaylock

    pacman -Sy --needed --noconfirm alacritty firefox
    yay -Sy --needed --noconfirm ttf-d2coding
}

initialize_debian() {
    ${sudo} apt-add-repository -y ppa:neovim-ppa/stable
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | ${sudo} apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | ${sudo} tee /etc/apt/sources.list.d/yarn.list
    ${sudo} apt-get update
    ${sudo} apt-get install -y build-essential git tmux neovim tig
    ${sudo} apt-get install -y --no-install-recommends yarn
    cargo install exa fd
}

initialize_osx() {
    brew install git tmux exa fd yarn neovim tig
    brew cask install alacritty
}

initialize() {
    [ -x "$(command -v pacman)" ] && pacman -Sy --needed --noconfirm base-devel

    curl https://sh.rustup.rs -sSf | sh

    curl https://pyenv.run | bash
    export PATH="${PATH}:${HOME}/.pyenv/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv install ${PYTHON_VERSION}
    pyenv global ${PYTHON_VERSION}

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install node

    if [ "$PLATFORM" == "Linux" ]; then
        if [ -x "$(command -v pacman)" ]; then
            initialize_arch
        elif [ -x "$(command -v apt-get)" ]; then
            initialize_debian
        fi
    elif [ "$PLATFORM" == "Darwin" ]; then
        initialize_osx
    fi

    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
}

install_anvil() {
    git clone https://github.com/lazylife7157/anvil ${HOME}/.anvil
}


initialize
install_anvil
cd ${HOME}/.anvil
bash forge --all
