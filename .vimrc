" Setting some decent VIM settings for programming

" set runtime path to use ~/.vim
set runtimepath+=~/.vim,~/.vim/after
"let &runtimepath=substitute(&runtimepath, "\\~/vimfiles", "\\~/.vim", "g")

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
"set cmdheight=2                " make the command 2 lines instead of one
set backspace=indent,eol,start  " make that backspace key work the way it should
set nocompatible                " vi compatible is LAME
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
syntax on                       " turn syntax highlighting on by default
set number		                	" show lines numbers
set shellslash                  " sets the file path separator to be compatible with unix shell i.e. / not \
set diffopt+=iwhite             " ignore whitespace for diffs
set shellcmdflag=-ic            " Set shell to be interactive. Adds support for using bash aliases in :!
set hidden                      " Better handling of multiple buffers
set ignorecase smartcase        " Search patterns are case-sensitive only if they contain upper case characters
set incsearch                   " Highlight matched search strings as you type search pattern
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
set foldmethod=syntax           " Fold using syntax rules (i.e. #region for C# etc...)
set colorcolumn=81              " Add boundary column at 81 reference
set t_Co=256                    " Set number of colours to 256
let mapleader = ","

colorscheme Solarized

" highlight boundary columns background with black
highlight ColorColumn ctermbg=black

" set syntax for .coffee files
au BufNewFile,BufRead *.coffee set syntax=coffee 

" set syntax to html for .hta files
au BufNewFile,BufRead *.hta set syntax=html 

" Sources the default git bashrc file
"set shell=C:\utils\git\bin\bash.exe\ --login
" Sources my bashrc file
set shell=C:\utils\git\bin\bash.exe\ --rcfile\ ~/.bashrc

" Show syntax highlighting groups for word under cursor
nmap <F3> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Help Integration
map <silent> <F1> :call Doc()<CR>
imap <silent> <F1> <ESC>:call Doc()<CR>
function! Doc()
  let s:currentWord = expand("<cword>")

  if &ft =~ "cs"
    let s:url = "http://social.msdn.microsoft.com/Search/en-US/?Refinement=26\\&Query=".s:currentWord
  else
    execute "help ".s:currentWord
    return
  endif

  let s:cmd = "silent !firefox"." ".s:url." &"
  execute s:cmd
endfunction

map <leader>cva :call CreateVariableAccessor()<cr>
function! CreateVariableAccessor()
  normal "ayiw
  exec "normal o" . "\<cr>public function get" . @a . "(){"
  normal ==
  exec "normal o" . "return $this->" . @a .";"
  normal ==
  exec "normal o" . "}"
  normal ==
endfunction

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

" Setting GUI specific options
if has("gui_running")
  set guifont=Source_Code_Pro:h11
  set guioptions-=T " Remove toolbar
  set guioptions-=m " Remove menu
endif

"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    "Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,git-rebase-todo setlocal fileencodings=utf-8

    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && expand("%") !~ "COMMIT_EDITMSG"
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff"
      \           && expand("%") !~ "git-rebase-todo" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff
      autocmd BufNewFile,BufRead *.diff set filetype=diff

      autocmd Syntax diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

      autocmd Syntax gitcommit setlocal textwidth=74
endif " has("autocmd")
