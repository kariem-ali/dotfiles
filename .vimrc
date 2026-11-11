" Setting some decent VIM settings for programming

" set runtime path to use ~/.vim
set runtimepath+=~/.vim,~/.vim/after
"execute pathogen#infect()

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
"Plug 'w0rp/ale'
"Plug 'Zaptic/elm-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'dylon/vim-antlr'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

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
set shellslash                  " sets the file path separator to be compatible with unix shell i.e. / not \
set diffopt+=iwhite             " ignore whitespace for diffs
set shellcmdflag=-ic            " Set shell to be interactive. Adds support for using bash aliases in :!
set hidden                      " Better handling of multiple buffers
set ignorecase smartcase        " Search patterns are case-sensitive only if they contain upper case characters
set incsearch                   " Highlight matched search strings as you type search pattern
set tabstop=2 shiftwidth=2 expandtab
set list
set listchars=tab:▸\ ,eol:¬,precedes:‹,extends:›,trail:•
set lazyredraw
set foldmethod=manual           " Don't fold using syntax rules (i.e. #region for C# etc...)
"set colorcolumn=81              " Add boundary column at 81 reference
set t_Co=256                    " Set number of colours to 256
set splitbelow                  " New windows open below
set splitright                  " New vertical windows open to the right
let mapleader = ","
nmap <leader><leader> <c-^>      " switch to alternate buffer
nnoremap H ^
xnoremap H ^
nnoremap L $
xnoremap L $

set shell=/bin/bash

" highlight boundary columns background with black
highlight ColorColumn ctermbg=darkgrey

" Auto-save on text chang
"autocmd TextChanged,TextChangedI * silent write
"autocmd TextChanged,TextChangedI <buffer> silent write

" set syntax for .coffee files
au BufNewFile,BufRead *.coffee set syntax=coffee 

" set syntax to html for .hta files
au BufNewFile,BufRead *.hta set syntax=html 

au BufNewFile,BufRead *.fs,*.fsx set ft=fsharp syntax=ocaml
au BufNewFile,BufRead *.fsx noremap <leader>m :w\|:!fsi.exe %<cr>

au BufNewFile,BufRead *.cpp,*.h noremap <leader>m :w\|!g++ -std=c++17 -O2 -Wall %:r.cpp -o %:r.out && %:r.out<cr>

au BufNewFile,BufRead *.js noremap <leader>m :w\|:!node %<cr>

au BufRead,BufNewFile *.g set filetype=antlr3
au BufRead,BufNewFile *.g4 set filetype=antlr4

"au FileType elm setlocal softtabstop=4 shiftwidth=4 expandtab
"let g:elm_setup_keybindings = 1 "Enable defaul keybindings
"au BufNewFile,BufRead *.elm set syntax=elm
"au BufWritePost *.elm execute "silent !elm-format --yes %"

" Sane command-line mode mappings
execute "set <M-B>=\eb"
execute "set <M-F>=\ef"
"execute "set <M-D>=\ed"
cnoremap <C-A> <Home>
cnoremap <M-B> <S-Left>
cnoremap <M-F> <S-Right>
"noremap <M-D> <S-Right><C-W>

" Ctrl-P
let g:ctrlp_switch_buffer = 'Et'

" CoC

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
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

set background=dark             " Use colours that work well on a dark background (Console is usually black)
let g:solarized_termtrans=1     " Use the correct abckground color for transparent background. Must be before colorscheme solarized
let g:solarized_visibility="low"
colorscheme solarized

hi Pmenu ctermul=2
hi Pmenu cterm=bold
hi Pmenu ctermfg=Black
hi Pmenu ctermbg=Gray

highlight SpellBad ctermfg=red ctermbg=gray

