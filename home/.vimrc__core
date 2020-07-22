" Description
" fkha: Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              
"              on this file is still a good idea.

"------------------------------------------------------------
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
" Credits to Valthor Halldórsson
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Load Dependencies                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
filetype off
function! EnsureDirExists(dir)
    if !isdirectory(a:dir)
        call mkdir(a:dir, "p")
    endif
endfunction


call EnsureDirExists($HOME . '/.vim')
call EnsureDirExists($HOME . '/.vim/tmp/undo')
call EnsureDirExists($HOME . '/.vim/tmp/backup')
call EnsureDirExists($HOME . '/.vim/tmp/swap')
call EnsureDirExists($HOME . '/.vim/tmp/junk')
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Load Modules                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')
" vim: set filetype=vim : 
"
" Visual Marks
Plug 'kshenoy/vim-signature'
Plug 'takac/vim-hardtime'

" Orgmode
Plug 'jceb/vim-orgmode'
" vim bufexplorer
" Plug 'jlanzarotta/bufexplorer'

"FuzzyFinder
" NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"NeoBundle 'junegunn/fzf'
"Surround
Plug 'tpope/vim-surround'

"Plug 'lilydjwg/colorizer'
" Commenting
Plug 'tpope/vim-commentary'
" Automatic Closing Brackets
Plug 'raimondi/delimitmate'
" Fugitive, git handler
Plug 'tpope/vim-fugitive'
" 
Plug 'crusoexia/vim-monokai'

Plug 'derekwyatt/vim-scala'

Plug 'PeterRincker/vim-argumentative'

Plug 'vim-airline/vim-airline'
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline-themes'

"Plug 'autozimu/LanguageClient-neovim'
Plug 'dag/vim-fish'
Plug 'preservim/nerdtree'
" Fuzzy Finder
Plug 'kien/ctrlp.vim'

Plug 'easymotion/vim-easymotion'

Plug 'godlygeek/tabular'
" Substitute preview
Plug 'osyo-manga/vim-over'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

Plug 'tpope/vim-unimpaired'
" Language Server #############################
"Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
" (Optional) Multi-entry selection UI.
Plug 'Shougo/denite.nvim'

" Completion from other opened files
Plug 'Shougo/context_filetype.vim'
" Python autocompletion
Plug 'zchee/deoplete-jedi', { 'do': ':UpdateRemotePlugins' }
" Just to add the python go-to-definition and similar features, autocompletion
" from this plugin is disabled
Plug 'davidhalter/jedi-vim'

Plug 'sheerun/vim-polyglot'

" Linters
Plug 'neomake/neomake'

" (Optional) Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'



" END Language Server ########################

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Sidebar with functions summary
"
Plug 'majutsushi/tagbar'
Plug 'rargo/vim-line-jump'
" HTML 
Plug 'mattn/emmet-vim'

"Unite
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'vim-scripts/bash-support.vim'
Plug 'Shougo/vimfiler.vim'

"JsBeautify
Plug 'maksimr/vim-jsbeautify'

" treat .vue as .html
"au BufRead,BufNewFile *.vue set ft=html
" Track the engine.  lug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.


" Haskell
" Make sure to install ghc-mod for syntax
" highlighting with 'cabal install ghc-mod'
" Plug 'neovimhaskell/haskell-vim.git'

Plug 'eagletmt/ghcmod-vim'

" Multiple Cursors
Plug 'terryma/vim-multiple-cursors'

"Tmux and Vim navigation
Plug 'christoomey/vim-tmux-navigator'


call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Plugin Settings                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Default


"" HardTime
" let g:hardtime_default_on = 1
let g:hardtime_maxcount = 3
let g:hardtime_timeout = 1000


"" Ctrl-P
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_map = '<c-f>'


"" Deoplete
if has("nvim")
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    " " complete with words from any opened file
    let g:context_filetype#same_filetypes = {}
    let g:context_filetype#same_filetypes._ = '_'
    set completeopt+=noinsert
    "" Jedi-vim

    " Disable autocompletion (using deoplete instead)
    let g:jedi#completions_enabled = 0

    " All these mappings work only for python code:
    " Go to definition
    let g:jedi#goto_command = ',d'
    " Find ocurrences
    let g:jedi#usages_command = ',o'
    " Find assignments
    let g:jedi#goto_assignments_command = ',a'
    " Go to definition in new tab
    nmap ,D :tab split<CR>:call jedi#goto()<CR>
endif

"" UltiSnips
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/bundle/vim-snippets/UltiSnips', 'UltiSnips']
" If you want :UltiSnipsEdit to split your window.
"
let g:UltiSnipsEditSplit="vertical"

