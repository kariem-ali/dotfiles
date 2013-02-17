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
    echo " (`git branch | grep "^\*" | cut -c3-`)"
  fi
}

PS1="${G}\u@\h:${Y}\w${W}\$(get_git_branch)$ ${W}"

# zsh-style auto-complete (cycle through options).
bind 'TAB:menu-complete'

export PATH=/c/utils/gnuwin32/bin:\
/c/utils/git/bin:\
~/Projects/Bash:\
/c/RailsInstaller/Ruby1.9.3/bin:\
/c/utils/far:\
/c/Program\ Files/nodejs:\
/c/Users/Kariem/AppData/Roaming/npm:\
/c/windows/system32:\
/c/windows:\
/c/windows/System32/Wbem:\
/c/windows/System32/WindowsPowerShell/v1.0/:\
/c/Program\ Files/Microsoft/Web\ Platform\ Installer/:\
/c/Program\ Files\ \(x86\)/Microsoft\ ASP.NET/ASP.NET\ Web\ Pages/v1.0/:\
/c/Program\ Files\ \(x86\)/Windows\ Kits/8.0/Windows\ Performance\ Toolkit/:\
/c/Program\ Files/Microsoft\ SQL\ Server/110/Tools/Binn/:\
/c/Users/Kariem/AppData/Roaming/npm/:\
/c/Program\ Files/TortoiseHg/:\
/c/Windows/Microsoft.NET/Framework/v4.0.30319/:\
/c/Chocolatey/lib/ctags.5.8.1/tools/:\
/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 11.0/Common7/IDE

EDITOR="/usr/bin/vi"
HOME="/c/Users/Kariem"

function subl() {
  /c/Program\ Files/Sublime\ Text\ 2/sublime_text.exe -w $@ &
}
alias firefox='/c/Program\ Files\ \(x86\)/Mozilla\ Firefox/firefox.exe'
alias e=subl
