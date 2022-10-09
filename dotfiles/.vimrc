set nocompatible                   " improved Vim experience
set encoding=utf-8 nobomb          " do not use BOM
scriptencoding utf-8               " utf-8 all the way
if has('eval')                     " Use 'cp1252' encoding instead of 'latin1'
    let &fileencodings=substitute(&fileencodings,'latin1','cp1252','')
endif
set fileformats=unix,dos,mac
set autoread                       " Automatically read outside changes to a file
set autowrite                      " Auto-save before commands like :next and :make
set hidden                         " Allow switch buffer without saving changes
set history=1000                   " Size of vim history
set clipboard=unnamed              " Yank to clipboard directly
set lazyredraw                     " See help
set noignorecase                   " Case insensitive search
set smartcase                      " Case insensitive searches become sensitive with capitals
set switchbuf=usetab
set nostartofline                  " Don't reset cursor to start of line when moving
set splitbelow                     " Open new horizontal split below the current window
set splitright                     " Open new vertical split rigth to the current window
set timeoutlen=1200                " A little bit more time for macros
set ttimeoutlen=50                 " Make Esc work faster

set backspace=indent,eol,start     " Enable <BS> in insert mode
set formatoptions-=t               " Disable auto-wrap text
set formatoptions-=c               " Disable auto-wrap comments
set formatoptions-=o               " Do not insert comment leader on hitting 'o'
set formatoptions+=j               " Delete comment character when joining commented lines
set nrformats-=octal               " Do not treat '007' as octal number on <C-A> or <C-X>

set autoindent                     " Automatically insert indent after new line
set smartindent                    " Make autoindent even better
set expandtab                      " Use spaces instead of tab
set shiftround                     " Round intent to multiple of 'shiftwidth'
set shiftwidth=4                   " Indent size in spaces for autoindent commands (>> CTRL-T)
set tabstop=4                      " Tab size in spaces

set wildmenu                       " Enhanced command line auto-complition
set wildmode=longest:full,full
set complete-=i                    " Disable parsing included files for autocompletion with <C-P> and <C-N> (:help 'include')
set completeopt-=preview           " Do not show preview window for selected autocomlete option
set completeopt+=menu              " Show select menu for autocomplete.
set completeopt+=menuone           " Show select menu even if autocomplete menu contains a single option
set completeopt+=longest           " Only inset the longest common text of the match
set completeopt+=noselect          " Do not autoselect autocomplete option from menu.

if exists('+breakindent')          " same as +linebreak
    set wrap linebreak breakindent " Wrap long lines of text and auto-indent (only visualy)
    set showbreak=+>\              " String to put at the start of lines that have been wrapped
else
    set nowrap                     " Do not wrap lines which longer then viewpoint width
endif
set relativenumber                 " Show line number relative to the current line
set number                         " Show current line number
set cursorline                     " Highlight of the current line
set scrolloff=2                    " Min number of screen lines to keep above and below the cursor
set sidescrolloff=5                " Min number of screen columns to keep to the left and to the right of cursor
set title                          " Show filename in the window titlebar
set showtabline=2                  " Always display the tabline
set laststatus=2                   " Always display the statusline
set cmdheight=1                    " Size of command line
set display+=lastline
set noshowcmd                      " Show (partial) command in status line
set incsearch                      " Highlight matches while typing search pattern
set hlsearch                       " Highlight search matches
set foldopen+=jump
set list                           " Show 'invisible' characters
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
    let &listchars="tab:\u25b8\u0020,trail:\u2423,eol:\u00ac,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u259a,fold:\u002d"
else
    set listchars=tab:>\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
endif

set dictionary+=/usr/share/dict/words
set tags=./tags,tags
set viminfo=!,'20,<50,s10,h,n~/.vim/viminfo
set backupdir^=~/.vim/backups
set directory^=~/.vim/swaps
if exists('+undofile')
    set undodir^=~/.vim/undo
endif
if !empty($SUDO_USER) && $USER !=# $SUDO_USER
    set viminfo=
endif

" Plugin settings
" Airline
let g:airline_section_z = '%#__accent_bold#%3l/%L%#__restore__# :%3v'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffers_label = 'bufs'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tagbar#flags = 's'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#virtualenv#enabled = 1
" CtrlP
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_by_filename = 0
let g:ctrlp_regexp = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_types = ['fil', 'mru']
" NERDCommenter
let g:NERDCompactSexyComs = 0
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespaces = 1
" Netrw
let g:netrw_liststyle = 1
" Syntax Highlight
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_conceal = 0

" Commands
command! -bar -nargs=1 Retab :call <SID>Retab_buffer(<f-args>)
function! s:Retab_buffer(ts)
    let l:ts=&tabstop
    let l:sts=&softtabstop
    execute 'setlocal tabstop='.a:ts.' softtabstop='.a:ts.' noexpandtab'
    silent retab!
    execute 'setlocal tabstop='.l:ts.' softtabstop='.l:sts.' expandtab'
    silent retab!
