set ai
set smartindent
set tabstop=4
set shiftwidth=4
set et
set ic
:set nosm
set hls
set is
set mouse=""
set ru
set nrformats=hex,alpha
set ul=100
set nu
"set backupdir=d:/Temp
syntax on

set ttimeout ttimeoutlen=50

hi Normal guibg=White guifg=Black
hi DiffText term=bold guibg=cyan guifg=black
""""""""""""
" VIM-PLUG "
""""""""""""

" Auto-installs vim-plug if it's not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" Place any and all vim-plug plugins here
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
if has("nvim")
    Plug 'Shougo/deoplete.nvim'
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh',}
	Plug 'tweekmonster/deoplete-clang2'
endif
Plug 'junegunn/goyo.vim', {'on': 'Goyo' }
Plug 'junegunn/limelight.vim', {'on': 'Limelight' }
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
" Any vim-plug plugins must come before this point
call plug#end()
""""""""""""""""""""""""""
" Plug Explanations
"
" Gruvbox-      Vim colorscheme
" Airline-      Vim status bar
" Nerdtree-     File explorer in vim
"                   Mapped to CTRL-T to open
" Fugitive-     Git Wrapper
" Tagbar-       File Tag Browser
"                   You must have CTags
" Goyo-         Distraction free Vim
" Limelight-    Hyperfocus-writing in Vim
"                   Autoruns when you use Goyo
" fzf           fzf finder
""""""""""""""""""""""""""
"""""""""""""""""""""""""""
" GENERIC GLOBAL SETTINGS "
"""""""""""""""""""""""""""

" Enables true color if available
if has("termguicolors")
    set termguicolors
endif
set background=dark " Set colors to match a dark background
syntax on           " Syntax highlighting
set number          " Show line numbers
set norelativenumber  " Show distance instead of absolute numbers
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set noincsearch		" Incremental search
set nohlsearch      " Don't highlight search matches
set hidden	    	" Hide buffers when they are abandoned
set mouse=n 		" Enable mouse only in normal mode
set encoding=utf-8  " Enable supprt for unicode characters
set clipboard=unnamedplus

" Sets up tabbing stuff
set expandtab       " Tab is spaces instead of a single tab character
set tabstop=4       " Tabs are viewed as 4 spaced
set softtabstop=4   " Tabs are inserted as 4 spaces
set shiftwidth=4    " Auto tabbing uses 4 spaces
set autoindent      " Automatically indents lines according to previous indent
set smartindent     " Context sensitive indentation (e.g. Indent again after {)

" Have Vim jump to the last position when opening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins
if has("autocmd")
    filetype plugin indent on
endif

autocmd BufNewFile,BufRead *.e set filetype=c

" PEP8 specifies a max line length of 79 characters
autocmd FileType python setlocal colorcolumn=80

" Automatically show trailing whitespace if not typing
autocmd BufWinEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufWinLeave * call clearmatches()
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=White guibg=red

"""""""""""""""""""
" PLUGIN SETTINGS "
"""""""""""""""""""

" Color options
" Set the colorscheme to gruvbox (all gruvbox options must come before
" colorscheme gruvbox)
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=0
colorscheme gruvbox
hi clear CursorLine
hi CursorLineNr cterm=bold
set cursorline
"hi Normal guibg=NONE ctermbg=NONE

" Stuff to make sure airline works
set laststatus=2                    " Always show status bar
set t_Co=256                        " Use 256 colors in terminal
set timeoutlen=500                  " Update mode quicker
let g:airline_powerline_fonts = 1   " Use powerline fonts
set noshowmode                      " The next three just remove a bunch of repeated info from the command line
set noruler
set noshowcmd
let g:airline_theme='gruvbox'       " Set airline theme

" Airline-Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1 " configure whether or not to show buffers on the tabline
let g:airline#extensions#tabline#buffer_nr_show = 1 " show the index of each buffer
let g:airline#extensions#tabline#tab_min_count = 2 " configure the minimum number of tabs needed to show the tabline.
let g:airline#extensions#tabline#show_close_button = 0 " configure whether or not to show the close button
let g:airline#extensions#tabline#fnamemod = ':t' " Only show the filename, not the path

" Show Neomake errors and warnings in airline
let g:airline#extensions#neomake#enabled = 1

" Neovim plugins (Deoplete, LanguageClient)
if has("nvim")
    " Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
    let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'
    let g:deoplete#omni_patterns = {}
    let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
    let g:deoplete#file#enable_buffer_path = 1
	call deoplete#custom#source("_", "matchers", ["matcher_full_fuzzy"])
	call deoplete#custom#source('clang2', 'min_pattern_length', 2)
    " deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"
    " Close preview window when completion is done
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    " <CR>: close popup and save indent.
    " Enter no longer autocompletes, but it does line break if the menu is open
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return deoplete#mappings#smart_close_popup() . "\<CR>"
    endfunction

    " LanguageClient
    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ }
    augroup LC_Bindings
        autocmd!
        autocmd User LanguageClientStarted nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
        autocmd User LanguageClientStarted nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    augroup END
    command Symbols call LanguageClient_textDocument_documentSymbol()
    command Refs call LanguageClient_textDocument_references()
    command Rename call LanguageClient_textDocument_rename()
endif

"""""""""""""""""""""""""""
"""" Limelight Specific""""
"""""""""""""""""""""""""""
" Color name (:help cterm-colors) or ANSI code
 let g:limelight_conceal_ctermfg = 'gray'
 let g:limelight_conceal_ctermfg = 240
"
" " Color name (:help gui-colors) or RGB color
 let g:limelight_conceal_guifg = 'DarkGray'
 let g:limelight_conceal_guifg = '#777777'
"
" Default: 0.5
 let g:limelight_default_coefficient = 0.7
"
" " Number of preceding/following paragraphs to include (default: 0)
 let g:limelight_paragraph_span = 1
"
" " Beginning/end of paragraph
" "   When there's no empty line between the paragraphs
" "   and each paragraph starts with indentation
 let g:limelight_bop = '^\s'
 let g:limelight_eop = '\ze\n^\s'
"
" " Highlighting priority (default: 10)
" "   Set it to -1 not to overrule hlsearch
 let g:limelight_priority = -1

 autocmd! User GoyoEnter Limelight
 autocmd! User GoyoLeave Limelight!
""""""""""""""""
" KEY MAPPINGS "
""""""""""""""""
" Map Control-N to toggle NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-c> :TagbarToggle<CR>
" Map Control-G to toggle Goyo
nnoremap <C-g> :Goyo<CR>
" Capitalize the last word written or the word the cursor is currently on
" Insert a standard empty C-style for-loop
inoremap <C-f> for (int i = 0; i < ; i++) {<CR>}<Esc>k$F;i
command NumberLines %s/^/\=printf('%3d ', line('.'))
