# Dotfiles plan (final, after two Codex reviews)

Target: Linux Mint 22.x / Ubuntu 24.04, bash and vim. Windows, WSL and macOS support is dropped.

## Phase 0: minimal cleanup, then the snapshot commit

P1. Undo the `.vimperatorrc` working-tree change (it only converts LF to CRLF): `git restore .vimperatorrc`.
P2. Bring the live `~/.bashrc` into the repo (as `.bashrc`) so the snapshot includes the startup wiring.
    Drop its macOS gcloud lines first: they are dead on Linux.
    `~/.bash_profile` is not captured (it only holds those same lines).
P3. Add `.gitignore`: `.netrwhist`, `*.bak-*`, `*~`, `*.old`, `.vim/plugged/`, local override files.
P4. Decide on `.ideavimrc` (untracked, one line): include it in the snapshot or leave it out.
P5. Review the full staged diff before committing, for anything machine- or work-specific.
P6. Snapshot commit, staging files explicitly: `.gitconfig .vimrc bash/* .bashrc .gitignore` (+ `.ideavimrc`).
P7. Optional; doesn't affect the snapshot, so can go before or after: delete the untracked junk
    `.vim/bundle/*` (verified: matches recorded upstream, only line endings, modes and generated tags),
    `.vim/.vim` and `.vim/.netrwhist`.

## Essentials

Shell fixes
1. Remove `export HOME=/home/kariem/`.
2. Stop assigning PATH wholesale. `bash/env` only prepends existing user directories (`~/.local/bin` first)
   via a dedup-safe `path_prepend`. nvm's Node goes in front of that by design. Shells already open inherit
   the broken PATH until you log out and back in once.
3. Delete the empty `firefox`, `chrome` and `browse` aliases.
4. Add git aliases `l` and `lg` so `gl`/`glg` work.
5. New tracked `.bashrc`: return early if not interactive; bash-completion; `ls`/`grep` colours;
   `HISTCONTROL=ignoreboth`, `histappend`, larger history; source the modules; then `~/.bashrc.local` if present.
6. Guard `stty -ixon` with `[[ -t 0 ]]`.
7. Retire `~/.bash_profile` so the stock `~/.profile` runs for login shells (installer backs it up).
8. Remove the ANTLR CLASSPATH and aliases.
9. `mcd`: require an argument and quote it. `cdf`: quote it, and fail clearly on zero or several matches.
10. Machine and work settings go in untracked `~/.bashrc.local` (kubectl, gcloud, ssh key) and
    `~/.gitconfig.local` (via `[include]`).

Cleanup
11. Remove Windows/WSL/macOS leftovers: `install.cmd`, `.bashrc.win32`, `.vimperatorrc`; aliases `msbuild`, `sml`,
    `dotnet.exe`, `rider`, `pg`/`pg12`; vimrc `set shellslash`, the MSDN F1 lookup, Windows `guifont`.
    Rename `env.win32` to `env`.
12. Remove `autoload/pathogen.vim` (unused since vim-plug).

Vim
13. Guard the whole plugin block (`plug#begin` … `plug#end`) and the coc mappings and `coc#status()` so vim
    starts cleanly on a machine where plugins or Node aren't installed yet.
14. Declare `g:coc_global_extensions = ['coc-json', 'coc-tsserver']` so a fresh install gets the same extensions.

Installer and docs
15. Layout: DECIDED to skip the `home/` move. Files stay where they are; `install.sh` carries an explicit
    list (repo path -> home path): `.bashrc`, `.inputrc`, `.gitconfig`, `.vimrc`, `.ideavimrc`,
    `.vim/colors/*.vim`, `.vim/syntax/cs.vim`. `bash/` modules are sourced from the repo, not linked.
16. `install.sh` (tracked as executable):
    - symlinks individual files, never whole directories, so `~/.vim/plugged` and other state stay out of the repo
    - backs up any differing file as `<name>.bak-<stamp>` (collision-safe); handles dangling symlinks; safe to re-run
    - `--dry-run` (no writes, no network), `--home DIR` (fully isolated: no packages, plugins go into DIR),
      `--no-packages`, `-h`; works from a path with spaces
    - apt: `vim git curl bash-completion`
    - installs vim-plug, runs `PlugInstall --sync` and checks for failures; if Node is missing, says clearly that
      coc.nvim completion is off until Node is installed (README explains nvm)
    - (chunk D, after Codex review) preflight before any change: `bash -n` on the shell files, refuse if
      `~/.vim`, `.vim/colors`, `.vim/syntax`, `.vim/autoload` or `.vim/plugged` is a symlink; vim/git run with
      VIMINIT, XDG_*, GIT_CONFIG_* etc. unset; plugin failures reported from vim-plug's results (exit 1)
17. Verification at the end, run against the target home (the sandbox for `--home`):
    `bash -n`; PATH sanity (no `#`, no empty entry, `~/.local/bin` early); vim starts with no errors;
    `git config` loads; git completion loaded; coc loads when Node is present.
    Also: bash startup errors (stderr) reported; `~/.local/bin` before `/usr/bin`; git config read from the
    target's ~/.gitconfig. Limits: the PATH check uses a clean environment; coc is checked to load, not to run.
