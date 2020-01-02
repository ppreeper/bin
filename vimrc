" general
set nocompatible
set lazyredraw
set noerrorbells
set novisualbell

" enable filetype plugins
syntax enable
filetype plugin on

" auto read file when changed from outside
set autoread

" set leader key
let mapleader = ","
let g:mapleader = ","

" configure backspace
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" fast save
nmap <leader>w :w!<cr>

" turn on wildmenu
set wildmenu
set wildignore=*.0,*~,*.pyc
set laststatus=2

colorscheme desert
set background=dark

" tag jumping
" use ^] to jump to tag under cursor
" use g^] for ambiguous tags
" use ^t to jump back up the tag stack
" create the tags file
command! MakeTags !ctags -R .

" autocompletion
" ^x^n for JUST this file
" ^x^f for filenames
" ^x^] for tags only
" ^n for anything spec by the complete option

" file backups and undo
set path+=**
set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile

" text, indents
set expandtab
set shiftwidth=4
set tabstop=4

" text, indents filetypes
filetype indent on
autocmd Filetype yaml setlocal shiftwidth=2 tabstop=2
autocmd Filetype yml setlocal shiftwidth=2 tabstop=2

" text, search
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

" text, editing
" move line of text (ALT|Command)+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m<-2<cr>`>my`<mzgv`yo`z`

if has("mac") || has("maxunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" text, spelling
" pressing <leader>ss will toggle spell checking
map <leader>ss :setlocal spell!<cr>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" split screen
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" buffers
" close current buffer
map <leader>bd :Bclose<cr>
" close all buffers
map <leader>ba :1,1000 bd!<cr>
" switch CWD of open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" helper functions
" DeleteTrailingWS removes end whitespace
func! DeleteTrailingWS()
    exec "normal mz"
    %s/\s\+$//ge
    exec "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.yaml :call DeleteTrailingWS()
autocmd BufWrite *.yml :call DeleteTrailingWS()

" Bclose does not close windows when buffer deleted
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" snippets
nnoremap ,html :-1read $HOME/.vim/skeleton.html<cr>3jwf>a
