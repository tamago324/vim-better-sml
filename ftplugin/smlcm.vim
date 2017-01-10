" Vim filtype plugin
" Language: SML CM file
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 09 Jan 2017
" License: MIT License

" Use apostrophes in variable names (useful for things like ^P (completion),
" ^W (back delete word), etc.)
setlocal iskeyword+='

" Set comment string so things like vim-commentary and foldmethod can use them
" appropriately.
setlocal commentstring=(*%s*)
