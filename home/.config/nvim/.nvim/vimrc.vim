"	 DEFAULT
:set ignorecase
:set smartcase
:set showcmd
:set rnu number
:set expandtab
:set tabstop=4
:set shiftwidth=4

" JK ESCAPE
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
function! JKescape(key)
    if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
    if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
    let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
    if l:timediff <= 0.5 && l:timediff >=0.001
        " Move cursor 1 slot to the right
        return "\b\e\l"
    else
        return a:key
    endif
endfunction
inoremap <expr> j JKescape('j')
inoremap <expr> k JKescape('k')

" E-Z ESCAPE
inoremap <esc> <esc>l

" CTRL + BACKSPACE/DEL = WORK
inoremap <C-Del> <esc>lce
noremap <C-Del> <esc>lce
inoremap <C-BS> <esc>lcb
noremap <C-BS> <esc>lcb

" E-Z WRITE
map <F2> :write<CR>

" NO BACKGROUND
:hi Normal guibg=NONE ctermbg=NONE

" BLINKING CURSOR
:set guicursor=a:blinkon100

" E-Z WINDOW SWITCH
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" VIM-PLUG

"call plug#begin()

"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"call plug#end()

" WINDOWED TERMINAL
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
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction
" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>
" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" E-Z BUFFER SWITCH
:nnoremap <Tab> :bnext<cr>
:nnoremap <S-Tab> :bprevious<cr>
:nnoremap gd :bdelete<cr>

" E-Z AUTOCOMPLETE
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" CHANGE LEADER
let mapleader = " "

" SMOOTH SCROLL
" let g:comfortable_motion_scroll_down_key = "j"
" let g:comfortable_motion_scroll_up_key = "k"
" noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
" noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>

" E-Z NUMBER CHANGE
function! Numbers()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call Numbers()<CR>
onoremap in :normal vin<CR>
