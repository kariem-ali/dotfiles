" Hearth: a warm, low-glare dark colour scheme for long reading sessions.
" The vim twin of the Hearth kitty theme (kitty-config, kitty/hearth-theme.conf):
" the same palette and the same goals.
"
" Design goals
"   * Deep warm charcoal background (not pure black): less halation around text
"   * Parchment text at ~12.5:1 contrast: crisp, without the harsh 15-20:1 of white on black
"   * Muted, desaturated accents (all >= 6:1), so colour carries meaning without
"     shouting; nothing neon
"   * Dim text (comments, line numbers, hints) kept >= 5.5:1, so it stays readable
"   * No italics; bold only where kitty would show it (titles, the current line number)
"
" Exact colours need 'termguicolors' (the .vimrc turns it on where the terminal
" supports true colour). Without it, the scheme uses the terminal's 16 ANSI colours,
" which are Hearth's own when the terminal runs the Hearth theme.
"
" Palette (name, hex, and the ANSI number used without 'termguicolors')
"   text        #E3DBCD  (terminal default)   background  #1D1B18  (terminal default)
"   bright text #EDE6DA  15                   surface     #3A3631  0   (menus, faint marks)
"   soft text   #C7BEAF  7                    border      #36322C      (status line)
"   dim text    #A0978A  8   (comments,       dark        #161512      (tab bar, inactive status)
"                             line numbers)
"   muted text  #9A9083      (inactive tabs)  brass       #8C7A5B      (tabs, trailing spaces)
"   cursor      #C7A56E                       selection   #EDE6DA on #3D4650
"   terracotta  #D98C7E  1   / #E89F91 9      sage        #A8BB84  2   / #B9CC94 10
"   wheat       #D9B776  3   / #E8C88A 11     dusk        #8FADD0  4   / #A3BEDD 12
"   heather     #C49DC0  5   / #D4AFD0 13     sea glass   #8EC1B4  6   / #A1D1C4 14
"
" Every group sets gui= and cterm= explicitly: with 'termguicolors' vim still uses the
" cterm= attributes, so nothing (bold, reverse, italic) carries over from another scheme.

set background=dark
highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'hearth'

" :terminal windows get Hearth's 16 colours (only used with true colour or in the GUI)
if (has('termguicolors') && &termguicolors) || has('gui_running')
  let g:terminal_ansi_colors = [
        \ '#3A3631', '#D98C7E', '#A8BB84', '#D9B776', '#8FADD0', '#C49DC0', '#8EC1B4', '#C7BEAF',
        \ '#A0978A', '#E89F91', '#B9CC94', '#E8C88A', '#A3BEDD', '#D4AFD0', '#A1D1C4', '#EDE6DA']
endif

" --- Text --------------------------------------------------------------------
hi Normal         guifg=#E3DBCD guibg=#1D1B18 gui=NONE      ctermfg=NONE ctermbg=NONE cterm=NONE
hi Terminal       guifg=#E3DBCD guibg=#1D1B18 gui=NONE      ctermfg=NONE ctermbg=NONE cterm=NONE

