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

" Markdown
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable syntax highlighting.
syntax on

" -----------------------------------------------------------------------------
" Plugin settings, mappings and autocommands
" -----------------------------------------------------------------------------

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

