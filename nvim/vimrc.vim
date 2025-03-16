:set mouse=a
:syntax enable
:set guicursor=n-v-c-i:block
:set guicursor=a:blinkon100

" EZ NUMBER CHANGE
function! Numbers()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call Numbers()<CR>
onoremap in :normal vin<CR>

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
"
" tnoremap <Esc> <C-\><C-n>
" tnoremap :q! <C-\><C-n>:q!<CR>

" F2 = write
" nnoremap <F2> :w<CR>
" inoremap <F2> <Esc>:w<CR>a

" File Tree --- Replaced by harpoon/netrw/fzf
" nnoremap <C-T> :Neotree toggle<CR>

" E-Z buffer switch
" nnoremap gd :tabclose<CR>
" nnoremap gn :tabnew<CR>
" nnoremap <TAB> :tabnext<CR>
" nnoremap <S-TAB> :tabprev<CR>
" nnoremap <C-n> :bnext<CR>
" nnoremap <C-p> :bprev<CR>

" MINIMAP --- Replaced by after/pluginminimap.lua
" let g:minimap_width = 10
" " let g:minimap_auto_start = 1
" " let g:minimap_auto_start_win_enter = 1
" nnoremap <C-m> :MinimapToggle<CR>

" AUTOCOMPLETION FIX --- Replaced by LSP --> blink.cmp
" :highlight CocMenuSel guibg=#34374a guifg=#ffffff ctermbg=darkblue ctermfg=white
" inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
" inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
" nnoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"


