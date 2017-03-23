" Jump to symbol definition
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 21 Mar 2017
" License: MIT License
"

if !exists('g:sml_jump_to_def_new_tab')
  let g:sml_jump_to_def_new_tab = 0
endif

function! bettersml#jumptodef#JumpToDef() abort
  " Need to make sure use def is up-to-date to do the type query
  let udf = bettersml#util#LoadUseDef()
  if l:udf ==# ''
    return
  endif

  " Move the cursor to the beginning of the current word
  normal lb

  " Get position of current symbol, and file it occurs in
  let l:symlinecol = bettersml#util#SymLineCol()
  let l:symfile = resolve(expand('%:p'))

  " Use a bash oneliner to search in the use-def file
  let l:symloc = fnameescape(l:symfile).' '.l:symlinecol
  let l:symdef = system('grep -w -A1 "'.l:symloc.'" '.l:udf.' | head -n 2 | tail -n +2')

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

  let identType = parsed[0]
  let ident = parsed[1]
  let identFile = parsed[2]
  let identLineCol = split(parsed[3], '\.')
  let identLine = identLineCol[0]
  let identCol = identLineCol[1]

  if g:sml_jump_to_def_new_tab
    exe 'tabnew +'.l:identLine.' '.l:identFile
  else
    exe 'edit +'.l:identLine.' '.l:identFile
  endif
  call cursor(0, identCol)
endfunction

