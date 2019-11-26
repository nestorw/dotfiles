#
# vi command prompt
#
#set -o vi

#
# Homebrew
#
if [[ `uname -s` == 'Darwin' ]]; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

#
# Colorful terminal
#
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad


#
# Prompt
#
function __ruby_version {
  rbv=`rvm-prompt`
  rbv=${rbv#ruby-}
  [[ $rbv == *"@"* ]] || rbv="${rbv}@default"
  echo $rbv
}

function git_dirty {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "♦ "
}
NO_C='\[\033[00m\]'
GREEN='\[\033[00;32m\]'
CYAN='\e[0;36m'
RED='\e[0;91m'
GRAY='\e[0;90m'
BLUE='\[\033[00;34m\]'
YELLOW='\[\033[00;33m\]'
GITBRANCH='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)/```'


export PS1="$GRAY\u@\h$NO_C[$YELLOW$GITBRANCH$RED\$(git_dirty)\$(__ruby_version)$NO_C]\n$BLUE\w$NO_C $ "
#export PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 6)\]\h\[$(tput setaf 4)\][\[$(tput setaf 2)\]\W\[$(tput setaf 4)\]]\\$ \[$(tput sgr0)\]"

#
# Export
#
export AUTOFEATURE=true
export EDITOR='vim'
export ANDROID_HOME=/usr/local/opt/android-sdk

#
# Alias
#
if command -v lsb_release &>/dev/null ; then
  distribution=$(lsb_release -i)
  if [[ "$distribution" =~ Ubuntu ]]; then
    alias upgrade='sudo aptitude update && sudo aptitude safe-upgrade'
  fi
fi
alias dotfiles='cd ~/dotfiles'
alias rake='bundle exec rake'
alias cucumber='bundle exec cucumber'
alias rspec='bundle exec rspec'
alias cap='bundle exec cap'
alias g='git status'

#
# Git autocomplete
#
source ~/dotfiles/git-complete.sh

#
# Docker Aliases
#
source ~/dotfiles/docker-alias.sh

#
# For custom scripts
#
export PATH=~/dotfiles/bin:~/sync/bin:$PATH

#
# npm
#
export NODE_PATH="/usr/local/lib/node"

export PATH=/usr/local/share/npm/bin:$PATH

#
# Custom cds
#
_complete() {
  local cur folders
  COMREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  folders=`ls ~/prog/${1}/`
  if [[ ${#COMP_WORDS[@]} -le 2 ]]; then
    COMPREPLY=( $(compgen -W "${folders}" -- ${cur}) )
    return 0
  fi
}

_dcd() {
  _complete divbot
}
dcd() {
  cd ~/prog/divbot/$1
}
complete -F _dcd dcd

_scd() {
  _complete sls
}
scd() {
  cd ~/prog/sls/$1
}
complete -F _scd scd

_srcd() {
  _complete src
}
srcd() {
  cd ~/prog/src/$1
}
complete -F _srcd srcd

_complete_ssh_hosts ()
{
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
    cut -f 1 -d ' ' | \
    sed -e s/,.*//g | \
    grep -v ^# | \
    uniq | \
    grep -v "\[" ;
  cat ~/.ssh/config | \
    grep "^Host " | \
    awk '{print $2}'
  `
  COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
  return 0
}
complete -F _complete_ssh_hosts ssh
