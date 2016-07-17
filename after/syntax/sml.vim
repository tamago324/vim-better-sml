" Vim filtype plugin
" Language: SML
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 16 Jul 2016
" License: MIT License
"
" Description:
"   Assorted improvements on syntax highlighting for SML
"
"
" Usage:
"   To allow Vim to conceal things like 'a -> α in SML, use:
"
"       au! FileType sml setlocal conceallevel=2
"

" Fix wonky highlighting for => operator
syn match smlOperator  "=>"

" Also highlight 'NOTE' and 'Note' in comments
syn keyword  smlTodo contained NOTE Note

" Highlight type variables (i.e., tokens that look like 'xyz)
syn match smlType "\<'\w\+\>"

" Add conceal characters for common greek letters
" that are used for type variables
syn match smlType "'a\>"               conceal cchar=α
syn match smlType "'alpha\>"           conceal cchar=α
syn match smlType "'b\>"               conceal cchar=β
syn match smlType "'beta\>"            conceal cchar=β
syn match smlType "'c\>"               conceal cchar=γ
syn match smlType "'gamma\>"           conceal cchar=γ
syn match smlType "'d\>"               conceal cchar=δ
syn match smlType "'delta\>"           conceal cchar=δ
syn match smlType "'e\>"               conceal cchar=ε
syn match smlType "'epsilon\>"         conceal cchar=ε

syn match smlType "'zeta\>"            conceal cchar=ζ
syn match smlType "'eta\>"             conceal cchar=η
syn match smlType "'theta\>"           conceal cchar=θ
syn match smlType "'kappa\>"           conceal cchar=κ
syn match smlType "'lambda\>"          conceal cchar=λ

syn match smlType "'m\>"               conceal cchar=μ
syn match smlType "'mu\>"              conceal cchar=μ
syn match smlType "'n\>"               conceal cchar=ν
syn match smlType "'nu\>"              conceal cchar=ν

syn match smlType "'xi\>"              conceal cchar=ξ

syn match smlType "'p\>"               conceal cchar=π
syn match smlType "'pi\>"              conceal cchar=π
syn match smlType "'r\>"               conceal cchar=ρ
syn match smlType "'rho\>"             conceal cchar=ρ
syn match smlType "'s\>"               conceal cchar=σ
syn match smlType "'sigma\>"           conceal cchar=σ
syn match smlType "'t\>"               conceal cchar=τ
syn match smlType "'tau\>"             conceal cchar=τ

syn match smlType "'upsilon\>"         conceal cchar=υ
syn match smlType "'phi\>"             conceal cchar=ϕ
syn match smlType "'x\>"               conceal cchar=χ
syn match smlType "'chi\>"             conceal cchar=χ

syn match smlType "'psi\>"             conceal cchar=ψ

syn match smlType "'w\>"               conceal cchar=ω
syn match smlType "'omega\>"           conceal cchar=ω

" --- Coneal lambda functions with lambda ---
" We need to redefine fn as a 'match', not a 'keyword' because 'keyword' takes
" precedence, but can't have 'contains'
syn clear smlKeyword

" These are copy/pasted from $VIMRUNTIME/syntax/sml.vim ...
if exists("sml_noend_error")
  syn match    smlKeyword    "\<end\>"
endif
syn region   smlKeyword start="\<signature\>" matchgroup=smlModule end="\<\w\(\w\|'\)*\>" contains=smlComment skipwhite skipempty nextgroup=smlMTDef
syn keyword  smlKeyword  and andalso case
syn keyword  smlKeyword  datatype else eqtype
" ... but this line is different: there's no fun or fn
syn keyword  smlKeyword  exception handle
syn keyword  smlKeyword  in infix infixl infixr
syn keyword  smlKeyword  match nonfix of orelse
syn keyword  smlKeyword  raise handle type
syn keyword  smlKeyword  val where while with withtype

" Finally, define fn with a 'match' not a 'keyword' for the 'contains='
syn match smlFunction "\<fn\>" contains=smlFnLam,smlFnDot
syn cluster smlContained add=smlFnLam,smlFnDot
" Hack: use two match groups, so we can simulate a two-character conceal
syn match smlFnLam "f"                 contained conceal cchar=λ
syn match smlFnDot "n"                 contained conceal cchar=.
" -------------------------------------------

" Define match group for SML function keywords
syn keyword smlFunction fun

" Color fun and fn as Function
hi def link smlFunction Function
hi def link smlFnLam Function
hi def link smlFnDot Function
