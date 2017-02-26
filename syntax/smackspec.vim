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
"   Adds syntax highlighting for *.smackspec files.
"   For use with the Smackage package manager for SML.
"
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'smackspec'

syn match smackspecKey "^\s*[^:]\+\(:\)\@="
hi link smackspecKey Identifier

syn match smackspecComment "\v\s*comment:.*$" contains=smackspecTodo
hi link smackspecComment Comment

syn keyword smackspecTodo contained TODO FIXME XXX
hi link smackspecTodo Todo

syn match smackspecVersion "[0-9]\+\(\.[0-9]\+\)*"
hi link smackspecVersion Number