" --- Syntax ------------------------------------------------------------------
" Comments: dim and plain (no italics)
hi Comment        guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
" Keywords and control flow: terracotta
hi Statement      guifg=#D98C7E guibg=NONE    gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE
" Operators and names stay in the text colour, so code doesn't turn into confetti
hi Operator       guifg=#E3DBCD guibg=NONE    gui=NONE      ctermfg=NONE ctermbg=NONE cterm=NONE
hi Identifier     guifg=#E3DBCD guibg=NONE    gui=NONE      ctermfg=NONE ctermbg=NONE cterm=NONE
" Brackets and separators slightly softer than the text
hi Delimiter      guifg=#C7BEAF guibg=NONE    gui=NONE      ctermfg=7    ctermbg=NONE cterm=NONE
" Strings: sage
hi String         guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi Character      guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
" Other constants (numbers, booleans): heather
hi Constant       guifg=#C49DC0 guibg=NONE    gui=NONE      ctermfg=5    ctermbg=NONE cterm=NONE
" Types: wheat
hi Type           guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
" Functions: dusk
hi Function       guifg=#8FADD0 guibg=NONE    gui=NONE      ctermfg=4    ctermbg=NONE cterm=NONE
" Preprocessor, imports, escapes and other specials: sea glass
hi PreProc        guifg=#8EC1B4 guibg=NONE    gui=NONE      ctermfg=6    ctermbg=NONE cterm=NONE
hi Special        guifg=#8EC1B4 guibg=NONE    gui=NONE      ctermfg=6    ctermbg=NONE cterm=NONE
hi Tag            guifg=#8FADD0 guibg=NONE    gui=NONE      ctermfg=4    ctermbg=NONE cterm=NONE
hi Underlined     guifg=#8FADD0 guibg=NONE    gui=underline ctermfg=4    ctermbg=NONE cterm=underline
hi Todo           guifg=#E8C88A guibg=NONE    gui=bold      ctermfg=11   ctermbg=NONE cterm=bold
hi Error          guifg=#1D1B18 guibg=#E89F91 gui=NONE      ctermfg=0    ctermbg=9    cterm=NONE
hi Ignore         guifg=#3A3631 guibg=NONE    gui=NONE      ctermfg=0    ctermbg=NONE cterm=NONE
hi Debug          guifg=#D98C7E guibg=NONE    gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE
hi Title          guifg=#8FADD0 guibg=NONE    gui=bold      ctermfg=4    ctermbg=NONE cterm=bold
hi Directory      guifg=#8FADD0 guibg=NONE    gui=NONE      ctermfg=4    ctermbg=NONE cterm=NONE

" --- Gutter and invisible characters -----------------------------------------
hi LineNr         guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi CursorLineNr   guifg=#C7A56E guibg=NONE    gui=bold      ctermfg=3    ctermbg=NONE cterm=bold
hi SignColumn     guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi FoldColumn     guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi Folded         guifg=#C7BEAF guibg=#292723 gui=NONE      ctermfg=7    ctermbg=0    cterm=NONE
" Faint: line ends (¬), the wrap markers (‹ ›) and ~ after the end of the file
hi NonText        guifg=#3A3631 guibg=NONE    gui=NONE      ctermfg=0    ctermbg=NONE cterm=NONE
hi EndOfBuffer    guifg=#3A3631 guibg=NONE    gui=NONE      ctermfg=0    ctermbg=NONE cterm=NONE
" Readable (kitty's active border colour): tabs (▸) and trailing spaces (•)
hi SpecialKey     guifg=#8C7A5B guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi Conceal        guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi ColorColumn    guifg=NONE    guibg=#161512 gui=NONE      ctermfg=NONE ctermbg=0    cterm=NONE
hi CursorLine     guifg=NONE    guibg=#292723 gui=NONE      ctermfg=NONE ctermbg=NONE cterm=NONE
hi CursorColumn   guifg=NONE    guibg=#292723 gui=NONE      ctermfg=NONE ctermbg=0    cterm=NONE

" --- Cursor, selection, search -----------------------------------------------
" The terminal draws its own cursor (kitty: #C7A56E); these only apply in the GUI.
hi Cursor         guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi lCursor        guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi CursorIM       guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi Visual         guifg=#EDE6DA guibg=#3D4650 gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE
hi VisualNOS      guifg=#EDE6DA guibg=#3D4650 gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE
hi Search         guifg=#1D1B18 guibg=#8FADD0 gui=NONE      ctermfg=0    ctermbg=12   cterm=NONE
hi CurSearch      guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=11   cterm=NONE
hi IncSearch      guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=11   cterm=NONE
hi MatchParen     guifg=#E8C88A guibg=#3A3631 gui=bold      ctermfg=11   ctermbg=0    cterm=bold
hi QuickFixLine   guifg=#EDE6DA guibg=#3D4650 gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE

