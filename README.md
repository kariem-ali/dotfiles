# dotfiles

My bash, vim and git setup for Linux Mint / Ubuntu, with an installer that sets up a fresh
machine in one command: it links the files into your home folder, installs the vim plugins and
checks that everything works.

## Contents

| Path | Installed to | Purpose |
|---|---|---|
| `.bashrc` | `~/.bashrc` | Interactive shell: history, colours, completion; loads the `bash/` modules, nvm and `~/.bashrc.local` |
| `bash/env` | *loaded by `.bashrc`* | `PATH`: adds `~/bin` and `~/.local/bin` (first) if they exist, without duplicates |
| `bash/config` | *loaded by `.bashrc`* | Tab cycles through completions; `Ctrl+S` searches history forward; colour names for the prompt |
| `bash/prompt` | *loaded by `.bashrc`* | Prompt: a full-width separator line, then `user@host:folder(git branch)`, then `$` |
| `bash/git-prompt.sh` | *loaded by `.bashrc`* | `__git_ps1` for the prompt (copy from git, 2017) |
| `bash/aliases` | *loaded by `.bashrc`* | git shortcuts (`gs`, `gd`, `gl`, ...), `mcd`, `cdf`, `run_ssh_agent`, kubectl |
| `.inputrc` | `~/.inputrc` | Case-insensitive tab completion |
| `.gitconfig` | `~/.gitconfig` | Name, email, editor, `git l` / `git lg` log aliases; includes `~/.gitconfig.local` |
| `.vimrc` | `~/.vimrc` | Vim settings, mappings and plugins (vim-plug) |
| `.vim/colors/*.vim` | `~/.vim/colors/` | Colour schemes (solarized is the one in use) |
| `.vim/syntax/cs.vim` | `~/.vim/syntax/` | C# syntax highlighting |
| `.ideavimrc` | `~/.ideavimrc` | IntelliJ IdeaVim: reuses `~/.vimrc` |
| `install.sh` | | Installer |

