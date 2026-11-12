#!/usr/bin/env bash
# Install these dotfiles (bash, vim, git) by symlinking them into your home folder. See README.md.
#
# Usage: ./install.sh [--dry-run] [--no-packages] [--home DIR]
#   --dry-run      show what would be done; change nothing, download nothing
#   --no-packages  don't install apt packages (you install them yourself)
#   --home DIR     install into DIR instead of $HOME, for testing (implies --no-packages;
#                  vim-plug and the plugins are installed into DIR too)
#   -h, --help     show this help
#
# Each file is linked on its own (never a whole folder), so ~/.vim/plugged and other state stay
# out of the repo. An existing file that differs is kept as <name>.bak-<timestamp>.
# Safe to run again: links that are already right are left alone.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
DRY=0 PACKAGES=1 HOME_ARG=
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) DRY=1 ;;
        --no-packages) PACKAGES=0 ;;
        --home) [ $# -ge 2 ] || { echo "--home needs a folder" >&2; exit 2; }; HOME_ARG=$2; shift ;;
        -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
        *) echo "Unknown option: $1 (see --help)" >&2; exit 2 ;;
    esac
    shift
done

REAL_HOME="$(cd "$HOME" && pwd)"               # normalised (no trailing /)
if [ -z "$HOME_ARG" ]; then
    TARGET=$REAL_HOME
else
    PACKAGES=0
    [ "$DRY" = 1 ] || mkdir -p "$HOME_ARG"
    TARGET="$(realpath -m -- "$HOME_ARG")"     # -m: a dry run doesn't create it
fi

# Scratch files for this run, removed on exit (also when interrupted). A dry run needs none.
WORK=
if [ "$DRY" = 0 ]; then
    WORK="$(mktemp -d -t dotfiles-install.XXXXXX)"
    trap 'rm -rf "$WORK"' EXIT
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
PACKAGE_LIST=(vim git curl bash-completion)
PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
PLUG_TIMEOUT=${PLUG_TIMEOUT:-600}             # seconds for installing all plugins

# Files to link: path in this repo = path under the home folder.
FILES=(.bashrc .inputrc .gitconfig .vimrc .ideavimrc .vim/syntax/cs.vim)
for f in "$HERE"/.vim/colors/*.vim; do FILES+=(".vim/colors/${f##*/}"); done

# Vim and git run with these unset, so the checks see only the target home's files.
CLEAN_ENV=(env -u VIMINIT -u GVIMINIT -u EXINIT -u MYVIMRC -u VIMRUNTIME -u XDG_CONFIG_HOME
    -u XDG_DATA_HOME -u XDG_CACHE_HOME -u XDG_STATE_HOME -u GIT_CONFIG -u GIT_CONFIG_GLOBAL
    -u GIT_CONFIG_SYSTEM -u GIT_CONFIG_NOSYSTEM -u GIT_CONFIG_COUNT -u GIT_CONFIG_PARAMETERS)

say()   { printf '\n==> %s\n' "$*"; }
show()  { printf '   %s\n' "${*//"$TARGET"/\~}"; }   # print with the target home shown as ~
fail()  { echo "   $*" >&2; }

# --- Checks before anything is changed ----------------------------------------
preflight() {
    local p d bad=0
    for p in "$HERE/.bashrc" "$HERE"/bash/*; do bash -n "$p" || bad=1; done
    [ "$bad" = 0 ] || { fail "Syntax error in the shell files above: nothing was changed"; exit 1; }
    # A symlinked folder on the way would send links, backups or downloads somewhere else
    # (e.g. an old ~/.vim -> repo link would put plugins into the repo).
    for d in .vim .vim/colors .vim/syntax .vim/autoload .vim/plugged; do
        if [ -L "$TARGET/$d" ]; then
            fail "$TARGET/$d is a symlink ($(readlink "$TARGET/$d")). Replace it with a real folder"
            fail "(move it aside and copy what you need), then run this again. Nothing was changed."
            exit 1
        fi
    done
}

# Move $1 aside as $1.bak-<stamp> (adding -2, -3 ... if that name is taken).
backup() {
    local dst=$1 bak="$1.bak-$STAMP" n=2
    while [ -e "$bak" ] || [ -L "$bak" ]; do bak="$1.bak-$STAMP-$n"; n=$((n + 1)); done
    if [ "$DRY" = 1 ]; then show "would back up $dst -> ${bak##*/}"; return 0; fi
    mv "$dst" "$bak"
    show "backed up $dst -> ${bak##*/}"
}

