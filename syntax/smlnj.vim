" Language: SML/NJ REPL output
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Aug 2018
" License: MIT License
"
" Custom syntax highlighting for the SML/NJ REPL when using an embeded
" terminal window.

" ----- Base: syntax/sml.vim ------------------------------------------------
" Because SML/NJ repl is nearly valid SML, we use runtime to load sml.vim
" syntax everywyere, rathar than try to contain it.
"
" Then after, we include our own custom overrides

runtime! syntax/sml.vim
unlet b:current_syntax

" ----- Overrides -----------------------------------------------------------

syntax region SmlnjCompilationLine start=/^\[\(scanning\|library\|parsing\|creating\ directory\|compiling\|code\|loading\|opening\|autoloading\)/ end=/\]$/

syntax match SmlnjCompilationSuccessful /^\[New bindings added\.\]$/
syntax match SmlnjExitedZero /^\[Process exited 0\]$/
syntax match SmlnjExitedNonzero /^\[Process exited [1-9]\d*\]$/
syntax region SmlnjErrorRegion
  \ start=/^.*:\d\+.\d\+/
  \ matchgroup=SmlnjPrompt
  \ end=/^\S\@=/
  \ contains=SmlnjError,SmlnjOperatorOperand,SmlnjUnbound,SmlnjWarning,SmlnjSyntaxError

syntax match SmlnjError /Error:/ contained
syntax match SmlnjWarning /Warning:/ contained

syntax match SmlnjOperatorOperand /  operator domain: / contained
syntax match SmlnjOperatorOperand /  operand: / contained
syntax match SmlnjOperatorOperand /  operator: / contained
syntax region SmlnjUnbound matchgroup=SmlnjUnboundStart start=/unbound variable or constructor: / end=/$/
syntax match SmlnjSyntaxError /syntax error:/ contained

syntax match SmlnjGreeting /^Standard ML of New Jersey.*$/
syntax match SmlnjPrompt /^\[-=\] /

hi def link SmlnjGreeting Underlined
hi def link SmlnjCompilationLine Comment

hi def link SmlnjExitedZero Statement
hi def link SmlnjExitedNonzero Error

hi def link SmlnjCompilationSuccessful Statement
hi def link SmlnjError Error
hi def link SmlnjOperatorOperand Constant
hi def link SmlnjUnboundStart Ignore
hi def link SmlnjUnbound Identifier
hi def link SmlnjSyntaxError PreProc

hi def link SmlnjWarning Underlined

hi def link SmlnjPrompt Ignore

let b:current_syntax = 'smlnj'
