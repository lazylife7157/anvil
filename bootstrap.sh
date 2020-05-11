#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace


PYTHON_VERSION=3.8.2
TMUX_VERSION=3.1b
PLATFORM=`uname -s`
[ `whoami` != "root" ] && sudo="sudo" || sudo=""


install_rust() {
    if [ ! -x "$(command -v rustup)" ]; then
        curl https://sh.rustup.rs -sSf | sh
        export PATH=${PATH}:${HOME}/.cargo/bin
    fi
}

install_python() {
    VERSION=${1}
    if [ ! -d "${HOME}/.pyenv" ]; then
        curl https://pyenv.run | bash
        export PATH="${PATH}:${HOME}/.pyenv/bin"
        eval "$(pyenv init -)"
        pyenv install ${VERSION}
        pyenv global ${VERSION}
    fi
}

install_node() {
    if [ ! -d "${HOME}/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        nvm install node
    fi
}

install_tmux() {
    VERSION=${1}
    pushd .
    cd ~
    wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
    tar xf tmux-${VERSION}.tar.gz
    rm -f tmux-${VERSION}.tar.gz
    cd tmux-${VERSION}
    ./configure
    make
    ${sudo} make install
    cd -
    ${sudo} rm -rf /usr/local/src/tmux-\*
    ${sudo} mv tmux-${VERSION} /usr/local/src
    popd
}

initialize_arch() {
    pacman -Sy --needed --noconfirm base-devel

    install_rust
    install_python ${PYTHON_VERSION}
    install_node

    pacman -Sy --needed --noconfirm git
    if [ ! -x "$(command -v yay)"]; then
        YAY_DIR=${HOME}/.yay
        git clone https://aur.archlinux.org/yay.git ${YAY_DIR}
        cd ${YAY_DIR}
        makepkg -si
        cd ..
        rm -rf ${YAY_DIR}
    fi

    pacman -Sy --needed --noconfirm zsh
    chsh -s /bin/zsh

    pacman -Sy --needed --noconfirm exa fd yarn neovim tig

    pacman -Sy --needed --noconfirm libglvnd xf86-video-nouveau mesa
    pacman -Sy --needed --noconfirm sway swayidle swaylock

    pacman -Sy --needed --noconfirm alacritty firefox

    yay -Sy --needed --noconfirm ttf-d2coding
}

initialize_debian() {
    locale-gen en_US.UTF-8

    ${sudo} apt purge -y tmux
    ${sudo} apt update
    ${sudo} apt install -y gpg-agent
    ${sudo} apt install -y apt-transport-https

    ${sudo} apt-add-repository -y ppa:neovim-ppa/stable
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | ${sudo} apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | ${sudo} tee /etc/apt/sources.list.d/yarn.list

    ${sudo} apt update
    ${sudo} apt install -y zsh
    chsh -s /bin/zsh

    ${sudo} apt install -y \
        cmake tar libevent-dev libncurses-dev \
        neovim tig
    ${sudo} apt install -y --no-install-recommends yarn
    ${sudo} apt autoremove -y

    install_rust
    install_node

    cargo install exa fd-find
}

initialize_osx() {
    brew install git wget exa fd yarn neovim tig
    brew cask install alacritty

    install_rust
    install_python ${PYTHON_VERSION}
    install_node
}

initialize() {
    if [ "$PLATFORM" == "Linux" ]; then
        if [ -x "$(command -v pacman)" ]; then
            initialize_arch
        elif [ -x "$(command -v apt-get)" ]; then
            initialize_debian
        fi
    elif [ "$PLATFORM" == "Darwin" ]; then
        initialize_osx
    fi

    install_tmux ${TMUX_VERSION}

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_anvil() {
    git clone https://github.com/lazylife7157/anvil ${HOME}/.anvil
}


initialize
install_anvil
cd ${HOME}/.anvil
bash forge --all
