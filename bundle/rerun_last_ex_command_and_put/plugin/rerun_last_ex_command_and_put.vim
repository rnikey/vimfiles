" rerun_last_ex_command_and_put.vim

" Author      : Michael Bihari
" Date        : 13th March 2014
" Version     : 1.0
" Description : Original creation.

" Function that I use for testing
function! MyMessage()
  echo "This is MyMessage"
endfunction "MyMessage


" Function to rerun the last ex command that you ran and put the result in the buffer.
function! Rerun_last_ex_command_and_put()
" The : register holds the last command, which is what I need.
  redir => l:temp
    normal! @:
  redir END
  put=l:temp
endfunction

nnoremap <silent> <leader>p  :silent call Rerun_last_ex_command_and_put()<cr>
