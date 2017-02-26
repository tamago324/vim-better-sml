" > Copyright (c) 2016 Thomas Allen <thomas@oinksoft.com>
"
" > Permission is hereby granted, free of charge, to any person obtaining a
" > copy of this software and associated documentation files (the
" > "Software"), to deal in the Software without restriction, including
" > without limitation the rights to use, copy, modify, merge, publish,
" > distribute, sublicense, and/or sell copies of the Software, and to
" > permit persons to whom the Software is furnished to do so, subject to
" > the following conditions:
"
" > The above copyright notice and this permission notice shall be included
" > in all copies or substantial portions of the Software.
"
" > THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
" > OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" > MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" > IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
" > CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" > TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
" > SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" Author: Thomas Allen <thomas@oinksoft.com>
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" License: MIT License
"
" Description:
"   Adds syntax highlighting for *.mlb (ML Basis) files.
"   For use with the MLton compiler.
"
"
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'mlbasis'

syn keyword mlbasisKeyword and ann basis functor end in local let open structure signature
hi link mlbasisKeyword Keyword

syn match mlbasisPath ".\+\.\(fun\|mlb\|sig\|sml\)" contains=mlbasisPathMapping
hi link mlbasisPath Identifier

syn match mlbasisPathMapping "\$([A-Za-z_]\+)"
hi link mlbasisPathMapping Preproc

syn keyword mlbasisTodo contained TODO FIXME XXX
hi link mlbasisTodo Todo

syn region mlbasisComment start="(\*" end="\*)" contains=mlbasisComment,mlbasisTodo
hi link mlbasisComment Comment
