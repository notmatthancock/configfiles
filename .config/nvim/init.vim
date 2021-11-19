" Reload vimrc while editing vimrc:
" :so %

" The basic stuff
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab
set number
set mouse=a
set wildmode=longest,list,full
set wildmenu
set spelllang=en_us
set display=lastline " for long lines.
set linebreak " break lines on word boundaries, not in the middle of words.

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" indent by file type 
filetype plugin indent on

" make backspace work better
" See: https://vi.stackexchange.com/a/2163
set nocompatible
set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymaps

" CTRL+i => insert ipdb set trace statement on following line
map <C-i> <C-\><C-N>oimport ipdb; ipdb.set_trace()<ESC>

" These maps handle line up and down movements when the line wraps. Vim's
" default behavior is to jump to the next logical line. Instead, these
" maps make the up/down movements correspond to the line shown in the
" terminal. This is helpful for prose documents like Tex or markdown.
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

:nnoremap <C-d> "=strftime("%a %d %b %Y")<CR>P

" persistent undo/redo
set undofile
set undolevels=1000
set undoreload=10000

" NOTE: neovim auto-creates undo storage location at ~/.local/share/nvim/undo
"
" Plain vim can use the following to manually configure it:
" set undodir=SOMEPATH

" Set spelling for markdown and latex
autocmd FileType markdown setlocal spell
autocmd FileType tex setlocal spell

" File types with 2-space tabs
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2
autocmd FileType yml setlocal tabstop=2 shiftwidth=2
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2
autocmd FileType tf setlocal tabstop=2 shiftwidth=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors

set termguicolors

" Set visual highlight yellow
hi Visual cterm=NONE ctermfg=black ctermbg=yellow

" Set background color of current line.
set cursorline
hi CursorLine cterm=NONE ctermfg=NONE ctermbg=234

" Set fortran highlighting to free source, not fixed.
let fortran_free_source=1

" Makefile gets tabs, not spaces.
autocmd FileType make setlocal noexpandtab

" Set highlighting for f2py interface files to Fortran.
au BufReadPost *.pyf set syntax=fortran

" Show the 80 column mark and set its color.
set colorcolumn=80,120
hi ColorColumn ctermbg=0 guibg=gray

hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
" Using vim-plug below. See installation:
" https://github.com/junegunn/vim-plug#installation

call plug#begin('~/.local/share/plugged')

Plug 'scrooloose/nerdtree'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'neovim/nvim-lspconfig'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree config

" Open nerdtree browser by default
autocmd VimEnter *  NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" File extension ignore
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.egg-info$']

" Expand directories by default
autocmd User NERDTreeInit normal O

" Expand / collapse file browser with ALT+SHIFT+F
" NOTE: Alt+1 is equivalent Pycharm shortcut
nmap <A-1> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lsp config
"
" NOTE: this is mostly copy pasta from:
" https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
"
" TODO: make lsp keymaps same as pycharm's equivalents for less mental
" context switching betweeen tools

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<C-B>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
