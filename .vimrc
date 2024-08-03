" use vim (not vi) defaults
if &compatible
    set nocompatible
endif

" allow backspace over everything (^W does not stop at insert start)
set backspace=indent,eol,nostop

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
    autocmd BudReadPost *
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

" prevent langmap from applying to characters that are in a mapping
if has('langmap') && exists('+langremap')
    set nolangremap
endif