" --- Status line, tabs, window separators ------------------------------------
hi StatusLine       guifg=#E3DBCD guibg=#36322C gui=NONE    ctermfg=15   ctermbg=0    cterm=NONE
hi StatusLineNC     guifg=#9A9083 guibg=#161512 gui=NONE    ctermfg=7    ctermbg=0    cterm=NONE
hi StatusLineTerm   guifg=#E3DBCD guibg=#36322C gui=NONE    ctermfg=15   ctermbg=0    cterm=NONE
hi StatusLineTermNC guifg=#9A9083 guibg=#161512 gui=NONE    ctermfg=7    ctermbg=0    cterm=NONE
hi VertSplit        guifg=#36322C guibg=NONE    gui=NONE    ctermfg=0    ctermbg=NONE cterm=NONE
" Tab line as kitty draws its tab bar
hi TabLine          guifg=#9A9083 guibg=#161512 gui=NONE    ctermfg=7    ctermbg=0    cterm=NONE
hi TabLineFill      guifg=#9A9083 guibg=#161512 gui=NONE    ctermfg=7    ctermbg=0    cterm=NONE
hi TabLineSel       guifg=#1D1B18 guibg=#C7A56E gui=NONE    ctermfg=0    ctermbg=3    cterm=NONE
hi ToolbarLine      guifg=NONE    guibg=#161512 gui=NONE    ctermfg=NONE ctermbg=0    cterm=NONE
hi ToolbarButton    guifg=#1D1B18 guibg=#C7A56E gui=NONE    ctermfg=0    ctermbg=3    cterm=NONE

" --- Menus and popups --------------------------------------------------------
hi Pmenu          guifg=#E3DBCD guibg=#3A3631 gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE
hi PmenuSel       guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi PmenuKind      guifg=#A3BEDD guibg=#3A3631 gui=NONE      ctermfg=12   ctermbg=0    cterm=NONE
hi PmenuKindSel   guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi PmenuExtra     guifg=#C7BEAF guibg=#3A3631 gui=NONE      ctermfg=7    ctermbg=0    cterm=NONE
hi PmenuExtraSel  guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi PmenuMatch     guifg=#E8C88A guibg=#3A3631 gui=NONE      ctermfg=11   ctermbg=0    cterm=NONE
hi PmenuMatchSel  guifg=#1D1B18 guibg=#C7A56E gui=bold      ctermfg=0    ctermbg=3    cterm=bold
hi PmenuSbar      guifg=NONE    guibg=#292723 gui=NONE      ctermfg=NONE ctermbg=0    cterm=NONE
hi PmenuThumb     guifg=NONE    guibg=#8C7A5B gui=NONE      ctermfg=NONE ctermbg=8    cterm=NONE
hi WildMenu       guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi PopupNotification guifg=#E3DBCD guibg=#3A3631 gui=NONE   ctermfg=15   ctermbg=0    cterm=NONE
hi PopupSelected  guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi MessageWindow  guifg=#E3DBCD guibg=#3A3631 gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE

" --- Messages ----------------------------------------------------------------
hi ErrorMsg       guifg=#E89F91 guibg=NONE    gui=bold      ctermfg=9    ctermbg=NONE cterm=bold
hi WarningMsg     guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
hi MoreMsg        guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi Question       guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi ModeMsg        guifg=#E3DBCD guibg=NONE    gui=bold      ctermfg=NONE ctermbg=NONE cterm=bold

" --- Spelling: coloured wavy underlines (plain underlines where the terminal has none)
hi SpellBad       guifg=NONE guibg=NONE gui=undercurl guisp=#D98C7E ctermfg=NONE ctermbg=NONE cterm=undercurl
hi SpellCap       guifg=NONE guibg=NONE gui=undercurl guisp=#8FADD0 ctermfg=NONE ctermbg=NONE cterm=undercurl
hi SpellRare      guifg=NONE guibg=NONE gui=undercurl guisp=#C49DC0 ctermfg=NONE ctermbg=NONE cterm=undercurl
hi SpellLocal     guifg=NONE guibg=NONE gui=undercurl guisp=#8EC1B4 ctermfg=NONE ctermbg=NONE cterm=undercurl

