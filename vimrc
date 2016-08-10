" This initialisation file is now backed up using git.
" Please push changes to Github periodically.

" When                  Who             What
" ----------------      --------------  ---------------------------------------
" 10th August 2016	Michael Bihari	Added functions to display character lists
" 10th August 2016	Michael Bihari	Set encoding to UTF8 for all files as 
"                                       recommended by Vim creators.

" I'm using a utility called pathogen and all plugins go into the "bundle"
" directory.  This way I don't have to worry about deleted files, if a 
" plugin gets updated I simply install a whole new directory.
" Modification History


call pathogen#infect() 

set encoding=UTF8 " This is recommended by VIM authors.  Just remember it's no longer a single byte editor

set viminfo='10,<50,s10,h,rA:,rB:,!
" I'm setting cpoptions explicitly
" Don't set compatible again or cpoptions will be overwritten.
" The default setting would be... set cpoptions=aABceFs
" I like the Vi undo.  I rarely need to go back more than one level and this way
" I can see my last change flash on the screen.
set cpoptions=uaABceFs
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
syntax on
set ignorecase
set nowrapscan
set number
set shiftwidth=4  "This is used for folding too.  4 is very typical for programmers, even though I sometimes use 2
set foldcolumn=4  "I'm showing this column for a while, I want to see if it's useful.  I suspect it isn't though
set colorcolumn=80

" Add the html tag delimeters to the matchpairs list.  I could maybe change this later so it only does it in html or xml files
set matchpairs+=<:>

" Using \tmp as temporary directory.  This way if I'm working on a memory stick I don't bother the host computer
let $TMP="\\tmp"
if !isdirectory($TMP)
    if exists("*mkdir")
	call mkdir($TMP,'p')
	echo "Created directory: " . $TMP
    else
        echoerr "Please create directory: " . $TMP
    endif
endif


"My maps.  I put them all here so that I can see them all when editing them.  {{{
noremap , <Nop>
let mapleader=","
nnoremap <leader>ve :new $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>
nnoremap <silent> <leader>en :call ListEnv()<CR>

" Hitting <c-w> for window movements is clumsy and I remap them 
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>h <c-w>h
nnoremap <leader>l <c-w>l

" The following are for commenting out code
"cx is for "comment xml"
nnoremap <leader>cx 0i<!-- <esc>f<%a<cr>--><esc>

" These next maps call functions defined in pathogen
" Whilst the pathogen functions should be fully self contained, at the same time
" I want to be able to see all my maps here rather than hunt through pathogen
" directories.
nnoremap <silent> <leader>p  :silent call Rerun_last_ex_command_and_put()<cr>
" }}}

" All my autocommands.  Put them in this group to stop duplication. {{{
augroup allmyautocommands
"The problem is autocommands run again on every load.
"This is the reason for grouping, it will stop duplicates.
" Next command removes ALL autocommands for the current group
  autocmd!
  autocmd VimEnter * :echom "MAB was here >^.^<"
  autocmd FileType vim setlocal foldmethod=marker
"Next is the syntax highlighting.  Mostly I like it off but sometimes I want it on
"Bloody vim has an :ownsyntax command, but you can't switch it on if syntax is
"generally switched off.  So annoying.  Basically ':syntax off' means that it's
"switched off and that's it...you can't then use ':ownsyntax on' on a buffer
"that you particularly want the highlighting to show.
"So what I'm doing is switching syntax on generally, and then switching it off
"in every other window, unless I later deliberately switch it on again.
"Note that :ownsyntax belongs to a window and not a buffer.  That's why I use
"BufWinEnter.  Note also that :syntax on belongs to the whole of vim (not just a
"buffer or window)
  autocmd BufWinEnter * :ownsyntax off
  autocmd BufWinEnter *.vim :ownsyntax on
  autocmd BufWinEnter vimrc :ownsyntax on
  autocmd BufWinEnter MikeyBackup.wxs :ownsyntax on
" This just temporarily while I muck around with this file
"  autocmd BufNewFile,BufRead MikeyBackup.wxs :ownsyntax on
augroup END
" }}}


" Functions to get a list of environment variables  {{{
function! Env()
    silent execute "normal! :return $\<C-a>')\<C-b>\<C-right>\<Right>\<Del>split('\<CR>"
endfunction "Env

function! ListEnv()
  let l:envlist = Env()
  echo " "
  for l:item in l:envlist
    let l:value='$'.l:item
    echo printf('%-30s %s', l:item , eval(l:value))
  endfor
endfunction "ListEnv
" }}}

" Functions to display character lists {{{
function! GenerateASCIICharacters(how_many_characters)
  let a=range(0, a:how_many_characters)
  for i in a
    put=i . \"\t\" . printf(\"%c\", i)
  endfor
endfunction

function! GenerateUTF8Characters(how_many_characters)
  let a=range(0, a:how_many_characters)
  for i in a
    let icommand='0i' . i . "\t" . 'u' . printf("%04x", i) . "\n" . ''
    execute "normal " . icommand
  endfor
endfunction

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

" gui		" open window and set default for 'background'
" Not using this I think... syntax on	" start highlighting, use 'background' to set colors