endfunction

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !mkdir -p ~/.vim/backups
    silent !mkdir -p ~/.vim/plug.vim.bundle
    silent !mkdir -p ~/.vim/swaps
    silent !mkdir -p ~/.vim/undo
    silent !wget -qO - 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > ~/.vim/autoload/plug.vim
    augroup PlugVimInstall
        autocmd!
        autocmd VimEnter * PlugInstall --sync
    augroup END
    source ~/.vimrc
endif
call plug#begin('~/.vim/plug.vim.bundle')

" Themes and color schemes
Plug 'morhetz/gruvbox'
Plug 'a1black/vim-hybrid'
" Statusline
Plug 'vim-airline/vim-airline'         " Better looking statusline
Plug 'vim-airline/vim-airline-themes'  " Themes fot statusline
" Syntax highlight
Plug 'chr4/nginx.vim'
Plug 'elzr/vim-json'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'vim-python/python-syntax'
" Filesystem and search
Plug 'tpope/vim-vinegar'               " Extension for built-in netrw plugin
Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy finder
" Editing tools
Plug 'scrooloose/nerdcommenter'        " Commenting tool
" Vim functionality enhancement
Plug 'easymotion/vim-easymotion'       " Enhanced motion in Vim
Plug 'tpope/vim-unimpaired'            " Create mappings for square brackets
Plug 'tpope/vim-repeat'                " Enhanced repeat in Vim

call plug#end()

" Mappings
" Clear the highlighting search results
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
" Exit insert and return cursor to last position
inoremap <silent> <C-C> <Esc>`^
" Break undo sequence
inoremap <C-U> <C-G>u<C-U>
" Window split resize
nnoremap <silent> <C-w><C-h> :vertical resize -5<CR>
nnoremap <silent> <C-w><C-j> :resize +5<CR>
nnoremap <silent> <C-w><C-k> :resize -5<CR>
nnoremap <silent> <C-w><C-l> :vertical resize +5<CR>
" Save/close shortcats
nnoremap <C-S> :update<CR>
nnoremap <leader>s :update<CR>
nnoremap <leader>S :wall<CR>
nnoremap <silent> <leader>wq :exit<CR>
nnoremap <silent> <leader>qa :qall!<CR>
nnoremap <silent> <leader>bd :lclose<CR>:bdelete<CR>
nnoremap <silent> <leader>x :close<CR>
" Netrw open file tree
if empty(maparg('-', 'n'))
    nnoremap <silent> - :Explore<CR>
endif
" Toggle Paste mode
set  pastetoggle=<F12>
" Movement
nnoremap <leader>wg :<C-U>silent execute v:count.' wincmd w'<CR>
nmap [w <C-W>h
nmap ]w <C-W>l
nmap [W <C-W>k
nmap ]W <C-W>j
nmap [oy :set syntax=ON<CR>
nmap ]oy :set syntax=OFF<CR>
nmap =oy :set syntax=<C-R>=&syntax == "OFF" ? "ON" : "OFF"<CR><CR>
" Insert time
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>

" Autocommands
if has('autocmd')
    filetype plugin indent on
    augroup FileTypeCheck
        autocmd!
        autocmd BufNewFile,BufRead *.todo,*.txt,README,INSTALL,TODO if &ft == '' | setlocal ft=text | endif
        autocmd BufNewFile,BufRead *.phpt setlocal ft=php
        autocmd BufNewFile,BufRead *.vue setlocal ft=javascript
    augroup END
    augroup FileTypeOptions
        autocmd!
        autocmd FileType help nnoremap <silent><buffer> q :q<CR>
        autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
        autocmd FileType gitcommit setlocal spell
        autocmd FileType css,html,javascript,json,jsx,sass,scss,yaml setlocal tabstop=2 shiftwidth=2
        autocmd FileType nginx setlocal tabstop=2 shiftwidth=2 foldmethod=indent foldlevel=99
        autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
        autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
    augroup END
endif

" Themes and highlights
if &t_Co > 2 && has('syntax')
    if !exists('syntax_on') && !exists('syntax_manual')
        syntax on
    endif
    syntax sync minlines=100
    " Colorschemes settings
    let g:loaded_togglebg = 1
    let g:solarized_termcolors=256
    let g:gruvbox_termcolors=256
    " Airline color settings
    let g:airline_theme='jellybeans'
    let g:airline_powerline_fonts=1
    " Indent Line settings
    let g:indentLine_color_term = 246
    " Set colorscheme
    set background=dark
    silent! colorscheme hybrid

    augroup VisualOptions
        autocmd!
        " Uncomment redraw of statusline if Airline starts without colors
        " autocmd VimEnter * if exists(":AirlineRefresh") == 2 | AirlineRefresh | endif
    augroup END
endif

" vi: et ft=vim sw=4 ts=4 tw=0
