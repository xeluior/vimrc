" use vim (not vi) defaults
if &compatible
    set nocompatible
endif

" allow backspace over everything (^W does not stop at insert start)
set backspace=indent,eol,nostop

set history=200
set ruler
set showcmd
set wildmenu

set ttimeout
set ttimeoutlen=100

" show @@@ if the last line is truncated
set display=truncate

" keep a few context lines
set scrolloff=5

" better search defaults
set incsearch hlsearch ignorecase smartcase

" allow ^L to clear search highlights
nnoremap <C-L> :nohlsearch<CR>

" in insert mode, start a new undo context before ^U (delete-backwards-line)
inoremap <C-U> <C-G>u<C-U>

" enable mouse fully for xterm, but not in command mode for other emulators
" (to allow copy-paste by typing : then making a selection)
if has('mouse')
    if &term =~ 'xterm'
        set mouse=a
    else
        set mouse=nvi
    endif
endif

" enable filetype detection
filetype plugin indent on

" when editing a file, always jump to the last known cursor position, except
" when the position is invalid, in an event hadler, for a commit message, or
" when using xxd
augroup vimStartup
    autocmd!
    autocmd BufReadPost *
        \ let line = line("'\"")
        \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
        \      && index(['xxd', 'gitrebase'], &filetype) == -1
        \ |   execute "normal! g`\""
        \ | endif
augroup END

" enable syntax highlighting when the terminal has colors
if &t_Co > 2 || has('gui_running')
    syntax on
endif

" true color support where applicable
if expand('$COLORTERM') == 'truecolor'
    set termguicolors
endif

" show line numbers
set number

" use system clipboard
if expand('$WAYLAND_DISPLAY') =~ 'wayland' && executable('wl-copy')
    augroup waylandYank
        autocmd!
        autocmd TextYankPost * silent! call system('wl-copy', @")
        autocmd FocusGained * let @"=system('wl-paste --no-newline')
    augroup END
elseif expand('$DISPLAY') != '$DISPLAY' && has('unnamedplus')
    set clipboard^=unnamedplus
endif

" confirm on :q with unsaved changes instead of just failing
set confirm

" highlight the line with the cursor
set cursorline

" spaces not tabs
set expandtab softtabstop=4 shiftwidth=4

" don't require saving when navigating away from a buffer
set hidden

" maintain the sign column even when no signs for consistent spacing
if has('signs')
    set signcolumn=yes
endif

" settings for working with wrapped text
set smoothscroll
nnoremap j gj
nnoremap k gk

" correct split behavior
set splitbelow splitright

" persist undo history and swap (without cluttering .)
if !isdirectory(expand('~/.vim/swp'))
    silent! call system('mkdir -p ~/.vim/swp')
endif

set undofile undodir=~/.vim/swp
set directory=~/.vim/swp

" change cursor shape in insert, visual modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" use a reasonable leader key
let mapleader = ' '

" correct Y behavior
nnoremap Y y$
