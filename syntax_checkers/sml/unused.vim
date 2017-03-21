" Syntastic checker for unused variables
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 20 Mar 2017
" License: MIT License
"

if exists('g:loaded_syntastic_sml_unused_checker')
    finish
endif
let g:loaded_syntastic_sml_mlton_unused_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_sml_unused_IsAvailable() dict abort
  return executable(self.getExec())
        \ && filereadable(bettersml#util#LoadDefUse())
endfunction

function! SyntaxCheckers_sml_unused_GetLocList() dict abort

  let duf = bettersml#util#LoadDefUse()

  let makeprg = self.makeprgBuild({
        \ 'args': 'unused ' . syntastic#util#shescape(l:duf),
        \ 'fname': '' })

  let errorformat  = '%WWarning: %f %l\.%c ,%Z%m'

  return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'sml',
      \ 'name': 'unused',
      \ 'exec': bettersml#util#GetDefUseUtil() })

let &cpo = s:save_cpo
unlet s:save_cpo


