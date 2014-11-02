K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

function get_git_branch()
{
  if [ -d .git ]; then
    echo "(`git branch | grep "^\*" | cut -c3-`)"
  fi
}

function get_time()
{
  echo "`date +%H:%M:%S`"
}

PS1="${G}\u@\h:${Y}\W${W}\$(get_git_branch)\n\\$ ${W}"

# zsh-style auto-complete (cycle through options).
bind 'TAB:menu-complete'

vim="/c/Program\ Files\ \(x86\)/vim/vim74/vim.exe"
export EDITOR=$vim
export HOME="/c/Users/Kariem"

# Fix git 'WARNING: terminal is not fully functional'. Happens
# due to strawberry perl setting a global env. variable TERM=dump
export TERM=msys 

export PATH=/c/utils/gnuwin32/bin:\
/c/utils/git/bin:\
/c/Chocolatey/bin:\
/c/Chocolatey/lib/Git-TF.2.0.3.20131219/Tools/git-tf-2.0.3.20131219:\
/c/utils/git-tfs:\
~/Projects/Bash:\
/c/RailsInstaller/Ruby1.9.3/bin:\
/c/utils:\
/c/utils/far:\
/c/utils/miktex/miktex/bin:\
/c/Program\ Files/nodejs:\
/c/Users/Kariem/AppData/Roaming/npm:\
/c/Users/Kariem/AppData/Roaming/scriptcs:\
/c/Users/Kariem/AppData/Local/Pandoc:\
/c/windows:\
/c/windows/system32:\
/c/windows/System32/Wbem:\
/c/windows/System32/WindowsPowerShell/v1.0/:\
/c/Program\ Files/Microsoft/Web\ Platform\ Installer/:\
/c/Program\ Files\ \(x86\)/Microsoft\ ASP.NET/ASP.NET\ Web\ Pages/v1.0/:\
/c/Program\ Files\ \(x86\)/Windows\ Kits/8.1/Windows\ Performance\ Toolkit/:\
/c/Program\ Files/Microsoft\ SQL\ Server/110/Tools/Binn/:\
/c/Windows/Microsoft.NET/Framework/v4.0.30319/:\
/c/Program\ Files\ \(x86\)/Microsoft\ SDKs/F#/3.1/Framework/v4.0:\
/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 12.0/Common7/IDE

function subl() {
  /c/Program\ Files/Sublime\ Text\ 2/sublime_text.exe -w "$@" &
}

function view() {
   $vim -M "$*"
}

function run_ssh_agent() {
  eval `ssh-agent -s`   # Run the SSH agent
  ssh-add /.ssh/id_rsa  # Add the SSH key
}

alias browse='/c/program\ files/internet\ explorer/iexplore.exe'
alias firefox='/c/Program\ Files\ \(x86\)/Mozilla\ Firefox/firefox.exe'
alias e=subl
alias vi=$vim
alias vim=$vim