18. README in the sibling style: file table, install, options, local override files, restore/uninstall
    (including an interrupted install), known issues, links to kitty-config and rofi-alfred, and the tested
    versions (Mint 22.3, vim 9.1, Node 24) with the caveat that plugins install their latest versions.
    Also: `.vimrc` works on Windows (native Vim/gVim) too; there, use `~/.vim` (not `~/vimfiles`) for
    vim-plug, plugins and the repo's colors/syntax files. (from Codex chunk-B review #2)
    Also (Codex chunk-D review): the install isn't transactional (an interrupted run leaves earlier links in
    place; re-running finishes it); how to restore `.bak-*` files; keep the checkout where it is (links point
    into it); move personal settings into `~/.bashrc.local` / `~/.gitconfig.local`; login shells now go
    through `~/.profile`; installer is Linux-only even though `.vimrc` also works on Windows.
19. `.gitattributes`: `* text=auto eol=lf`. Committed as part of chunk D.

## Recommended

20. DONE (shell-tidy): use the system `git-sh-prompt`, falling back to the vendored 2017 copy; loaded in `bash/prompt`.
21. Git defaults: `init.defaultBranch=main`, `push.autoSetupRemote`, `diff.colorMoved`; track `~/.config/git/ignore`.
    Opinionated, your call: `pull.ff=only`, `rerere.enabled`.
22. vimrc: fix the later `set statusline=` that hides coc's status; drop `shellcmdflag=-ic`
    (side effect: bash aliases no longer work in `:!`).
23. DROPPED: `PROMPT_COMMAND` array-safety. Our code runs first and meets a plain string; kitty's integration
    handles both forms; no practical benefit.
24. Prompt separator: dotfiles is the canonical copy; kitty-config's README points here.
25. DONE (shell-tidy): tidy `bash/config` (colour variables removed) and `bash/prompt` (dead functions removed;
    old separator and PS1 lines kept as comments; the 6 colours it uses are named and unset after building PS1).
26. DONE (shell-tidy): `TAB: menu-complete` moved to `.inputrc` inside `$if Bash … $endif`, plus Shift+Tab
    (`menu-complete-backward`).
27. SSH: add `AddKeysToAgent yes` to `~/.ssh/config`, which relies on the agent the desktop session starts; keep a
    small fallback that starts an agent only when none is reachable (TTY/ssh sessions).
28. Pin plugin versions (`:PlugSnapshot` or commits in the vimrc).
29. Run shellcheck in the verify step when it's installed.
29a. `.vimrc` `<leader>m` run mappings: quote file names with `shellescape()` (breaks on spaces today) and use a
     `.exe` output name for C++ on Windows. (from Codex chunk-B review #3)
29b. `.vimrc` `K` fallback (before coc is ready): run `keywordprg` values starting with `:` as Ex commands,
     not via `!`; matters on Windows where the default is `:help`. (from Codex chunk-B review #4)
29c. UNDECIDED (optional). Login shells: Ubuntu's ~/.profile sources ~/.bashrc first and then prepends
     ~/.local/bin again, so login shells have ~/.local/bin twice and ahead of nvm's Node (non-login
     terminals are fine). Fix: track a `.profile` that sets PATH *before* sourcing ~/.bashrc (dedup at the
     end of ~/.profile alone would not restore Node's precedence). (found after the real install)
29d. install.sh cosmetic: "~/.bashrc failed (exit code 0), printing:" when it prints errors but exits 0.

## Nice to have

30. `--copy` install mode.
31. Remove the six unused colour schemes and the empty `.gitkeep` vim directories.
32. Optional extras (`fzf`, `bat`) behind an installer flag.
33. Track VS Code `settings.json`, maybe `~/.claude/settings.json`; README notes for the monitor script and locale.
34. Let dotfiles optionally run the kitty-config and rofi-alfred installers, once all three have stable options.
35. Housekeeping outside the repo: old `*.before-*` / `.bak` files in `~/.config/rofi`, `~/.local/bin`,
    `~/.config/kitty`, and `~/.DS_Store`. Review before deleting.
35a. Live ~/.vim leftovers from the pathogen era (nothing loads them; found in the live-setup review, 2026-11-12).
     Review, then delete: ~/.vim/autoload/pathogen.vim, ~/.vim/autoload/plug.vim.old (Mar 2026 copy; plug.vim
     is current), ~/.vim/bundle/ (ctrlp.vim, elm.vim, syntastic, vim-dispatch, .gitkeep), and the stray 5-byte
     file ~/.vim/.vim (contains ".vim/"). Optionally ~/.vim/.netrwhist (netrw history, regenerated by vim).
     Keep: autoload/plug.vim, plugged/, the linked colors/ and syntax/ files, and the empty after/ compiler/
     doc/ ftdetect/ ftplugin/ indent/ folders (harmless; can go with item 31).
36. Move git config to `~/.config/git/config` (only together with removing `~/.gitconfig`).
37. Windows cosmetics in `.vimrc`: ASCII fallback for `listchars`, guard the cursor-shape codes and `t_Co=256`
    by terminal, note that gVim's font needs Source Code Pro. (from Codex chunk-B review)

## Decisions

- Symlink individual files by default; never symlink directories that mix config and generated state.
- Keep the three repos separate; the dotfiles README links to the other two.

## Status (2026-11-12)

Essentials 1-19 done: chunks A-E merged to master and pushed; real install run, all checks passed.
Since then: `git lg` shows authors; `git st`/`co`/`cm` aliases (pushed). Shell tidy (20, 25, 26) on branch
`shell-tidy`.

## Order of work

1. Phase 0 on master.
2. Do the rest on a branch in a separate git worktree: your live `~/.bashrc` sources `bash/*` straight from this
   checkout, so editing master would change every new terminal immediately.
3. Essentials 1–19 in the worktree; test with `--dry-run`, a `--home` sandbox install, and a re-run.
4. Merge, run `./install.sh` for real (it backs up your live files), log out and back in once.
5. Recommended, then Nice to have, as you choose.
