" Basic Configurations

:set rnu number
:set mouse=a
:syntax enable
:set showcmd
:set encoding=utf-8
:set showmatch
:set expandtab
:set guicursor=n-v-c-i:block
:set tabstop=4
:set shiftwidth=0
:set softtabstop=0
:set autoindent
:set smarttab
:set guicursor=a:blinkon100
:set ic
:set scs

" CLEAR BACKGROUND
:hi Normal guibg=NONE ctermbg=NONE

" EZ NUMBER CHANGE
function! Numbers()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call Numbers()<CR>
onoremap in :normal vin<CR>

" ESC FIX
inoremap <Esc> <Esc>l

" TOGGLE TERM
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

nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" F2 = write
nnoremap <F2> :w<CR>
inoremap <F2> <Esc>:w<CR>a

" File Tree
nnoremap <C-T> :Neotree toggle<CR>

" E-Z buffer switch
nnoremap gd :tabclose<CR>
nnoremap gn :tabnew<CR>
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> :tabprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

" MINIMAP
let g:minimap_width = 10
" let g:minimap_auto_start = 1
" let g:minimap_auto_start_win_enter = 1
nnoremap <C-m> :call minimap#vim#MinimapToggle()<CR>

