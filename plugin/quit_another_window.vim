"=============================================================================
" File:        quit_another_window.vim
" Author:      Dmitry Frank (dimon.frank@gmail.com)
" Version:     1.02
"=============================================================================
" See documentation in accompanying help file
" You may use this code in whatever way you see fit.


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
function! <SID>QuitAnotherWindow(sWincmd)

   if empty(a:sWincmd)
      :q
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
   :q

   " go to starting window
   while (winnr() != l:iCurWinnr)
      :wincmd w
   endwhile
endfunction



" define plugin's commands
command! -nargs=? -complete=file Qh call <SID>QuitAnotherWindow('h')
command! -nargs=? -complete=file Qj call <SID>QuitAnotherWindow('j')
command! -nargs=? -complete=file Qk call <SID>QuitAnotherWindow('k')
command! -nargs=? -complete=file Ql call <SID>QuitAnotherWindow('l')

command! -nargs=? -complete=file Q call <SID>QuitAnotherWindow("<args>")



" define lowercased aliases if possible
if exists("loaded_cmdalias") && exists("*CmdAlias")
   call CmdAlias('qh', 'Qh')
   call CmdAlias('qj', 'Qj')
   call CmdAlias('qk', 'Qk')
   call CmdAlias('ql', 'Ql')

   call CmdAlias('q', 'Q')
endif



