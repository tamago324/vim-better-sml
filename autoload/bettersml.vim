" Utility functions which we want short names for
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License

let s:scriptroot = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! bettersml#ScriptRoot() abort
  return s:scriptroot
endfunction

function! bettersml#Error(error) abort
  echohl Error
  echomsg a:error
  echohl None
endfunction

function! bettersml#Enforce(check) abort
  let [l:severity, l:msg, l:suggestions] = a:check

  if l:severity ==# 'ok'
    return 1
  endif

  if len(l:suggestions) > 1
    let l:formatted = join([l:msg, 'See :SMLCheckHealth for suggestions.'])
  else
    let l:formatted = join([l:msg, join(l:suggestions)])
  endif

  call bettersml#Error(l:severity.': '.l:formatted)
  return 0
endfunction