" --- Diffs -------------------------------------------------------------------
" vimdiff: faint tints of sage / dusk / terracotta behind normal text. Without true
" colour there are no tints to use, so added and removed lines are told apart by text colour.
hi DiffAdd        guifg=NONE    guibg=#303127 gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi DiffChange     guifg=NONE    guibg=#282A2A gui=NONE      ctermfg=NONE ctermbg=0    cterm=NONE
hi DiffText       guifg=NONE    guibg=#3A4046 gui=NONE      ctermfg=0    ctermbg=11   cterm=NONE
hi DiffDelete     guifg=#E89F91 guibg=#372B26 gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE
" Diff and patch files, git output, fugitive
hi Added          guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi Changed        guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
hi Removed        guifg=#D98C7E guibg=NONE    gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE
hi diffAdded      guifg=#A8BB84 guibg=NONE    gui=NONE      ctermfg=2    ctermbg=NONE cterm=NONE
hi diffRemoved    guifg=#D98C7E guibg=NONE    gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE
hi diffChanged    guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
hi diffLine       guifg=#8FADD0 guibg=NONE    gui=NONE      ctermfg=4    ctermbg=NONE cterm=NONE
hi diffSubname    guifg=#C7BEAF guibg=NONE    gui=NONE      ctermfg=7    ctermbg=NONE cterm=NONE
hi diffFile       guifg=#D9B776 guibg=NONE    gui=bold      ctermfg=3    ctermbg=NONE cterm=bold
hi diffOldFile    guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
hi diffNewFile    guifg=#D9B776 guibg=NONE    gui=NONE      ctermfg=3    ctermbg=NONE cterm=NONE
hi diffIndexLine  guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
hi diffComment    guifg=#A0978A guibg=NONE    gui=NONE      ctermfg=8    ctermbg=NONE cterm=NONE
" Trailing spaces on added lines (the .vimrc's diff/patch rule)
hi WhiteSpaceEOL  guifg=NONE    guibg=#D98C7E gui=NONE      ctermfg=NONE ctermbg=1    cterm=NONE
" Commit messages: text past the summary length
hi gitcommitOverflow guifg=#D98C7E guibg=NONE gui=NONE      ctermfg=1    ctermbg=NONE cterm=NONE

" --- Debugger (:Termdebug) ---------------------------------------------------
hi debugPC         guifg=NONE    guibg=#3D4650 gui=NONE     ctermfg=NONE ctermbg=0    cterm=NONE
hi debugBreakpoint guifg=#1D1B18 guibg=#E89F91 gui=NONE     ctermfg=0    ctermbg=9    cterm=NONE

" --- ctrlp -------------------------------------------------------------------
" Matched characters, and the mode indicators in its status line (kitty's tab colours)
hi CtrlPMatch     guifg=#E8C88A guibg=NONE    gui=NONE      ctermfg=11   ctermbg=NONE cterm=NONE
hi CtrlPMode1     guifg=#1D1B18 guibg=#C7A56E gui=NONE      ctermfg=0    ctermbg=3    cterm=NONE
hi CtrlPMode2     guifg=#E3DBCD guibg=#36322C gui=NONE      ctermfg=15   ctermbg=0    cterm=NONE
hi! link CtrlPStats StatusLine