"" Multiple Cursors
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-k>'
let g:multi_cursor_select_all_word_key = '<A-k>'
let g:multi_cursor_start_key           = 'g<C-k>'
let g:multi_cursor_select_all_key      = 'g<A-k>'
let g:multi_cursor_next_key            = '<C-k>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

"" YouCompleteMe
"let g:ycm_show_diagnostics_ui = 1

"" NerdTree
"default g:NERDTreeMapToggleFilters key map is 'f', change it to some key else.
let g:NERDTreeMapToggleFilters="0"
let NERDTreeShowHidden=1

"LineJump NERDTree key map
"augroup LineJumpNerdTree
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> f <ESC>:silent! call LineJumpSelectForward()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> ; <ESC>:silent! call LineJumpMoveForward()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> b <ESC>:silent! call LineJumpSelectBackward()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> , <ESC>:silent! call LineJumpMoveBackward()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gh <ESC>:silent! call LineJumpMoveTop()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gm <ESC>:silent! call LineJumpMoveMiddle()<cr>
"	autocmd BufEnter NERD_tree_\d\+ nnoremap <buffer> <nowait> <silent> gl <ESC>:silent! call LineJumpMoveBottom()<cr>
"augroup END
"" Tagbar
" LineJump Tagbar key map
let g:tagbar_autofocus = 1

augroup LineJumpTagbar
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> f <ESC>:silent! call LineJumpSelectForward()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> ; <ESC>:silent! call LineJumpMoveForward()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> b <ESC>:silent! call LineJumpSelectBackward()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> , <ESC>:silent! call LineJumpMoveBackward()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gh <ESC>:silent! call LineJumpMoveTop()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gm <ESC>:silent! call LineJumpMoveMiddle()<cr>
	autocmd BufEnter __Tagbar__ nnoremap <buffer> <nowait> <silent> gl <ESC>:silent! call LineJumpMoveBottom()<cr>
augroup END
"" Language Server
let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ }
" Required for operations modifying multiple buffers like rename.
set hidden


" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>


