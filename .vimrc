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

" Code-completion engine (used for YAML only for now)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Code-completion engine
" Note this is Apple Silicon specific.
Plug 'ycm-core/YouCompleteMe',
    \ { 'do': '/opt/homebrew/bin/python3 ./install.py --cs-completer --ts-completer' }

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
Plug 'puremourning/vimspector',
    \ { 'do': '/opt/homebrew/bin/python3 ./install_gadget.py --enable-python --force-enable-node' }

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
"set spell                       " spell checking
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
" neoclide/coc.nvim
" .............................................................................


" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
"inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1) :
"      \ CheckBackspace() ? "\<Tab>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" .............................................................................
" ycm-core/YouCompleteMe
" .............................................................................

" On Apple silicon, Homebrew installs files into the /opt/homebrew/ folder.
" Otherwise /usr/local/bin/python3
let g:ycm_path_to_python_interpreter='/opt/homebrew/bin/python3'

" .............................................................................
" dense-analysis/ale
" .............................................................................

let js_fixers = ['prettier', 'eslint']
let js_linters = ['eslint']

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'cs': ['dotnet-format'],
\   'python': ['black', 'isort'],
\   'javascript': js_fixers,
\   'typescript': js_fixers,
\   'json': ['fixjson']
\} " 'yapf', 'autopep8'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
\   'cs': ['OmniSharp'],
\   'markdown': ['markdownlint'],
\   'python': ['flake8'],
\   'javascript': js_linters,
\   'typescript': js_linters,
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
