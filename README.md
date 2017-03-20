# vim-better-sml

> Some improvements to the default SML filetype plugins for Vim.


## Install

Install using your favorite plugin manager. For example, to install using
Vundle, add this line to your ~/.vimrc:

```
Plugin 'jez/vim-better-sml'
```

If you're unfamiliar using Vim plugins, check out [Vim as an IDE][vim-ide] which
will get you up to speed.

## Summary

[![Screenshot](sample/example.png)](https://raw.githubusercontent.com/jez/vim-better-sml/master/sample/example.png)

## Features

- Semantic Information
  - Look up type of identifier under cursor (`:SMLTypeQuery`)
  - Show type errors in sign column
- Syntax
  - Various corrections to default syntax highlighting
  - Conceal characters (`'a` to `α`, `fn` to `λ.`)
  - Highlighting for `*.sig`, `*.cm`, `*.mlb`, `*.lex`, `*.grm`, and
    `*.smackspec` files
- Indentation
  - Better `let ... in ... end` indentation
  - Better indentation with parentheses
- Filetype
  - Set up `'` and `$` as keyword characters
  - Set `'commentstring'` setting
- External plugins
  - delimitMate: set up quote characters
  - a.vim: set up `*.sig` and `*.sml` as alternates
  - Syntastic: detect and use CM files

## Usage

Most things work out of the box. **Some things require setup.**

Complete setup information is available in the help:

> [**`:help vim-better-sml`**](doc/vim-better-sml.txt).

Note: type introspection (`:SMLTypeQuery`) requires that MLton is installed.

## Configuration

A few settings are configurable. See `:help vim-better-sml-config`.

<!--
## Future Features

- [ ] Jump to definition
- [ ] Highlight all uses and definition
- [ ] Highlight unused definitions

- [ ] Indent level is properly adjusted when using nested case statements.
  Consider the following snippet of SML:

      datatype ord = Z | S of ord | Sup of (int -> ord)

      fun toString n =
        case n
          of Z => "0"
           | S n' =>
               (case n'
                  of Z => "1"
                   | S _ => "1 < n < aleph"
                   | _ => "malformed")
           | Sup f => ">= aleph"

  Try transcribing this into Vim right now; the last line isn't indented
  properly. Right now, the indent file indents lines like the last line under
  the most recent `case` keyword, ignoring any nesting structure. See [this
  issue][issue-1] for some of my thoughts on the matter.
-->


## License

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://jez.io/MIT-LICENSE.txt)

<!-- References -->

[vim-ide]: https://github.com/jez/vim-as-an-ide
[issue-1]: https://github.com/jez/vim-better-sml/issues/1
