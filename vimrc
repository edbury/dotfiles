" use vim settings, rather than vi settings
set nocompatible

" --------------------------------------------------

" START plugin management via vim-plug

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" list plugins here - make sure you use single quotes

" sensible.vim - some non-controversial defaults :: https://github.com/tpope/vim-sensible
Plug 'tpope/vim-sensible'

" NERDTree - file system explorer :: https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" NERCCommenter - intensely orgasmic commenting :: https://github.com/scrooloose/nerdcommenter
Plug 'scrooloose/nerdcommenter'

" ctrlp.vim - fuzzy file finder (and more) :: https://github.com/ctrlpvim/ctrlp.vim
Plug 'ctrlpvim/ctrlp.vim'

" vim-polyglot - a collection of language packs :: https://github.com/sheerun/vim-polyglot
Plug 'sheerun/vim-polyglot'

" ALE - asynchronous lint engine :: https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'

" fugitive.vim - 'the best Git wrapper of all time' :: https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" vim-gitgutter - line by line git status and hunking :: https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'

" vim-easymotion - vim motion on speed :: https://github.com/easymotion/vim-easymotion
Plug 'easymotion/vim-easymotion'

" emmet-vim - abbreviation expanding :: https://github.com/mattn/emmet-vim
Plug 'mattn/emmet-vim'

" undotree - undo history visualizer :: https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" vim-taskwarrior - a vim interface for taskwarrior :: https://github.com/blindfs/vim-taskwarrior
Plug 'blindfs/vim-taskwarrior'

" lightline.vim - a light statusline/tabline :: https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'

" base16-vim - base16 schemes :: https://github.com/chriskempson/base16-vim

Plug 'chriskempson/base16-vim'

" base16-vim-lightline - base16 schemes for lightline :: https://github.com/mike-hearn/base16-vim-lightline
Plug 'mike-hearn/base16-vim-lightline'

" initialize plugin system
call plug#end()

" END plugin management

" --------------------------------------------------

" START general config

" set leader key to <space>
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" swap ' and ` for easier access
nnoremap ' `
nnoremap ` '

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>ez :edit ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session (bring it back up with vim -S)
nnoremap <leader>s :mksession<CR>

" find search match as we type
set incsearch

" ignore case on search...
set ignorecase

" highlight on search
set hlsearch

" quickly turn off highlighting with <leader>n
nmap <silent> <leader>n :silent :nohlsearch<CR>

" trim trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" quickly close buffer with <leader>d
map <leader>d :bp\|bd #<CR>

" ensure we get a title
set title

" show line numbers
set number

" show matching bracket, etc
set showmatch

" allow buffers in the background
set hidden

" show incomplete commands in status bar
set showcmd

" don't bother me, vim
set belloff=all

" start scrolling when we're 8 lines from the margin
set scrolloff=8

" use system clipboard by default
set clipboard=unnamed

" indentation and whitespace
set smartindent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set noshiftround
set linebreak

" stifle interruptive prompts
set shortmess=atI

" END general config

" --------------------------------------------------

" START backup config

set undofile
set undolevels=9999
set undoreload=9999

" store it all on dropbox if possible

if isdirectory(expand("$HOME/Dropbox/"))
  silent !mkdir -p $HOME/Dropbox/.vim/undo
  set undodir=$HOME/Dropbox/.vim/undo
  silent !mkdir -p $HOME/Dropbox/.vim/backups
  set backupdir=$HOME/Dropbox/.vim/backups
  silent !mkdir -p $HOME/Dropbox/.vim/swaps
  set directory=$HOME/Dropbox/.vim/swaps
else
  silent !mkdir -p $HOME/.vim/undo
  set undodir=$HOME/.vim/undo
  silent !mkdir -p $HOME/.vim/backups
  set backupdir=$HOME/.vim/backups
  silent !mkdir -p $HOME/.vim/swaps
  set directory=$HOME/.vim/swaps
end

" END backup config

" --------------------------------------------------

" START NERDTree config

" invoke with <leader>\
map <leader>\ :NERDTreeToggle<CR>

" remap CWD when root is changed in NERDTree
let g:NERDTreeChDirMode = 2

let NERDTreeShowHidden = 1

" set general wildignore
set wildignore+=*.DS_Store

" have NERDTree respect it
let NERDTreeRespectWildIgnore=1

" END NERDTree config

" --------------------------------------------------

" START ctrlp.vim settings

" invoke with <leader>p
let g:ctrlp_map = '<leader>p'

" use ripgrep if available
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_clear_cache_on_exit = 0
endif

" order results top to bottom
let g:ctrlp_match_window = 'bottom,order:ttb'

" respect CWD changes
let g:ctrlp_working_path_mode = 0

" show hidden files
let g:ctrlp_show_hidden = 1

" END ctrlp.vim settings

" --------------------------------------------------

" START easymotion-vim config

" better ergonomics than the default keys
let g:EasyMotion_keys='asdfjkowerip'

" END easymotion-vim config

" --------------------------------------------------

" START undotree config

" invoke undotree with <leader>u (super undo)
nnoremap <leader>u :UndotreeToggle<CR>

" END undotree config

" --------------------------------------------------

" START git-gutter/fugtive config

" force git-gutter update on commit
autocmd BufWritePost * GitGutter

" END git-gutter/fugtive config

" --------------------------------------------------

" START theming config

set background=dark

" hopefully fix these horrible colors
set termguicolors

" automatch our terminal theme in vim
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

let g:lightline = {}
let g:lightline.colorscheme = substitute(g:colors_name, '-', '_', '')

" END theming config

" --------------------------------------------------
