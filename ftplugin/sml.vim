" Vim filtype plugin
" Language: SML
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 08 Mar 2016
" License: MIT License

" Use apostrophes in variable names (useful for things like ^P (completion),
" ^W (back delete word), etc.)
setlocal iskeyword+='

" Set comment string so things like vim-commentary and foldmethod can use them
" appropriately.
setlocal commentstring=(*%s*)

" ----- Raimondi/delimitMate -----
let b:delimitMate_quotes = "\""

" ----- scrooloose/syntastic -----
" Attempt to detect CM files in SML/NJ checker
function! s:DetectCM(fname) abort
  let cm = syntastic#util#findGlobInParent('*.cm', fnamemodify(a:fname, ':p:h'))
  if cm !=# ''
    let buf = bufnr(fnameescape(a:fname))
    call setbufvar(buf, 'syntastic_sml_smlnj_args', '-m ' . syntastic#util#shescape(cm))
    call setbufvar(buf, 'syntastic_sml_smlnj_fname', '')
  endif
endfunction

call s:DetectCM(expand('<amatch>', 1))

" ----- a.vim -----
" Sets up *.sig and *.sml files as "alternates", similar to how *.h and *.c
" files are alternates
let g:alternateExtensions_sml = "sig"
let g:alternateExtensions_sig = "sml"