"" Neoclide 
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

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

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               General Config                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Must have options {{{1
"------------------------------------------------------------
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden


" use undo/backup/swap files
set undofile

" set a directory to store the undo history
set undodir=~/.vim/tmp/undo/
set backupdir=~/.vim/tmp/backup/
set directory=~/.vim/tmp/swap/


"
"
" 
" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall
"
" Better command-line completion
set wildmenu
"
"
"" Show partial commands in the last line of the screen
set noshowmode
set showcmd
" 
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
" 
" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline
" 
"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.
"
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
" 
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" 
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
" 
" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
" 
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
" 
" Always display the status line, even if only one window is displayed
set laststatus=2
" 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" 
" Use visual bell instead of beeping when doing something wrong
set visualbell
" 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
" 
" Enable use of the mouse for all modes
set mouse=a
" 
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=1
" 
"" Display line numbers on the left
set number
" 
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
" 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>
" Indentation options {{{1
"
" Indentation settings according to personal preference.
"
" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
" 
" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
set shiftwidth=4
set softtabstop=4
set expandtab

"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Color                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax on
set t_Co=256
set t_ut=

set clipboard=unnamed
syntax enable
set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Keybindings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Other
" Do not yank on paste
vnoremap p "_dP
noremap ( (zz
noremap ) )zz
noremap n nzz
noremap N Nzz
noremap <C-N> :bn<CR>
noremap <C-P> :bp<CR>
nnoremap * mz*`z
"
" Visual star
let g:visualstar_extra_commands = 'zzzv'

inoremap <F1> <NOP>
let mapleader=" "
noremap H ^
noremap L $
inoremap hh <ESC>
inoremap jk <ESC>
inoremap ii <ESC>

"iabbr std std::<c-r>=Eatchar('\m\s\<bar>/')<cr>
" noremap z 1@a
vnoremap <Space>= :!js-beautify<CR>
noremap ,, :e#<CR>
nmap <Space> <NOP>

noremap Y y$

noremap <Space>y "+y
noremap <Space>p "+p

noremap ,w :<C-u>w<CR>
noremap ,x :<C-u>x<CR>
noremap ,q :<C-u>q<CR>
noremap <leader>q :<C-u>q<CR>
noremap + mzggVG=`z
" Tagbar plugin
nmap <F8> :TagbarToggle<CR>
" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
"nnoremap <C-L> :nohl<CR><C-L>
"" Yapf

autocmd FileType python setlocal equalprg=yapf

"" Argumentative

xmap ia <Plug>Argumentative_InnerTextObject
xmap aa <Plug>Argumentative_OuterTextObject
omap ia <Plug>Argumentative_OpPendingInnerTextObject
omap aa <Plug>Argumentative_OpPendingOuterTextObject

"" Files

map ,ev :e ~/.vimrc<cr>
map ,lev :e ~/.local/.vimrc<cr>
map ,et :e ~/.tmux.conf<cr>
map ,sv :source ~/.vimrc<cr>
map ,t :NERDTreeToggle<cr>
map ,l :TagbarToggle<cr>
map ,ef :e ~/.vim/config/.folding.vimrc<CR>
nnoremap ,; m`A;<Esc>``

"" Surround
map sa yss
map sw ysiw
map sW ysW
map s ys
xmap s <Plug>VSurround

"" Window management & Navigation
noremap <leader>v :vsplit<cr>
noremap <leader>s :split<cr>
map <A-q> :q<CR>
" nmap <silent> <C-k> :wincmd k<CR>
" nmap <silent> <C-j> :wincmd j<CR>
" nmap <silent> <C-h> :wincmd h<CR>
" nmap <silent> <C-l> :wincmd l<CR>
" With this, iterm2 can send C-V as visual
command! VB exe "norm! \<C-V>"

"Better markbind
noremap <Space>m `
"" Move/Adjust Text/Rows
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j><Esc> :m .+1<CR>==gi
inoremap <A-k><Esc> :m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=ge

nnoremap <C-a> :%y+<CR>
vnoremap <C-a> :%y+<CR>
noremap ,b :e #<CR>
noremap ,d :bd<CR>
vnoremap <leader>t : Tabularize /
nnoremap <leader>t : Tabularize /

noremap <Space>L :<C-u>ll<CR>
"noremap <Space>b :<C-u>lprevious<CR>
"noremap <Space>f :<C-u>lnext<CR>

"" Plugin-Specific

" Vim-Over
noremap <Space>r :OverCommandLine<CR>%s/

" Easy Motion
" # Leader is Space
map <Leader>k <Plug>(easymotion-b)
map <Leader>j <Plug>(easymotion-w)
map s <Plug>(easymotion-sn)
" map <Leader>j <Plug>(easymotion-j)
" map <Leader>l <Plug>(easymotion-k)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Utils                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Remove trailing whitespace from abbreviations
" func! Eatchar(pat)
"     let c = nr2char(getchar(0))
"     return (c =~ a:pat) ? '' : c
" endfunc
"" Timeout Delay before registering
" let c='a'
" while c <= 'z'
"     exec "set <A-".c.">=\e".c
"     exec "imap \e".c." <A-".c.">"
"     let c = nr2char(1+char2nr(c))
" endw
set timeout ttimeoutlen=50


" This file contains settings that either needs to be loaded before addons
" addons or simply didn't fit in another module. General vim settings
set rtp+=~/.fzf
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set nocompatible
set foldmethod=indent   
set foldnestmax=10
let loaded_matchparen = 0
set iskeyword-=_
set iskeyword-=.
" Relative line numbers
set rnu
"set nofoldenable
"
"
"
set incsearch

au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * :checktime
set autoread
set foldlevel=1
set modeline
set modelines=1
set cursorcolumn
set cursorline
colorscheme monokai

"set cursorline
let gotBundler=1

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               FileType Config                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



autocmd BufRead,BufNewFile *.py
      \ setlocal foldlevel=0
autocmd BufRead,BufNewFile *.vimrc
      \ setlocal foldlevel=0
autocmd BufRead,BufNewFile *.cheatsheet
      \ setlocal foldlevel=0
source ~/.vim/config/.folding.vimrc

"" Quickfix
function ClearQuickFix()
    syntax match ConcealedDetails /\v^[^|]*\|[^|]*\| / conceal
    set conceallevel=2
    set concealcursor=nvic
endfunction

nnoremap ,c :call ClearQuickFix()<CR>

autocmd QuickFixCmdPost * call ClearQuickFix()

autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall | q
  \| endif

" Quickly open a quickfix window with matches of 'pattern'
function! All___(pattern)
    echo a:pattern
    execute 'vimgrep '. a:pattern .' % | copen 30'
endfunction

" Vimgrep quickly
nnoremap ,g :call All___(input('Pattern: '))<CR>

" To avoid having non-user-defined functions being displayed 
" we suffix with '___'
nnoremap ,lf :filter /___/ function

if !empty(glob('~/.local/.vimrc'))
    source ~/.local/.vimrc
endif

 au BufNewFile,BufRead *.template set syntax=dosini
"if executable('shellcheck')
"    set makeprg=shellcheck\ -f\ gcc\ %
"    au BufWritePost * :silent make | redraw!
"    au QuickFixCmdPost [^l]* nested cwindow
"    au QuickFixCmdPost    l* nested lwindow
"endif
"
"
set clipboard=unnamedplus
"" Os Specifics
if has("win32")
  "Windows options here
else
  if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set clipboard=unnamed
    endif
  endif
endif

