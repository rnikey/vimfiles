" arrows.vim

" Author      : Michael Bihari
" Date        : 13th March 2014
" Version     : 1.0
" Description : Original creation.

function! Mylarrow()
  if col(".") == 1  "If we are at the first column on the line
    if line(".") != 1 "We are not at the top line already
      normal! k$
    else
      echo "At first character"
    endif
  else
    normal! h
  endif
endfunction "Mylarrow
 

function! Myrarrow()
  let l:lastcol = col("$") - 1
  if ! l:lastcol || col(".") == l:lastcol  "We are on the last column of the line
    if line(".") != line("$") "We are not at the last line already
      normal! j0
    else
      echo "At last character"
    endif
  else
    normal! l
  endif
endfunction "Myrarrow
 
" The key mappings...
nnoremap <silent> <Left> :call Mylarrow()<cr>
nnoremap <silent> <Right> :call Myrarrow()<cr>


