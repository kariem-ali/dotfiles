export BASH_SILENCE_DEPRECATION_WARNING=1
export HOME=/home/kariem/
. ~/Projects/dotfiles/bash/env.win32
. ~/Projects/dotfiles/bash/config
. ~/Projects/dotfiles/bash/git-prompt.sh
. ~/Projects/dotfiles/bash/prompt
. ~/Projects/dotfiles/bash/aliases
#. /etc/profile.d/maven.sh
#. "$HOME/.cargo/env"
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
