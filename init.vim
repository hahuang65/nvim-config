" == Leader Keys =============================================================
let mapleader = ' '

" == Options =================================================================

" -- General -----------------------------------------------------------------
syntax enable " Syntax highlighting

set backspace=indent,eol,start " Allow backspace to delete everything
set formatoptions+=j           " Set joining lines to be smarter
set hidden                     " Allows hiding a buffer without saving

" -- Colorscheme -------------------------------------------------------------
colorscheme dracula
set background=dark
set termguicolors

" -- File Formats ------------------------------------------------------------
set encoding=utf-8           " Force UTF-8 as standard encoding
set fileformats=unix,dos,mac " Unix as the standard file type

" -- Performance -------------------------------------------------------------
set updatetime=50  " Faster intervals between CursorHold events
set timeoutlen=250 " Timeout for mappings
set ttimeoutlen=-1 " Timeout for key codes, -1 means use `timeoutlen`

" -- User Interface ----------------------------------------------------------
set lazyredraw        " Don't redraw for macros and commands that aren't typed
set number            " Show line numbers
set relativenumber    " SHow relative numbers outside of the current line
set signcolumn=auto:4 " Always show the signcolumn
set showmatch         " Show matching brackets and parentheses
set cursorline        " Show the line the cursor is on

" -- Auto Reload -------------------------------------------------------------
"  Automatically reload buffer every second, using Vim's timer feature
set autoread
if ! exists('g:CheckUpdateStarted')
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(1000,'CheckUpdate')
endfunction

" -- Local vimrc -------------------------------------------------------------
set exrc   " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files

" -- Swap Files --------------------------------------------------------------
" Disable swap and backup files polluting the filesystem
set noswapfile
set nobackup
set nowritebackup

" -- Persistent Undo ---------------------------------------------------------
" Keep undo history across sessions, by storing it in a file
silent !mkdir ~/.vimundo > /dev/null 2>&1
set undodir=~/.vimundo
set undofile

" -- Indentation -------------------------------------------------------------
" By setting `expandtab` and the same value to `shiftwidth` and `tabstop`, vim
" will always insert spaces instead of tabs.
set autoindent    " Automatically indent new line based on previous line
set expandtab     " Soft-tabs, inserts spaces when <Tab> is used
set shiftwidth=2  " Use 2 spaces per indent
set smartindent   " Syntax-aware indentation (i.e. matching parens)
set smarttab      " Use `shiftwidth` when inserting tabs at front of the line
set softtabstop=2 " Use 2 spaces per tab when inserting text
set tabstop=2     " Use 2 spaces per tab

" -- Line Breaks -------------------------------------------------------------
set colorcolumn=80                  " Show a colored column guide at line 80
set listchars+=precedes:<,extends:> " Shows < or > if line is scrollable
set nolist                          " Disable showing tabs vs spaces
set nowrap                          " Don't wrap lines automatically
set textwidth=0                     " Disable linebreaks happening by line size
set wrapmargin=0                    " Disable wrapping based on window borders

" -- Search ------------------------------------------------------------------
set incsearch  " Incremental search as you type
set infercase  " Basically smartcase for completion
set smartcase  " Casing for searching based on typed text

" -- Scrolling ---------------------------------------------------------------
set scrolloff=20     " Scroll when 20 lines away from top/bottom margins
set sidescroll=1     " Scroll by 1 when reaching the sides of a line
set sidescrolloff=15 " Scroll when 15 lines from side margins

" -- Splits ------------------------------------------------------------------
set splitbelow " Split towards bottom
set splitright " Split towards right

" -- Terminal Mode -----------------------------------------------------------
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

nnoremap <A-t> :call TermToggle(25)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(25)<CR>

augroup nvim_terminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END

" == Mappings ================================================================

" -- Auto-Correct Commands ---------------------------------------------------
nnoremap Q q
nnoremap q: :q
nnoremap :Q :q
nnoremap :W :w

" -- Buffer Commands ---------------------------------------------------------
" Close the buffer without closing the split
command Bd bp\|bd \#

" -- Terminal Navigation -----------------------------------------------------
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

lua require('plugins')

" == Plugins (non-lua) =======================================================

" -- vim-test ----------------------------------------------------------------
let test#strategy = "neovim"
let test#neovim#term_position = "botright 25"
nnoremap <silent> <leader>tt :TestLast<CR>
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ta :TestSuite<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

" -- vim-ultest --------------------------------------------------------------
nnoremap <silent> <leader>tn :UltestNearest<CR>
nnoremap <silent> <leader>tf :Ultest<CR>
nnoremap <silent> <leader>to :UltestOutput<CR>
nnoremap <silent> <leader>td :UltestAttach<CR>
nmap ]t <Plug>(ultest-next-fail)
nmap [t <Plug>(ultest-prev-fail)

augroup nvim_config
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
  autocmd BufWritePost plugins.lua PackerCompile
augroup END
