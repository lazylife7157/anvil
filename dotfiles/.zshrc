# Geometry config
GEOMETRY_SYMBOL_PROMPT="$"
GEOMETRY_SYMBOL_RPROMPT="%"                 # multiline prompts
GEOMETRY_SYMBOL_EXIT_VALUE="?"              # displayed when exit value is != 0
GEOMETRY_SYMBOL_ROOT="#"

GEOMETRY_PROMPT_PREFIX=""

PROMPT_GEOMETRY_EXEC_TIME="true"            # show a time display for long-running commands
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME="1"   # time display threshold

PROMPT_GEOMETRY_PROMPT_ASYNC="true"
PROMPT_GEOMETRY_GIT_TIME="true"             # turn this off if prompt is slow on large repos.


source ~/.zplug/init.zsh

zplug "geometry-zsh/geometry", as:theme

if ! zplug check --verbose; then
    zplug install
fi

zplug load


export LC_ALL=en_US.UTF-8


add_path()
{
    if [[ ! "$PATH" == *$1* ]]; then
        export PATH="$PATH:$1"
    fi
}

add_path $HOME/.cargo/bin
add_path $HOME/.anvil/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"
[ -x "$(command -v vim)" ] && alias vi=vim

