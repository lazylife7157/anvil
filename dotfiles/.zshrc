export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="custom"
plugins=(colored-man-pages)
source $ZSH/oh-my-zsh.sh


# Environment variables
# ----------------------------------------------------------------------------

export EDITOR=vi
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Aliases
# ----------------------------------------------------------------------------

command -v eza &>/dev/null && alias ls='eza'
command -v fd  &>/dev/null && alias find='fd'

alias l='ls -alF'
alias ll='ls -l'


# FZF
# ----------------------------------------------------------------------------

command -v fzf &>/dev/null && source <(fzf --zsh)
