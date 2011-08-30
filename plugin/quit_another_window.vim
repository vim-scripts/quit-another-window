"=============================================================================
" File:        quit_another_window.vim
" Author:      Dmitry Frank (dimon.frank@gmail.com)
" Version:     1.04
"=============================================================================
" See documentation in accompanying help file
" You may use this code in whatever way you see fit.

function! s:getchar()
  let c = getchar()
  if c =~ '^\d\+$'
    let c = nr2char(c)
  endif
  return c
endfunction

function! s:inputtarget()
  let a = s:getchar()
  let c = ''
  while a != ' '
    if a =~ '^[hjkl]$'
      let c = c . a
    endif
    let a = s:getchar()
  endwhile
  return c
endfunction

function! <SID>QuitWindow(boolBang)
   if (!a:boolBang)
      :q
   else
      :q!
   endif
endfunction

"" function to close other window
"  @param sWincmd - window movement command(s). 
"                   for example, "h" used to close left window,
"                                "j" used to close lower window,
"                                etc.
"
"                   You can combine them:
"                                "jl" used to go to lower window, 
"                                     then go to right window,
"                                     then close it.
"                                etc.
function! <SID>QuitAnotherWindow(sWincmd, boolBang)

   if empty(a:sWincmd)
      call <SID>QuitWindow(a:boolBang)
      return
   endif

   " remember current winnr, e.g. winnr of starting window
   " (we need to go to the same winnr after close other window)
   let l:iCurWinnr = winnr()

   let l:iIndex = 0
   
   while (l:iIndex < strlen(a:sWincmd))
      " move to window that should be closed and get its winnr
      exec 'wincmd '.a:sWincmd[l:iIndex]
      let l:iClosedWinnr = winnr()

      let l:iIndex += 1
   endwhile

   " if its winnr is the same as starting winnr, then do nothing.
   " (you should use just :q instead)
   if (l:iCurWinnr == l:iClosedWinnr)
      return
   endif

   " calculate target winnr
   if (l:iCurWinnr > l:iClosedWinnr)
      let l:iCurWinnr -= 1
   endif

   " close needed window
   call <SID>QuitWindow(a:boolBang)

   " go to starting window
   while (winnr() != l:iCurWinnr)
      :wincmd w
   endwhile
endfunction



" define plugin's commands
command! -nargs=? -bang -complete=file Qh call <SID>QuitAnotherWindow('h', <bang>0)
command! -nargs=? -bang -complete=file Qj call <SID>QuitAnotherWindow('j', <bang>0)
command! -nargs=? -bang -complete=file Qk call <SID>QuitAnotherWindow('k', <bang>0)
command! -nargs=? -bang -complete=file Ql call <SID>QuitAnotherWindow('l', <bang>0)

command! -nargs=? -bang -complete=file Q call <SID>QuitAnotherWindow("<args>", <bang>0)

nnoremap <silent> <Plug>QAnotherWin :<C-U>call <SID>QuitAnotherWindow(<SID>inputtarget(), 0)<CR>
if !hasmapto("<Plug>QAnotherWin","n")
   nmap <silent> <C-z> <Plug>QAnotherWin
endif

" define lowercased aliases if possible
if exists("loaded_cmdalias") && exists("*CmdAlias")
   call CmdAlias('qh', 'Qh')
   call CmdAlias('qj', 'Qj')
   call CmdAlias('qk', 'Qk')
   call CmdAlias('ql', 'Ql')

   call CmdAlias('q', 'Q')
endif

