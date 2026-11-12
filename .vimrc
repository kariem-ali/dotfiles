" Setting some decent VIM settings for programming

" set runtime path to use ~/.vim
set runtimepath+=~/.vim,~/.vim/after

" Plugins, managed by vim-plug. Guarded so vim still starts cleanly on a fresh
" machine before vim-plug and the plugins are installed.
let s:have_plug = filereadable(expand('~/.vim/autoload/plug.vim'))
if s:have_plug
  call plug#begin('~/.vim/plugged')
  "Plug 'w0rp/ale'
  "Plug 'Zaptic/elm-vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'dylon/vim-antlr'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " True Solarized colour scheme (see the colour schemes at the end)
  Plug 'lifepillar/vim-solarized8'
  call plug#end()               " also turns on filetype plugins, indent and syntax
else
  filetype plugin indent on
endif

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set ruler                       " show the cursor position all the time
"set cmdheight=2
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set backspace=indent,eol,start  " make that backspace key work the way it should
set nocompatible                " vi compatible is LAME
set showmode                    " show the current mode
syntax on                       " turn syntax highlighting on by default
set number                      " show lines numbers
if has('win32')
  set shellslash                " use / in expanded paths, for Unix-style shells on Windows
endif
set diffopt+=iwhite             " ignore whitespace for diffs
if !has('win32')
  set shellcmdflag=-ic          " Set shell to be interactive. Adds support for using bash aliases in :!
endif
set hidden                      " Better handling of multiple buffers
set ignorecase smartcase        " Search patterns are case-sensitive only if they contain upper case characters
set incsearch                   " Highlight matched search strings as you type search pattern
set tabstop=2 shiftwidth=2 expandtab
set list
set listchars=tab:▸\ ,eol:¬,precedes:‹,extends:›,trail:•
set lazyredraw
set foldmethod=manual           " Don't fold using syntax rules (i.e. #region for C# etc...)
"set colorcolumn=81              " Add boundary column at 81 reference
set splitbelow                  " New windows open below
set splitright                  " New vertical windows open to the right
let mapleader = ","
nmap <leader><leader> <c-^>      " switch to alternate buffer
nnoremap H ^
xnoremap H ^
nnoremap L $
xnoremap L $

if !has('win32')
  set shell=/bin/bash           " on Windows, keep the default (cmd.exe)
endif

" Auto-save on text chang
"autocmd TextChanged,TextChangedI * silent write
"autocmd TextChanged,TextChangedI <buffer> silent write

" set syntax for .coffee files
au BufNewFile,BufRead *.coffee set syntax=coffee 

" set syntax to html for .hta files (Windows HTML Applications)
au BufNewFile,BufRead *.hta set syntax=html

au BufNewFile,BufRead *.fs,*.fsx set ft=fsharp syntax=ocaml
au BufNewFile,BufRead *.fsx noremap <buffer> <leader>m :w\|:!dotnet fsi %<cr>
au BufNewFile,BufRead *.cpp,*.h noremap <buffer> <leader>m :w\|!g++ -std=c++17 -O2 -Wall %:r.cpp -o %:r.out && %:r.out<cr>

au BufNewFile,BufRead *.js noremap <buffer> <leader>m :w\|:!node %<cr>

au BufRead,BufNewFile *.g set filetype=antlr3
au BufRead,BufNewFile *.g4 set filetype=antlr4

"au FileType elm setlocal softtabstop=4 shiftwidth=4 expandtab
"let g:elm_setup_keybindings = 1 "Enable defaul keybindings
"au BufNewFile,BufRead *.elm set syntax=elm
"au BufWritePost *.elm execute "silent !elm-format --yes %"

" Sane command-line mode mappings
" Alt+B / Alt+F arrive from the terminal as Esc+b / Esc+f. Wait at most 100 ms
" for the rest of a key code, so Esc followed by b/f is only read as Alt+B/Alt+F
" when typed within 100 ms (and Esc itself takes effect faster).
set ttimeout ttimeoutlen=100
execute "set <M-B>=\eb"
execute "set <M-F>=\ef"
"execute "set <M-D>=\ed"
cnoremap <C-A> <Home>
cnoremap <M-B> <S-Left>
cnoremap <M-F> <S-Right>
"noremap <M-D> <S-Right><C-W>

" Ctrl-P
let g:ctrlp_switch_buffer = 'Et'

" CoC: only when the plugin is installed and Node is available. Otherwise coc
" reports an error at every start and its mappings (Tab, Enter, CursorHold)
" don't work. Without Node the plugin stays installed but isn't started.
" The block runs to the matching 'endif " CoC'.
let s:have_coc = s:have_plug && isdirectory(expand('~/.vim/plugged/coc.nvim'))
      \ && executable(get(g:, 'coc_node_path', empty($COC_NODE_PATH) ? 'node' : $COC_NODE_PATH))
