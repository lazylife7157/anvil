#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

PLATFORM=`uname -s`

if [ "$PLATFORM" == "Linux" ]; then
    pacman -S alacritty
elif [ "$PLATFORM" == "Darwin" ]; then
    brew cask install alacritty

    # Manual Page
    wget https://raw.githubusercontent.com/jwilm/alacritty/master/alacritty.man
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    rm alacritty.man

    # Bash Completion
    mkdir -p ~/.bash_completion
    wget https://raw.githubusercontent.com/jwilm/alacritty/master/alacritty-completions.bash
    mv alacritty-completions.bash ~/.bash_completion/

    # Terminfo
    wget https://raw.githubusercontent.com/jwilm/alacritty/master/alacritty.info
    sudo tic -e alacritty,alacritty-direct alacritty.info
    rm alacritty.info
fi