"let &t_SI.="\e[5 q"
"let &t_SR.="\e[4 q"
"let &t_EI.="\e[1 q"

"if has("autocmd")
  "let conEmuMacro = "!/mnt/c/utils/ConEmu/ConEmu/ConEmuC64.exe -guimacro setoption check"
  "let beamCursor = conEmuMacro . " 2531 " . "1 >/dev/null 2>&1 &"
  "let blockCursor = conEmuMacro . " 2532 " . "1 >/dev/null 2>&1 &"

  "au VimLeave * silent execute beamCursor | redraw!
  "au VimEnter * silent execute blockCursor | redraw!

  "au InsertEnter * silent execute beamCursor | redraw!
  "au InsertLeave * silent execute blockCursor | redraw!
"endif

"" OmniSharp won't work without this setting
"
"filetype plugin on
"
""let g:OmniSharp_server_type = 'roslyn'
"
""This is the default value, setting it isn't actually necessary
"let g:OmniSharp_host = "http://localhost:2000"
"
""Set the type lookup function to use the preview window instead of the status line
""let g:OmniSharp_typeLookupInPreview = 1
"
""Timeout in seconds to wait for a response from the server
"let g:OmniSharp_timeout = 1
"
""Showmatch significantly slows down omnicomplete
""when the first match contains parentheses.
"set noshowmatch
"
""Super tab settings - uncomment the next 4 lines
""let g:SuperTabDefaultCompletionType = 'context'
""let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
""let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
""let g:SuperTabClosePreviewOnPopupClose = 1
"
""don't autoselect first item in omnicomplete, show if only one item (for preview)
""remove preview if you don't want to see any documentation whatsoever.
"set completeopt=longest,menuone,preview
"" Fetch full documentation during omnicomplete requests.
"" There is a performance penalty with this (especially on Mono)
"" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
"" you need it with the :OmniSharpDocumentation command.
"" let g:omnicomplete_fetch_documentation=1
"
""Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
""You might also want to look at the echodoc plugin
"set splitbelow
"
"" Get Code Issues and syntax errors
"let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
"" If you are using the omnisharp-roslyn backend, use the following
"" let g:syntastic_cs_checkers = ['code_checker']
"augroup omnisharp_commands
"    autocmd!
"
"    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
"    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
"
"    " Synchronous build (blocks Vim)
"    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
"    " Builds can also run asynchronously with vim-dispatch installed
"    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
"    " automatic syntax check on events (TextChanged requires Vim 7.4)
"    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
"
"    " Automatically add new cs files to the nearest project on save
"    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
"
"    "show type information automatically when the cursor stops moving
"    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"
"    "The following commands are contextual, based on the current cursor position.
"
"    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
"    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
"    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
"    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
"    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
"    "finds members in the current buffer
"    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
"    " cursor can be anywhere on the line containing an issue
"    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
"    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
"    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
"    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
"    "navigate up by method/property/field
"    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
"    "navigate down by method/property/field
"    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
"
"augroup END
"
"
"" this setting controls how long to wait (in ms) before fetching type / symbol information.
"set updatetime=500
"" Remove 'Press Enter to continue' message when type information is longer than one line.
"set cmdheight=2
"
"" Contextual code actions (requires CtrlP or unite.vim)
"nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
"" Run code actions with text selected in visual mode to extract method
"vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>
"
"" rename with dialog
"nnoremap <leader>nm :OmniSharpRename<cr>
"nnoremap <F2> :OmniSharpRename<cr>
"" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
"command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
"
"" Force OmniSharp to reload the solution. Useful when switching branches etc.
"nnoremap <leader>rl :OmniSharpReloadSolution<cr>
"nnoremap <leader>cf :OmniSharpCodeFormat<cr>
"" Load the current .cs file to the nearest project
"nnoremap <leader>tp :OmniSharpAddToProject<cr>
"
"" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
"nnoremap <leader>ss :OmniSharpStartServer<cr>
"nnoremap <leader>sp :OmniSharpStopServer<cr>
"
"" Add syntax highlighting for types and interfaces
"nnoremap <leader>th :OmniSharpHighlightTypes<cr>
""Don't ask to save when changing buffers (i.e. when jumping to a type definition)
"set hidden
"
"" Enable snippet completion, requires completeopt-=preview
"let g:OmniSharp_want_snippet=1
