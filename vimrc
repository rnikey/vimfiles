" This initialisation file is now backed up using git.  I will hopefully get it on
" Github soon so I should never lose it again.  That will be handy!

" I'm using a utility called pathogen and all plugins go into the "bundle"
" directory.  This way I don't have to worry about deleted files, if a 
" plugin gets updated I simply install a whole new directory.
call pathogen#infect() 

set viminfo='10,<50,s10,h,rA:,rB:,!
" I'm setting cpoptions explicitly, even though it's currently the default.  I may want
" to make changes to this sooner or later.
" I'm currently trusting Vim options but as I said, I may want to change it later.
" Don't set compatible again or cpoptions will be overwritten.
set cpoptions=aABceFs
filetype on "This allows vim to recognise the filetype when loading a file
set laststatus=2
set statusline=%6y " Filetype
set statusline+=\ " Add a space
set statusline+=%4(%r%) " Add [RO] if readonly
set statusline+=\ " Add a space
set statusline+=%f "Path to current file
set statusline+=%M "Modified flag
set statusline+=%= "Change to RHS
set statusline+=\ " Add a space
set statusline+=(%l,%c) " Add current line and column number
set statusline+=/" Add a forward slash
set statusline+=%L "Number of lines in file
set statusline+=\ " Add a space

set nobackup  "I hate those ugly ~ files.  I don't save anything unless I really want it.
colorscheme mabcolours  " Adapted from torte
set ignorecase
set nowrapscan
set number
set shiftwidth=4  "This is used for folding too.  4 is very typical for programmers, even though I sometimes use 2
set foldcolumn=4  "I'm showing this column for a while, I want to see if it's useful.  I suspect it isn't though
set colorcolumn=80

nnoremap , <Nop>
let mapleader=","
"My maps
nnoremap <leader>ev :new $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" All my autocommands.  Put them in this group to stop duplication. {{{
augroup allmyautocommands
"This is the reason for grouping, it will stop duplicates.
  autocmd! 
  autocmd VimEnter * :echom "MAB was here."
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" set lines=50 columns=100
" winpos 50 0
" Restore screen size and position /*{{{*/
" Courtesy of Steve Hall
"" Modified by David Fishburn to base it on gvim servername 
if has("gui_running")
    function! Screen_init()
        " - Remembers and restores winposition, columns and lines stored in
        "   global variables written to viminfo
        " - Must follow font settings so that columns and lines are accurate
        "   based on font size.

        " initialize
        if !exists("g:COLS_".v:servername)
            let g:COLS_{v:servername} = &columns
        endif
        if !exists("g:LINES_".v:servername)
            let g:LINES_{v:servername} = &lines
        endif
        if !exists("g:WINPOSX_".v:servername)
            " don't set to 0, let window manager decide
            let g:WINPOSX_{v:servername} = ""
        endif
        if !exists("g:WINPOSY_".v:servername)
            " don't set to 0, let window manager decide
            let g:WINPOSY_{v:servername} = ""
        endif

        " set
        execute "set columns=".g:COLS_{v:servername}
        execute "set lines=".g:LINES_{v:servername}
        execute "winpos ".g:WINPOSX_{v:servername}." ".g:WINPOSY_{v:servername}

    endfunction

    function! Screen_get()
        " used on exit to retain window position and size

        let g:COLS_{v:servername} = &columns
        let g:LINES_{v:servername} = &lines

        let g:WINPOSX_{v:servername} = getwinposx()
        " filter negative error condition
        if g:WINPOSX_{v:servername} < 0
            let g:WINPOSX_{v:servername} = 0
        endif

        let g:WINPOSY_{v:servername} = getwinposy()
        " filter negative error condition
        if g:WINPOSY_{v:servername} < 0
            let g:WINPOSY_{v:servername} = 0
        endif

    endfunction

    let g:restore_screen_size_pos = 1
    " autocmd VimEnter * breakadd func Screen_init
    autocmd VimEnter * if g:restore_screen_size_pos == 1 | call Screen_init() | endif
    autocmd VimLeavePre * if g:restore_screen_size_pos == 1 | call Screen_get() | endif
endif
" }}}