# Symlink $TARGET/$1 to $HERE/$1, backing up whatever differs.
link() {
    local src="$HERE/$1" dst="$TARGET/$1"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then return 0; fi   # already done
    if [ -e "$dst" ] || [ -L "$dst" ]; then                                   # incl. dangling links
        if [ -f "$dst" ] && [ ! -L "$dst" ] && cmp -s "$src" "$dst"; then
            [ "$DRY" = 1 ] || rm "$dst"           # identical copy: nothing to keep
        else
            backup "$dst"
        fi
    fi
    if [ "$DRY" = 1 ]; then show "would link $dst"; return 0; fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    show "linked $dst"
}

install_packages() {
    [ "$PACKAGES" = 1 ] || return 0
    local p missing=()
    for p in "${PACKAGE_LIST[@]}"; do
        dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q 'ok installed' || missing+=("$p")
    done
    [ ${#missing[@]} -gt 0 ] || return 0
    say "Installing packages: ${missing[*]}"
    command -v apt-get >/dev/null || { fail "apt-get not found: install ${missing[*]} yourself"; return 1; }
    if [ "$DRY" = 1 ]; then show "would run: sudo apt-get install -y ${missing[*]}"; return 0; fi
    sudo apt-get install -y "${missing[@]}"
}

retire_bash_profile() {
    # ~/.bash_profile stops bash from reading ~/.profile (which reads ~/.bashrc) in login shells.
    local bp="$TARGET/.bash_profile"
    if [ -e "$bp" ] || [ -L "$bp" ]; then
        say "Retiring ~/.bash_profile so login shells use ~/.profile"
        backup "$bp"
    fi
}

# --- Running bash and vim as the target home sees them -------------------------
# Start an interactive bash with the target's ~/.bashrc in a clean environment and run $1 in it.
# A clean environment: this checks what the repo's files do, not what an already-open terminal inherited.
# Prints the command's output; stderr (startup warnings) goes to the file in $2.
target_bash() {
    env -i HOME="$TARGET" TERM=dumb PATH=/usr/local/bin:/usr/bin:/bin \
        bash --rcfile "$TARGET/.bashrc" -i -c "$1" </dev/null 2>"$2"
}

# The PATH an interactive shell in the target home ends up with (includes nvm's Node).
# Other output (e.g. Ubuntu's sudo hint) is dropped; empty if bash fails.
target_path() {
    target_bash 'printf "\nPATH=%s\n" "$PATH"' "$WORK/path.err" | sed -n 's/^PATH=//p' | tail -1 || true
}

# Run vim headless with the target's ~/.vimrc (-u is needed: -es skips the vimrc otherwise).
# coc stays off: in a headless vim it would start Node and install extensions.
target_vim() {
    HOME="$TARGET" PATH="$VIM_PATH" "${CLEAN_ENV[@]}" vim -Nes -i NONE -u "$TARGET/.vimrc" \
        --cmd 'let g:coc_start_at_startup = 0' "$@" -c 'qa!' </dev/null
}

# Print the lines of a vim expression (a list or string) evaluated after startup (-es prints no :echo).
vim_eval() {
    local out="$WORK/eval" rc=0
    rm -f "$out"
    target_vim -c "call writefile(type($1) == v:t_list ? $1 : [$1], '$out')" || rc=$?
    [ -f "$out" ] || return 1
    cat "$out"
    return "$rc"
}

# True if $1 is a working vim-plug: on its own (no other runtime files), it loads and can set up
# a plugin list with the Plug commands. A file cut short by an interrupted download fails this.
# $1 must be in an autoload/ folder (vim's rule for plug#... functions).
plug_ok() {
    [ -s "$1" ] && PLUG_FILE="$1" vim -Nes -u NONE -i NONE \
        -c 'let &runtimepath = fnamemodify($PLUG_FILE, ":h:h") . "," . $VIMRUNTIME' \
        -c 'execute "source" fnameescape($PLUG_FILE)' \
        -c 'call plug#begin("/nonexistent/plugged")' -c "Plug 'x/y'" -c 'call plug#end()' \
        -c 'if exists(":PlugInstall") != 2 || exists(":PlugUpdate") != 2 | cquit | endif' \
        -c 'qa!' </dev/null >/dev/null 2>&1
}

# Each step is checked explicitly: this runs as `install_plugins || ...`, where set -e is off.
install_plugins() {
    say "Installing vim-plug and the vim plugins"
    local plug="$TARGET/.vim/autoload/plug.vim" result="$WORK/plug-result" log rc=0 failed missing
    if [ "$DRY" = 1 ]; then
        plug_ok "$plug" || show "would download vim-plug into $plug"
        show "would run: vim +PlugInstall"; return 0
    fi
    if ! plug_ok "$plug"; then                         # missing, or cut short by an earlier failure
        mkdir -p "$(dirname "$plug")" || { fail "Can't create $(dirname "$plug")"; return 1; }
        mkdir -p "$WORK/autoload" || return 1
        if ! curl -fsSL --connect-timeout 20 --max-time 120 -o "$WORK/autoload/plug.vim" "$PLUG_URL" \
            || ! plug_ok "$WORK/autoload/plug.vim" || ! mv -f "$WORK/autoload/plug.vim" "$plug"; then
            fail "Couldn't download vim-plug from $PLUG_URL (check the network, then run this again)"
            return 1
        fi
    fi
    # Not `vim -es`: there PlugInstall skips plugins when some are already installed. Vim's screen
    # output must be captured (with output to /dev/null it installs nothing). vim-plug's result
    # buffer is saved: it marks each failed plugin with "x".
    log=$(timeout --kill-after=10 "$PLUG_TIMEOUT" env HOME="$TARGET" PATH="$VIM_PATH" "${CLEAN_ENV[@]}" \
        vim -N -i NONE -u "$TARGET/.vimrc" --not-a-term --cmd 'let g:coc_start_at_startup = 0' \
        -c 'PlugInstall --sync' -c "call writefile(getline(1, '\$'), '$result')" -c 'qa!' \
        </dev/null 2>&1) || rc=$?
    if [ "$rc" != 0 ] || ! grep -qs 'Finishing' "$result"; then
        if [ "$rc" = 124 ] || [ "$rc" = 137 ]; then      # 137: had to be killed
            fail "Installing the plugins took over $PLUG_TIMEOUT seconds and was stopped (a stuck download?)."
        else
            fail "vim-plug didn't finish (vim exit code $rc). Last output:"
            printf '%s\n' "$log" | sed 's/\x1b\[[0-9;?]*[A-Za-z]//g; s/\r/\n/g' | grep -v '^\s*$' \
                | tail -3 | cut -c1-160 | sed 's/^/     /' >&2
        fi
        fail "Run this again to retry (or :PlugInstall in vim)."
        return 1
    fi
    failed=$(grep -A3 '^x ' "$result" || true)
    missing=$(vim_eval 'exists("g:plugs") ? filter(keys(g:plugs), "!isdirectory(g:plugs[v:val].dir . \"/.git\")") : ["vim-plug"]') \
        || missing="(vim reported an error)"
    if [ -f "$TARGET/.vim/plugged/coc.nvim/.git/HEAD" ] && [ ! -f "$TARGET/.vim/plugged/coc.nvim/build/index.js" ]; then
        missing="$missing coc.nvim(build/index.js)"
    fi
    if [ -n "$failed" ] || [ -n "${missing// /}" ]; then
        [ -z "$failed" ] || printf '%s\n' "$failed" | sed 's/^/   /' >&2
        fail "Not installed: $(echo $missing) - check the network, then run this again (or :PlugInstall in vim)"
        return 1
    fi
    show "plugins: OK"
}

verify() {
    say "Checking"
    local ok=1 out rc=0 err="$WORK/bash.err"

    # Shell startup: a non-zero exit, or anything on stderr besides bash's usual no-terminal notes.
    target_bash 'true' "$err" >/dev/null || rc=$?
    out=$(grep -v -e 'cannot set terminal process group' -e 'no job control in this shell' \
        -e 'tcsetattr' "$err" || true)
    if [ -n "$out" ] || [ "$rc" != 0 ]; then
        fail "~/.bashrc failed (exit code $rc)${out:+, printing:}"
        [ -z "$out" ] || printf '%s\n' "$out" | sed 's/^/     /' >&2
        ok=0
    else show "bash starts: OK"; fi

    local tpath; tpath=$(target_path)
    case ":$tpath:" in
        ::) fail "PATH: not checked, bash didn't get through ~/.bashrc"; ok=0 ;;
        *::*|*:[!/]*|*'#'*) fail "PATH looks wrong: $tpath"; ok=0 ;;   # empty, relative or comment
        *)  if [ -d "$TARGET/.local/bin" ] && [[ ":$tpath:" != *":$TARGET/.local/bin:"*":/usr/bin:"* ]]; then
                fail "~/.local/bin is not before /usr/bin in PATH: $tpath"; ok=0
            else show "PATH: OK"; fi ;;
    esac

    if target_bash 'type _completion_loader >/dev/null 2>&1 && _completion_loader git; complete -p git' \
        "$err" >/dev/null; then
        show "git completion: OK"
    else
        fail "git completion not loaded"; ok=0
    fi

    out=$(HOME="$TARGET" "${CLEAN_ENV[@]}" git config --global --show-origin alias.lg 2>&1) || true
    if [[ $out == "file:$TARGET/.gitconfig"* ]]; then show "git config: OK"
    else fail "git doesn't read the repo's ~/.gitconfig: $out"; ok=0; fi

    if out=$(vim_eval 'v:errmsg') && [ -z "$out" ]; then
        show "vim starts: OK"
    else
        fail "vim reported an error at startup: ${out:-(open vim and see :messages)}"; ok=0
    fi

    # Only checks that coc is installed and loads; Node starting coc is checked when you open vim.
    if PATH="$VIM_PATH" sh -c 'command -v node' >/dev/null; then
        out=$(vim_eval 'exists(":CocInfo")') || true
        if [ "$out" = 2 ]; then show "coc.nvim: OK"; else fail "coc.nvim didn't load"; ok=0; fi
    else
        echo
        echo "   Node.js not found: coc.nvim (completion, go-to-definition) stays off until you install it."
        echo "   See README.md (Node via nvm). Vim works without it."
    fi

    if [ "$ok" = 1 ]; then echo "   All checks passed"; else fail "Some checks failed (see above)"; return 1; fi
}

# ---------------------------------------------------------------------------
[ "$DRY" = 1 ] && say "Dry run: nothing is changed"
preflight
install_packages

say "Linking files into $([ "$TARGET" = "$REAL_HOME" ] && echo "~" || echo "$TARGET")"
for f in "${FILES[@]}"; do link "$f"; done

retire_bash_profile
VIM_PATH=$( [ "$DRY" = 1 ] || target_path )
[ -n "$VIM_PATH" ] || VIM_PATH=$PATH
PLUGINS_OK=1
install_plugins || PLUGINS_OK=0

if [ "$DRY" = 1 ]; then echo; echo "Dry run done."; exit 0; fi
verify && [ "$PLUGINS_OK" = 1 ] || { echo; fail "Finished with problems (see above)."; exit 1; }
echo
echo "Done. Open a new terminal (or log out and back in once) to use the new shell settings."