if !s:have_coc
  let g:coc_start_at_startup = 0
  if s:have_plug && isdirectory(expand('~/.vim/plugged/coc.nvim'))
    augroup coc_node_reminder
      autocmd!
      autocmd VimEnter * echohl WarningMsg | echo 'coc.nvim is off: Node.js not found' | echohl None
    augroup END
  endif
endif
if s:have_coc

" Extensions coc installs on first start, so a fresh machine gets the same set.
let g:coc_global_extensions = ['coc-json', 'coc-tsserver']

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab to trigger completion NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugins before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" <space>i / <space>r instead of gi / gr, to keep Vim's built-in gi and gr
nmap <silent> <space>i <Plug>(coc-implementation)
nmap <silent> <space>r <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> <leader>g :call <SID>show_documentation()<CR>


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)
xmap <silent> <leader>ff :call CocActionAsync('format')<CR>
nmap <silent> <leader>ff :call CocActionAsync('format')<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>f <Plug>(coc-fix-current) :write<cr>

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

endif " CoC

" Show syntax highlighting groups for word under cursor
nmap <F3> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" F1: Vim help for the word under the cursor
nnoremap <silent> <F1> :execute 'help ' . expand('<cword>')<CR>
inoremap <silent> <F1> <Esc>:execute 'help ' . expand('<cword>')<CR>

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

" Setting GUI specific options
if has("gui_running")
  if has('win32')
    set guifont=Source_Code_Pro:h11
  endif
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

      " Trailing spaces on added lines; the colour comes from the colour scheme
      " (see colour_schemes below)
      autocmd Syntax diff match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

      autocmd Syntax gitcommit setlocal textwidth=74
endif " has("autocmd")

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Coloured wavy underlines (spelling, coc diagnostics) in kitty. Vim takes the undercurl
" code from terminfo's Cs entry, which in kitty's terminfo sets the cursor colour instead,
" and only sends underline colours once the terminal has identified itself.
if $TERM =~# 'kitty'
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
  let &t_8u = "\e[58;2;%lu;%lu;%lum"
endif

" Colour schemes. Hearth is the default; switch any time with :colorscheme <name>.
" To change the default, comment out 'colorscheme hearth' below and uncomment another.
" The autocmds below apply each scheme's own settings, so :colorscheme alone is enough.
"   hearth      the Hearth kitty theme's colours (.vim/colors/hearth.vim)
"   habamax     ships with vim
"   solarized8  true Solarized (the vim-solarized8 plugin)
"   solarized   the old Solarized, drawn with the terminal's 16 colours, so in kitty
"               with the Hearth theme it shows Hearth's colours in Solarized's layout

" Exact (true) colours where the terminal supports them: kitty, Windows Terminal, or
" any terminal that sets COLORTERM. Elsewhere schemes use the terminal's own colours.
let s:truecolor = has('termguicolors')
      \ && ($COLORTERM =~# 'truecolor\|24bit' || $TERM =~# 'kitty' || !empty($WT_SESSION))

" Runs before every :colorscheme, but only for a scheme that exists (a mistyped name
" changes nothing): reset the :terminal colours (schemes that have their own set them
" again), turn true colour off for the old Solarized and on for the rest, and set the
" old Solarized's options (solarized8 reads the same names, so they're cleared for it).
function! s:before_colorscheme(name) abort
  if empty(globpath(&runtimepath, 'colors/' . a:name . '.vim', 0, 1))
    return
  endif
  unlet! g:terminal_ansi_colors g:solarized_termtrans g:solarized_visibility
  if has('termguicolors')
    let &termguicolors = s:truecolor && a:name !=# 'solarized'
  endif
  if a:name ==# 'solarized'
    let g:solarized_termtrans = 1
    let g:solarized_visibility = 'low'
  endif
endfunction

augroup colour_schemes
  autocmd!
  autocmd ColorSchemePre * call s:before_colorscheme(expand('<amatch>'))
  " The old Solarized's menu and spelling colours, as before
  autocmd ColorScheme solarized hi Pmenu cterm=bold ctermfg=Black ctermbg=Gray
        \ | hi SpellBad ctermfg=red ctermbg=gray
  " Trailing spaces in diffs: red, unless the scheme picks a colour (Hearth does)
  autocmd ColorScheme * hi default WhiteSpaceEOL ctermbg=red guibg=red
augroup END

set background=dark
colorscheme hearth
"colorscheme habamax
"colorscheme solarized8
"colorscheme solarized

"let &t_SI.="\e[5 q"
"let &t_SR.="\e[4 q"
"let &t_EI.="\e[1 q"
