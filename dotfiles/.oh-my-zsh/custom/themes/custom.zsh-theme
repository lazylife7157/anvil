local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ%s)"

function get_pwd(){
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

function git_prompt() {
    local EMPTY_PROMPT=""
    local __GIT_STATUS_CMD="${HOME}/.bash-git-prompt/gitstatus.sh"
    local -a git_status_fields
    while IFS=$'\n' read -r line; do git_status_fields+=("${line}"); done < <("${__GIT_STATUS_CMD}" 2>/dev/null)

    local GIT_BRANCH="${git_status_fields[1]}"
    local GIT_REMOTE="${git_status_fields[2]}"
    if [[ "." == "${GIT_REMOTE}" ]] || [[ "_NO_REMOTE_TRACKING_" == "${GIT_REMOTE}" ]]; then
        unset GIT_REMOTE
    fi
    local GIT_REMOTE_USERNAME_REPO="${git_status_fields[3]}"
    if [[ "." == "${GIT_REMOTE_USERNAME_REPO}" ]]; then
        unset GIT_REMOTE_USERNAME_REPO
    fi

    local GIT_STAGED="${git_status_fields[5]}"
    local GIT_CONFLICTS="${git_status_fields[6]}"
    local GIT_CHANGED="${git_status_fields[7]}"
    local GIT_UNTRACKED="${git_status_fields[8]}"
    local GIT_STASHED="${git_status_fields[9]}"
    local GIT_CLEAN="${git_status_fields[10]}"

    local GIT_PROMPT_STAGED="%{$fg[red]%}●"
    local GIT_PROMPT_CONFLICTS="%{$fg[red]%}✖"
    local GIT_PROMPT_CHANGED="%{$fg[blue]%}✚"
    local GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}…"
    local GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
    local GIT_PROMPT_CLEAN="%{$fg[green]%}✓"

    local NEW_PROMPT="${EMPTY_PROMPT}"
    if [[ "${#git_status_fields[@]}" -gt 0 ]]; then

        local STATUS=""

        # __add_status KIND VALEXPR INSERT
        # eg: __add_status  'STAGED' '-ne 0'

        __chk_gitvar_status() {
            local v
            if [[ "${2-}" = "-n" ]] ; then
                v="${2} \"\${GIT_${1}-}\""
            else
                v="\${GIT_${1}-} ${2}"
            fi
            if eval "[[ ${v} ]]" ; then
                if [[ "${3-}" != '-' ]]; then
                    __add_status " \${GIT_PROMPT_${1}}\${GIT_${1}}%{$reset_color%}"
                else
                    __add_status " \${GIT_PROMPT_${1}}%{$reset_color%}"
                fi
            fi
        }

        # __add_status SOMETEXT
        __add_status() {
            eval "STATUS=\"${STATUS}${1}\""
        }

        __chk_gitvar_status 'REMOTE'       '-n'
        if [[ "${GIT_CLEAN}" -eq "0" ]] || [[ "${GIT_PROMPT_CLEAN}" != "" ]]; then
            __add_status ""
            __chk_gitvar_status 'STAGED'     '!= "0" && ${GIT_STAGED-} != "^"'
            __chk_gitvar_status 'CONFLICTS'  '!= "0"'
            __chk_gitvar_status 'CHANGED'    '!= "0"'
            __chk_gitvar_status 'UNTRACKED'  '!= "0"'
            __chk_gitvar_status 'STASHED'    '!= "0"'
            __chk_gitvar_status 'CLEAN'      '= "1"'   -
        fi

        NEW_PROMPT="[ %{$fg[blue]%}${GIT_BRANCH}%{$reset_color%}${STATUS} ]"
        NEW_PROMPT=${NEW_PROMPT//_PREHASH_/:}
        NEW_PROMPT=${NEW_PROMPT//_AHEAD_/↑}
        NEW_PROMPT=${NEW_PROMPT//_BEHIND_/↓}
        NEW_PROMPT="${NEW_PROMPT} "
    else
        NEW_PROMPT="${EMPTY_PROMPT}"
    fi

    echo "${NEW_PROMPT}"
}

PROMPT='$ret_status %{$fg[white]%}$(get_pwd) $(git_prompt)%{$reset_color%}%{$reset_color%}'
