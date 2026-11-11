# ~/.bashrc: read by interactive non-login bash shells (and by ~/.profile for login shells).

# Only interactive shells need anything below (prompt, key bindings, aliases).
case $- in
  *i*) ;;
  *) return ;;
esac

# Folder holding this repo, found by following this file's symlink.
DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

# --- History -----------------------------------------------------------------
HISTCONTROL=ignoreboth          # skip duplicates and lines starting with a space
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend             # append, so terminals don't overwrite each other
shopt -s checkwinsize           # keep LINES/COLUMNS correct after resizes

# --- Ubuntu basics -----------------------------------------------------------
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Modules from this repo ---------------------------------------------------
. "$DOTFILES/bash/env"
. "$DOTFILES/bash/config"
. "$DOTFILES/bash/git-prompt.sh"
. "$DOTFILES/bash/prompt"
. "$DOTFILES/bash/aliases"

# --- Node (nvm) ----------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- Machine-specific settings (not in the repo) --------------------------------
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
