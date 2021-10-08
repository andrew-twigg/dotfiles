" -----------------------------------------------------------------------------
" This config is targeted for Vim 8.2+.
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" vim-plug autoinstall missing plugings
" -----------------------------------------------------------------------------

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
\| endif

" -----------------------------------------------------------------------------
" Github markdown css download
" -----------------------------------------------------------------------------

" Required by markdown-preview
if empty(glob('~/.vim/autoload/sindresorhus/github-markdown-css'))
    silent !curl -fLo ~/.vim/autoload/sindresorhus/github-markdown-css/github-markdown.css
        \ --create-dirs
        \ https://raw.githubusercontent.com/sindresorhus/github-markdown-css/gh-pages/github-markdown.css
endif

" -----------------------------------------------------------------------------
" Plugings
" -----------------------------------------------------------------------------

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')

" Code-completion engine
"Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }

" Ale (Asynchronous Lint Engine)
Plug 'dense-analysis/ale'

" Markdown
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Display Git changes
Plug 'airblade/vim-gitgutter'

call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable syntax highlighting.
syntax on

" -----------------------------------------------------------------------------
" Basic settings
"   Research any of these by running :help <setting>
" -----------------------------------------------------------------------------

" :filetype on enables filetype detection (so FileType autocmds will work).
" :filetype plugin on enables the loading of filetype-specific scripts in
" ftplugin directories when the filetype is set. The same goes for
" :filetype indent on. All three can be combined into a single line.
filetype plugin indent on

set backspace=indent,eol,start  " allow backspace
set expandtab                   " on pressing tab, insert 4 spaces
set nu                          " line numbers on
set shiftwidth=4                " when indenting with '>', use 4 spaces width
set spell                       " spell checking
set spelllang=en_gb             " english (GB)
set tabstop=4                   " show existing tab with 4 spaces width

" -----------------------------------------------------------------------------
" Basic mappings
" -----------------------------------------------------------------------------

" Seamlessly treat visual lines as actual lines when moving around.
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

" -----------------------------------------------------------------------------
" Plugin settings, mappings and autocommands
" -----------------------------------------------------------------------------

" .............................................................................
" dense-analysis/ale
" .............................................................................

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort']
\} " 'yapf', 'autopep8'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
\   'markdown': ['markdownlint'],
\   'python': ['flake8']
\} " 'pydocstyle', 'bandit', 'mypy'
let g:ale_linters_explicit = 1 " Only run linters named in ale_linters settings
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

" .............................................................................
" plasticboy/vim-markdown
" .............................................................................

" prevent foldtext from being set
let g:vim_markdown_folding_disabled = 1

" disable conceal regardless of conceallevel setting
let g:vim_markdown_conceal = 0

" .............................................................................
" iamcco/markdown-preview.nvim
" .............................................................................

" no auto close current preview window when change from markdown buffer to
" another buffer
let g:mkdp_auto_close=0

" refresh markdown when save the buffer or leave from insert mode only
let g:mkdp_refresh_slow=1

" custom markdown style
let g:mkdp_markdown_css='~/.vim/autoload/sindresorhus/github-markdown-css/github-markdown.css'
