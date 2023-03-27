" --------------------------------------------------
" START plug config


" auto-install vim-plug

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin("~/.config/nvim/plugged")

"Our plugins will go in the middle

" sensible.vim - some non-controversial defaults :: https://github.com/tpope/vim-sensible
" Plug 'tpope/vim-sensible' // Commenting out to test necessity within NeoVim

" NERDTree - file system explorer :: https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" NERDCommenter - intensely orgasmic commenting :: https://github.com/scrooloose/nerdcommenter
Plug 'scrooloose/nerdcommenter'

" fzf - fzf is a general-purpose command-line fuzzy finder. :: https://github.com/junegunn/fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ALE - asynchronous lint engine :: https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'

" fugitive.vim - 'the best Git wrapper of all time' :: https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" Signify (or just Sy) - uses the sign column to indicate added, modified and removed lines :: https://github.com/mhinz/vim-signify
Plug 'mhinz/vim-signify'

" sneak.vim - Jump to any location specified by two characters. :: https://github.com/justinmk/vim-sneak
Plug 'justinmk/vim-sneak'

" surround.vim - provides mappings to easily delete, change and add surroundings in pairs :: https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" undotree - undo history visualizer :: https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" lightline.vim - a light statusline/tabline :: https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'

" base16-vim - base16 schemes :: https://github.com/chriskempson/base16-vim
Plug 'chriskempson/base16-vim'

" vim-base16-lightline - base16 schemes for lightline :: https://github.com/daviesjamie/vim-base16-lightline
Plug 'daviesjamie/vim-base16-lightline'

call plug#end()

" END plug config
" --------------------------------------------------
" --------------------------------------------------
" START general config

" set leader key to <space>
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

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

au BufRead,BufNewFile *.njk setfiletype html

" spell-check markdown files and git commit messages
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" enable dictionary auto-completion in markdown files and git commit messages
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

" END general config
" --------------------------------------------------
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
" --------------------------------------------------
" START fzf.vim config

" invoke with <leader>p
nnoremap <leader>p :GFiles<Cr>

" search buffers
nnoremap <leader>l :Buffers<CR>

" use ripgrep if available
if executable('rg')
  nnoremap <leader>/ :Rg<Space>
elseif executable('ag')
  nnoremap <leader>/ :Ag<Space>
endif


" END fzf.vim config
" --------------------------------------------------
" --------------------------------------------------
" START ALE config

let g:ale_fixers = {
\   'typescriptreact': ['prettier', 'eslint'],
\   'scss': ['stylelint'],
\}

let g:ale_typescript_prettier_use_local_config = 1

let g:ale_fix_on_save = 1

" END fzf.vim config
" --------------------------------------------------
" --------------------------------------------------
" START undotree config

" invoke undotree with <leader>u (super undo)
nnoremap <leader>u :UndotreeToggle<CR>

" END undotree config
" --------------------------------------------------
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

let g:lightline = { 'colorscheme': 'base16' }

" END theming config
" --------------------------------------------------

