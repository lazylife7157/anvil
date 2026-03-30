local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ%s)"

function get_pwd() {
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

ZSH_THEME_GIT_PROMPT_PREFIX="[ %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[blue]%}✚"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg[blue]%}✚"
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[cyan]%}…"
ZSH_THEME_GIT_PROMPT_STASHED=" %{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_AHEAD=" ↑"
ZSH_THEME_GIT_PROMPT_BEHIND=" ↓"

function _git_section() {
  local info=$(git_prompt_info)
  [[ -z "$info" ]] && return
  echo "${info}$(git_prompt_status)%{$reset_color%} ] "
}

PROMPT='$ret_status %{$fg[white]%}$(get_pwd) $(_git_section)%{$reset_color%}'