Vim plugins (installed by the installer into `~/.vim/plugged`, not part of this repo):
[vim-surround](https://github.com/tpope/vim-surround),
[vim-fugitive](https://github.com/tpope/vim-fugitive),
[ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim),
[vim-antlr](https://github.com/dylon/vim-antlr) and
[coc.nvim](https://github.com/neoclide/coc.nvim) (completion and go-to-definition; needs Node.js)
with the `coc-json` and `coc-tsserver` extensions.

## Requirements

- Linux Mint 22.x or Ubuntu 24.04 (any Debian-based system with `apt` should work).
- `sudo`, to install the packages `vim git curl bash-completion` if any are missing.
- Network access to GitHub, for vim-plug and the plugins.
- Optional: **Node.js** for coc.nvim (see [Node.js for coc.nvim](#nodejs-for-cocnvim)). Without it vim
  works normally, just without coc's completion.

## Install

On a fresh machine, install git first:

```sh
sudo apt update && sudo apt install -y git
```

Then:

```sh
git clone https://github.com/kariem-ali/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh --dry-run      # preview, changes nothing
./install.sh                # install
```

Then open a new terminal. Log out and back in once as well, so login shells and programs started
from the desktop begin with a fresh environment.

The files are **symlinked**, not copied: editing them in the repo changes your setup directly
(new terminals, or `:source ~/.vimrc` in vim). Keep the checkout where it is; moving or deleting it
breaks the links. To move it, move it and run `./install.sh` again from the new place.

### Options

| Option | Effect |
|---|---|
| `--dry-run` | Shows what would be done: which files would be backed up and linked. Changes nothing and downloads nothing |
| `--no-packages` | Doesn't install apt packages (you install `vim git curl bash-completion` yourself) |
| `--home DIR` | Installs into `DIR` instead of your home folder, for trying it out. Implies `--no-packages`; vim-plug and the plugins also go into `DIR` |
| `-h`, `--help` | Shows the usage |

Try it in a throwaway folder first, if you like (this skips the packages, so `vim`, `git`, `curl`
and `bash-completion` must already be installed):

```sh
./install.sh --home /tmp/dotfiles-test
```

### What the installer does

1. **Checks first:** shell files have no syntax errors, and `~/.vim`, `~/.vim/colors`,
   `~/.vim/syntax`, `~/.vim/autoload` and `~/.vim/plugged` aren't symlinks (an old setup that
   linked the whole `~/.vim` folder must be undone by hand first). If either check fails, nothing
   is changed.
2. **Packages:** installs whichever of `vim git curl bash-completion` are missing, with `apt`.
3. **Links:** links each file that has a destination in the table above into your home folder
   (the `bash/` modules stay in the repo and are loaded from there). Each file is linked on
   its own, never a whole folder, so `~/.vim/plugged` and other files programs create stay out
   of the repo. **Any existing file that differs is kept** as `<name>.bak-<timestamp>` next to
   it; an identical copy is simply replaced. Links that are already right are left alone, so
   running it again is safe.
4. **`~/.bash_profile`:** if you have one, it's moved aside as `~/.bash_profile.bak-<timestamp>`.
   While it exists, bash ignores `~/.profile` in login shells, and Ubuntu's `~/.profile` is
   what sets up `PATH` and loads `~/.bashrc` for them. Afterwards, check that `~/.profile` exists
   and loads `~/.bashrc` (Ubuntu's default does; `cp /etc/skel/.profile ~/` restores it), that
   there's no `~/.bash_login` (bash would read it instead), and move anything you still need from
   the old `~/.bash_profile` into `~/.profile` or `~/.bashrc.local`.
5. **Vim plugins:** downloads [vim-plug](https://github.com/junegunn/vim-plug) and installs the
   plugins. Failed downloads are listed, and the install stops after 10 minutes if a download
   hangs.
6. **Checks:** starts an interactive bash and a headless vim with the new files and reports problems: errors
   from `~/.bashrc`, a broken `PATH`, git completion, git config, vim startup errors, and coc.nvim
   (when Node.js is installed).

The script exits with an error if anything failed, and says what to do.

## Machine-specific settings

Settings that only belong on one machine, or that you don't want in a public repo, go in two
files the repo doesn't track. Both are loaded automatically if they exist:

- **`~/.bashrc.local`**, loaded at the end of `~/.bashrc`. For example:

  ```sh
  # work cluster
  alias kprod='kubectl --context prod-cluster'
  export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
  ```

- **`~/.gitconfig.local`**, included at the end of `~/.gitconfig`, so its values win.
  **If you're not me, set your own name and email here before committing anything**, since the
  repo's `.gitconfig` contains mine:

  ```ini
  [user]
      name = Your Name
      email = you@example.com
  ```

  A different email for repos under `~/work`: add this to `~/.gitconfig.local` ...

  ```ini
  [includeIf "gitdir:~/work/"]
      path = ~/.gitconfig.work
  ```

  ... and create `~/.gitconfig.work`:

  ```ini
  [user]
      email = you@work.example
  ```

**Programs that add lines to `~/.bashrc`** (installers for nvm, SDKMAN, conda, cloud SDKs, ...)
now write into this repo, because `~/.bashrc` is a link to it. `git status` shows it. Move such
lines into `~/.bashrc.local` and undo the change in the repo (`git checkout .bashrc`).

## Node.js for coc.nvim

coc.nvim needs Node.js. Without it, vim shows *"coc.nvim is off: Node.js not found"* at startup
and works normally otherwise.

The simplest way is Ubuntu's package (Node.js 18 on Ubuntu 24.04):

```sh
sudo apt install nodejs
```

For a current version (this setup is tested with Node.js 24), use [nvm](https://github.com/nvm-sh/nvm).
`~/.bashrc` already loads nvm, so tell its installer not to edit `~/.bashrc` (`PROFILE=/dev/null`);
see nvm's README for the latest version number:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | PROFILE=/dev/null bash
# open a new terminal, then:
nvm install --lts
```

The next time vim starts, coc starts and installs its extensions (`coc-json`, `coc-tsserver`).
A Node.js that isn't on `PATH` also works: point `$COC_NODE_PATH` (or `g:coc_node_path`) at it.

## Vim quick reference

The leader key is `,`.

| Keys | Action |
|---|---|
| `,,` | Switch to the previous file |
| `H` / `L` | Start / end of line |
| `Ctrl+P` | Find a file (ctrlp) |
| `,m` | Save and run the file: `.js` (node), `.cpp` (g++), `.fsx` (dotnet fsi) |
| `F1` | Vim help for the word under the cursor |
| `F3` | Show the syntax groups under the cursor |
| `Ctrl+A`, `Alt+B`, `Alt+F` | On the `:` command line: start of line, word back, word forward |

With coc.nvim running:

| Keys | Action |
|---|---|
| `Tab` / `Shift+Tab`, `Enter` | Move through / accept completions |
| `gd`, `gy` | Go to definition, type definition |
| `Space i`, `Space r` | Go to implementation, list references (not `gi` / `gr`, which keep Vim's own meaning) |
| `K` or `,g` | Show documentation |
| `[g` / `]g`, `[e` / `]e` | Previous / next diagnostic, error |
| `,r` | Rename |
| `,ff` | Format |
| `,a`, `,ac`, `,f` | Code action on selection, on file; quick fix |
| `Space a`, `Space o`, `Space s` | Lists: diagnostics, outline, symbols |

## Windows

`install.sh` and the bash files are for Linux. **`.vimrc` also works with native Windows Vim and
gVim:** the Linux-only settings (bash as the shell) are skipped there. Copy or link it to
`~/.vimrc` (`%USERPROFILE%\.vimrc`), and use **`~/.vim`**, not `~/vimfiles`, for vim-plug
(`~/.vim/autoload/plug.vim`), the plugins and this repo's `colors` and `syntax` files, because
`.vimrc` refers to `~/.vim`. gVim is set to the Source Code Pro font; install it, or change
`guifont` in `.vimrc`.

## Restore / uninstall

**Restore one file:** the installer's backups sit next to each file, for example
`~/.vimrc.bak-20261112-004015`. Replace the link with the backup:

```sh
mv ~/.vimrc.bak-20261112-004015 ~/.vimrc
```

**Uninstall:** from the repo folder, remove the links that point into this repo (other files and
links are left alone), then restore the backups you want:

```sh
cd ~/Projects/dotfiles
for f in ~/.bashrc ~/.inputrc ~/.gitconfig ~/.vimrc ~/.ideavimrc \
         ~/.vim/syntax/*.vim ~/.vim/colors/*.vim; do
    [ -L "$f" ] && [[ $(readlink "$f") == "$PWD"/* ]] && rm "$f"
done
ls -a ~ ~/.vim/colors ~/.vim/syntax | grep '\.bak-'    # backups to move back
```

Without a `~/.bashrc`, copy Ubuntu's default: `cp /etc/skel/.bashrc ~/`. To bring back an old
`~/.bash_profile`, move its backup back the same way. vim-plug (`~/.vim/autoload/plug.vim`) and
the plugins (`~/.vim/plugged`) stay; delete them if you don't use them elsewhere.

**An interrupted install** (network failure, `Ctrl+C`) leaves the files linked so far in place.
Run `./install.sh` again; it carries on where it stopped.

## Known limitations

- **Plugins aren't pinned:** a fresh install gets their latest versions, which may behave
  differently from the versions this was tested with. (Running the installer again only installs
  missing plugins; `:PlugUpdate` in vim updates them.)
- **coc.nvim's status in the status line is hidden** by a later `statusline` setting in `.vimrc`.
- **`:!` runs an interactive bash** (`shellcmdflag=-ic`) so aliases work there, which makes `:!`
  commands start a bit slower.
- **`bash/git-prompt.sh` is a 2017 copy** of git's prompt script; the system's own copy is newer.
- **The installer's checks** use a clean environment, so they check what the repo's files do, not
  what an already-open terminal inherited. The coc.nvim check confirms that it loads, not that it
  starts with Node.js; open vim to see that.
- **apt only:** other package managers aren't supported; use `--no-packages` there.

## Tested with

Linux Mint 22.3, bash 5.2, vim 9.1, git 2.43, Node.js 24 (nvm), November 2026.

## Related

- [kitty-config](https://github.com/kariem-ali/kitty-config): the kitty terminal setup (theme,
  font, reading comfort).
- [rofi-alfred](https://github.com/kariem-ali/rofi-alfred): an Alfred-style launcher built on rofi.

## Future work

- Use the system's `git-sh-prompt`, falling back to the bundled copy.
- More git defaults (`init.defaultBranch=main`, `push.autoSetupRemote`, `diff.colorMoved`) and a
  tracked global gitignore.
- Fix the `statusline` that hides coc.nvim's status; reconsider `shellcmdflag=-ic`.
- Pin plugin versions (`:PlugSnapshot`).
- Quote file names in the `,m` run mappings (they break on spaces); `.exe` output for C++ on Windows.
- SSH: `AddKeysToAgent yes` instead of `run_ssh_agent`.
- Run shellcheck in the installer's checks when it's installed.
- A `--copy` mode, and optional extras (`fzf`, `bat`) behind installer flags.
