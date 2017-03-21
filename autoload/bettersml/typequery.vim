" Query expression type information from Vim
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License
"

" Ensure that the *.ud file is up-to-date
" We need this file so that we can grep in it to do the type query
function! bettersml#typequery#LoadUseDef() abort
  let defUseUtil = bettersml#util#GetUseUtil()
  if !executable(l:defUseUtil)
    echom "Have you built the support files?  :help vim-better-sml-def-use"
    return ''
  endif

  let duf = bettersml#util#LoadDefUse()

  " duf doesn't exist; ask user to build
  if l:duf ==# ''
    echom "You need to build a def-use file first.  :help vim-better-sml-def-use"
    return ''
  endif

  let udf = fnamemodify(l:duf, ':r').'.ud'

  " udf doesn't exist or out of date
  if filereadable(l:udf) || getftime(l:duf) > getftime(l:udf)
    call system(l:defUseUtil.' invert '.l:duf.' > '.l:udf)
  endif

  return l:udf
endfunction

function! bettersml#typequery#TypeQuery() abort
  " Get the use-def file
  let udf = bettersml#typequery#LoadUseDef()
  if l:udf ==# ''
    return
  endif

  " Move the cursor to the beginning of the current word
  normal lb

  " Get position of current symbol, and file it occurs in
  let l:sympos = getpos('.')
  let l:symlinecol = l:sympos[1] . '.' . l:sympos[2]
  let l:symfile = resolve(expand('%:p'))

  " Use a bash oneliner to search in the use-def file
  let l:symuse = fnameescape(l:symfile).' '.l:symlinecol
  let l:symdef = system('fgrep -w -A1 "'.l:symuse.'" '.l:udf.' | head -n 2 | tail -n +2')

  if l:symdef ==# ''
    if getftime(expand('%')) > getftime(l:udf)
      let shortudf = fnamemodify(l:udf, ':t')
      echom 'No results. Is the def-use file out of date?'
    else
      echom 'Search for definition information returned no results.'
    endif
    return
  endif

  let parsed = split(l:symdef)

  if l:parsed[0] ==# 'variable' ||
        \ l:parsed[0] ==# 'constructor' ||
        \ l:parsed[0] ==# 'exception'
    let quoted = join(l:parsed[4:])
    let unquoted = strpart(l:quoted, 1, len(l:quoted) - 2)
    echom l:unquoted
  else
    echom l:parsed[0]
  endif
endfunction

