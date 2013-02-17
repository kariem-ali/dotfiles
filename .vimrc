" Setting some decent VIM settings for programming

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
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
set t_Co=256                    " Set number of colours to 256
colorscheme solarized
                                
" set syntax to html for .hta files
au BufNewFile,BufRead *.hta set syntax=html 

" Sources the default git bashrc file
"set shell=C:\utils\git\bin\bash.exe\ --login 
" Sources my bashrc file
set shell=C:\utils\git\bin\bash.exe\ --rcfile\ /c/utils/git/.bashrc 

" Help Integration
function! Doc()
  let s:currentWord = expand("<cword>")

  if &ft =~ "cs"
    let s:url = "http://social.msdn.microsoft.com/Search/en-US/?Refinement=26\\&Query=".s:currentWord
  else
    execute "help ".s:currentWord
    return
  endif

  let s:cmd = "silent !firefox"." ".s:url
  execute s:cmd
endfunction

map <silent> <F1> :call Doc()<CR>
imap <silent> <F1> <ESC>:call Doc()<CR>

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

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
