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
" Plugins
" -----------------------------------------------------------------------------

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')

" Code-completion engine
" Note this is Apple Silicon specific.
Plug 'ycm-core/YouCompleteMe', { 'do': '/opt/homebrew/bin/python3 ./install.py --cs-completer --ts-completer' }

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

" OmniSharp to provide IDE like abilities for C#
Plug 'OmniSharp/omnisharp-vim'

" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'

" Command-line fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Debugging
Plug 'puremourning/vimspector', { 'do': '/opt/homebrew/bin/python3 ./install_gadget.py --enable-python' }

" jsruntime (PyV8 for javascript interpreter)
Plug 'michalliu/jsruntime.vim', { 'do': 'cp -R autoload/* ~/.vim/autoload/' }

" jsoncodecs
Plug 'michalliu/jsoncodecs.vim', { 'do': 'cp autoload/jsoncodecs.vim ~/.vim/autoload/' }

" jsflakes (javascript linter)
Plug 'michalliu/jsflakes.vim', { 'do': 'mkdir ~/.vim/ftplugin; cp -R ftplugin/* ~/.vim/ftplugin/' }

call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable syntax highlighting.
syntax on

" Spelling mistakes will be colored up red.
"hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
"hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
"hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
"hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

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
" ycm-core/YouCompleteMe
" .............................................................................

" On Apple silicon, Homebrew installs files into the /opt/homebrew/ folder.
" Otherwise /usr/local/bin/python3
let g:ycm_path_to_python_interpreter='/opt/homebrew/bin/python3'

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
\   'cs': ['OmniSharp'],
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

" .............................................................................
" prabirshrestha/asyncomplete.vim
" .............................................................................

" disable the popup
let g:asyncomplete_auto_popup = 0

" allow modifying the completeopt variable, or it will be overridden all the
" time.
let g:asyncomplete_auto_completeopt = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" tab to show autocomplete
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" .............................................................................
" OmniSharp/omnisharp-vim
" .............................................................................

let g:OmniSharp_diagnostic_showid = 1
let g:OmniSharp_diagnostic_exclude_paths = [
\ 'obj/',
\ '[Tt]emp/',
\ '\.nuget/',
\ '\<AssemblyInfo\.cs\>'
\]

" .............................................................................
" puremourning/vimspector
" .............................................................................

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" mappings for up and down the stack
"nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
"nmap <LocalLeader><F12> <Plug>VimspectorDownFrame