" --- coc.nvim ----------------------------------------------------------------
" coc only fills in groups a scheme leaves undefined; its own defaults are bright
" (#ff0000 signs, #15aabf links) and in vim all diagnostics share one plain underline.
" Diagnostics: terracotta errors, wheat warnings, dusk info, sea glass hints
hi CocErrorSign       guifg=#D98C7E guibg=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi CocWarningSign     guifg=#D9B776 guibg=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi CocInfoSign        guifg=#8FADD0 guibg=NONE gui=NONE ctermfg=4 ctermbg=NONE cterm=NONE
hi CocHintSign        guifg=#8EC1B4 guibg=NONE gui=NONE ctermfg=6 ctermbg=NONE cterm=NONE
hi CocErrorHighlight   guifg=NONE guibg=NONE gui=undercurl guisp=#D98C7E ctermfg=NONE ctermbg=NONE cterm=undercurl
hi CocWarningHighlight guifg=NONE guibg=NONE gui=undercurl guisp=#D9B776 ctermfg=NONE ctermbg=NONE cterm=undercurl
hi CocInfoHighlight    guifg=NONE guibg=NONE gui=undercurl guisp=#8FADD0 ctermfg=NONE ctermbg=NONE cterm=undercurl
hi CocHintHighlight    guifg=NONE guibg=NONE gui=undercurl guisp=#8EC1B4 ctermfg=NONE ctermbg=NONE cterm=undercurl
hi! link CocErrorVirtualText   CocErrorSign
hi! link CocWarningVirtualText CocWarningSign
hi! link CocInfoVirtualText    CocInfoSign
hi! link CocHintVirtualText    CocHintSign
hi CocErrorFloat      guifg=#E89F91 guibg=#3A3631 gui=NONE ctermfg=9  ctermbg=0 cterm=NONE
hi CocWarningFloat    guifg=#E8C88A guibg=#3A3631 gui=NONE ctermfg=11 ctermbg=0 cterm=NONE
hi CocInfoFloat       guifg=#A3BEDD guibg=#3A3631 gui=NONE ctermfg=12 ctermbg=0 cterm=NONE
hi CocHintFloat       guifg=#A1D1C4 guibg=#3A3631 gui=NONE ctermfg=14 ctermbg=0 cterm=NONE
hi CocUnderline       guifg=NONE guibg=NONE gui=underline guisp=#E3DBCD ctermfg=NONE ctermbg=NONE cterm=underline
" Popups, the completion menu and lists: the same surface as vim's own menu
hi! link CocFloating  Pmenu
hi CocFloatBorder     guifg=#8C7A5B guibg=#3A3631 gui=NONE ctermfg=8 ctermbg=0 cterm=NONE
hi! link CocFloatSbar  PmenuSbar
hi! link CocFloatThumb PmenuThumb
hi! link CocFloatDividingLine CocFloatBorder
hi! link CocMenuSel   PmenuSel
hi CocPumSearch       guifg=#E8C88A guibg=NONE gui=NONE ctermfg=11 ctermbg=NONE cterm=NONE
hi CocPumDetail       guifg=#C7BEAF guibg=NONE gui=NONE ctermfg=7  ctermbg=NONE cterm=NONE
hi! link CocPumShortcut CocPumDetail
hi CocSearch          guifg=#A3BEDD guibg=NONE gui=NONE ctermfg=12 ctermbg=NONE cterm=NONE
hi! link CocListLine  CursorLine
hi! link CocTreeSelected CursorLine
" Hints shown inside the text: dim, like comments
hi CocVirtualText       guifg=#A0978A guibg=NONE gui=NONE ctermfg=8 ctermbg=NONE cterm=NONE
hi! link CocInlineVirtualText CocVirtualText
hi! link CocInlayHint         CocVirtualText
hi! link CocCodeLens          CocVirtualText
hi CocDisabled          guifg=#A0978A guibg=NONE gui=NONE ctermfg=8 ctermbg=NONE cterm=NONE
" References to the symbol under the cursor: a faint background
hi CocHighlightText     guifg=NONE guibg=#312E2A gui=NONE ctermfg=NONE ctermbg=0 cterm=NONE
" Links, selected text, progress
hi CocLink              guifg=NONE guibg=NONE gui=underline guisp=#8FADD0 ctermfg=NONE ctermbg=NONE cterm=underline
hi CocMarkdownLink      guifg=#8FADD0 guibg=NONE gui=underline ctermfg=4 ctermbg=NONE cterm=underline
hi CocSelectedText      guifg=#D98C7E guibg=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi CocNotificationProgress guifg=#8FADD0 guibg=NONE gui=NONE ctermfg=4 ctermbg=NONE cterm=NONE
hi CocNextEditInsert    guifg=#A8BB84 guibg=#303127 gui=NONE ctermfg=2 ctermbg=NONE cterm=NONE
hi CocNextEditDelete    guifg=#E89F91 guibg=#372B26 gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE

" No italics, including coc's (markdown emphasis in hover text): shown as plain popup text.
" It needs a colour; a group with only NONE counts as unset, and coc then makes it italic.
hi CocItalic          guifg=#E3DBCD guibg=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE

" Without true colour there is no faint background for the cursor line, so underline it.
" (vim applies cterm= attributes with 'termguicolors' too, so only set it in this case.)
if !&termguicolors && !has('gui_running')
  hi CursorLine cterm=underline
endif

" Underline colours without true colour (vim 8.2.0863 and later)
if has('patch-8.2.0863')
  hi SpellBad   ctermul=1
  hi SpellCap   ctermul=4
  hi SpellRare  ctermul=5
  hi SpellLocal ctermul=6
  hi CocErrorHighlight   ctermul=1
  hi CocWarningHighlight ctermul=3
  hi CocInfoHighlight    ctermul=4
  hi CocHintHighlight    ctermul=6
endif
