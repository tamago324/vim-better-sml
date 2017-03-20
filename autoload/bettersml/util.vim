" Utility functions for vim-better-sml
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License

" Start in directory a:where and walk up the parent folders until it finds a
" file matching a:what; return path to that file
" Credit: vim-syntastic
function! bettersml#util#findGlobInParent(what, where) abort
    let here = fnamemodify(a:where, ':p')

    let root = '/'

    let old = ''
    while here !=# ''
        try
            " Vim 7.4.279 and later
            let p = globpath(here, a:what, 1, 1)
        catch /\m^Vim\%((\a\+)\)\=:E118/
            let p = split(globpath(here, a:what, 1), "\n")
        endtry

        if !empty(p)
            return fnamemodify(p[0], ':p')
        elseif here ==? root || here ==? old
            break
        endif

        let old = here

        " we use ':h:h' rather than ':h' since ':p' adds a trailing '/'
        " if 'here' is a directory
        let here = fnamemodify(here, ':p:h:h')
    endwhile

    return ''
endfunction

