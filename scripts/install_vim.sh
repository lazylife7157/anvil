#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

PLATFORM=`uname -s`

install_vim_plugins() {
    if [ ! -f "~/.config/nvim/autoload/plug.vim" ]; then
        curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    pip3 install --user pynvim
    nvim -c PlugInstall -c UpdateRemotePlugins -c qa!
}

if [ "$PLATFORM" == "Linux" ]; then
    pacman -S neovim
elif [ "$PLATFORM" == "Darwin" ]; then
    brew install neovim
fi

install_vim_plugins
