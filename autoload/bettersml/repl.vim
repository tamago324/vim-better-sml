" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Aug 2018
" License: MIT License
"
" Communicate with an SML/NJ repl to run user commands.
"
" ----- Implementation notes ------------------------------------------------
"
" In a lot of these commands, we prefer `val _ = ...;` instead of `...;`
" because the former surpresses the return value, so that
"
" - people can still use the `it` from their previous command
" - SML/NJ doesn't print otherwise useless output (like `val it = true;`)

" ----- REPL commands -------------------------------------------------------

function! bettersml#repl#ReplStart() abort
  let l:cmfile = bettersml#util#GetCmFileOrEmpty()

  if l:cmfile is# ''
    let l:curfile = expand('%')
    call bettersml#process#StartBuffer(l:curfile)
  else
    call bettersml#process#StartBuffer("-m '".l:cmfile."'")
  endif
endfunction

function! bettersml#repl#ReplStop() abort
  call bettersml#process#KillBuffer()
endfunction

function! bettersml#repl#ReplUse() abort
  let l:curfile = expand('%')
  call bettersml#process#SendCommand('val _ = use "'.l:curfile.'";')
endfunction

function! bettersml#repl#ReplBuild() abort
  let l:cmfile = bettersml#util#GetCmFileOrEmpty()
  if l:cmfile is# ''
    " No CM file found; fall back to using the current file.
    call bettersml#repl#ReplUse()
  else
    call bettersml#process#SendCommand('val _ = CM.make "'.l:cmfile.'";')
  endif
endfunction

function! bettersml#repl#ReplClear() abort
  call bettersml#process#SendCommand('val _ = OS.Process.system "clear";')
endfunction

function! bettersml#repl#ReplOpen() abort
  " HACK(jez) Search backwards to find structure rooted at top-level
  "
  " In the future, we could re-implement this using SML/NJ's Visible Compiler
  " to find the top-level structure containing the user's cursor.
  let l:regex = '^structure \(\w[A-Za-z0-9_]*\)\>'
  let l:line = search(l:regex, 'cnbW')
  if l:line == 0
    " No result
    echom 'Could not infer current structure. Is your cursor in a structure?'
    return
  endif

  " [0] => entire match. [1] => first match group
  let l:structure_name = matchlist(getline(l:line), l:regex)[1]

  call bettersml#process#SendCommand('open '.l:structure_name.';')
endfunction

function! bettersml#repl#ReplPrintDepth(...) abort
  if a:0 ==# 1
    let l:depth = a:1
  else
    let l:depth = 100
  endif

  call bettersml#process#SendCommand('val _ = Control.Print.printDepth := '.l:depth.';')
endfunction
