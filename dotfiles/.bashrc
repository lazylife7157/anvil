for file in `ls ${HOME}/.bashrc.d`;
do
    source "${HOME}/.bashrc.d/${file}"
done


# Functions
# ----------------------------------------------------------------------------

path() {
    [ ! "${PATH}" == "*${1}*" ] && export PATH="${PATH}:${1}"
}

src() {
    [ -f "${1}" ] && source ${1}
}


# Environment variables
# ----------------------------------------------------------------------------

export EDITOR=vi
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

path "${HOME}/.anvil/bin"
path "${HOME}/.cargo/bin"
path "${HOME}/.pyenv/bin"
[ -x "$(command -v yarn)" ] && path `yarn global bin 2>/dev/null`


# Aliases
# ----------------------------------------------------------------------------

[ -x "$(command -v vim)" ] && alias vi='vim'
[ -x "$(command -v nvim)" ] && alias vi='nvim'
[ -x "$(command -v exa)" ] && alias ls='exa'
[ -x "$(command -v fd)" ] && alias find='fd'

alias l='ls -alF'
alias ll='ls -l'


# Prompt
# ----------------------------------------------------------------------------

## Right aligned bash-git-prompt
if [ -f "${HOME}/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=Custom
    GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
    source ~/.bash-git-prompt/gitprompt.sh

    __prompt_command() {
        local repo=$(git rev-parse --show-toplevel 2> /dev/null)

        if [[ -e "${repo}" ]]; then
            setGitPrompt
            BGP="${PS1//$\{GIT_BRANCH\}/${GIT_BRANCH}}"
            BGP="${BGP//\\[\[\]]/}"
            BGP_STRIPPED="${BGP//\\033\[[0-1];[0-9][0-9]m/}"
            BGP_STRIPPED="${BGP_STRIPPED//\\033\[0;0m/}"

            printf "\e[${COLUMNS:-$(tput cols)}C\e[${#BGP_STRIPPED}D${BGP}\r"
        fi

        PS1=' \[\e[1;34m\]\w\[\e[m\] \$ '
    }

    PROMPT_COMMAND='setLastCommandState;__prompt_command'
fi


# Completions
# ----------------------------------------------------------------------------

if [ -d "${HOME}/.bash_completion.d" ]; then
    for file in `ls ~/.bash_completion.d`; do
        src "${HOME}/.bash_completion.d/${file}"
    done
fi


# Pyenv
# ----------------------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# NVM
# ----------------------------------------------------------------------------
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion


# FZF
# ----------------------------------------------------------------------------
src "${HOME}/.fzf.bash"
