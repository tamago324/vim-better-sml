" Utility functions for vim-better-sml
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License

function! bettersml#util#GetVbsUtil() abort
  let [l:severity, l:msg, l:suggestions] = bettersml#check#Support()
  if l:severity ==# 'error'
    call bettersml#process#BuildVbsUtil()
    " Builds support files asynchronously. For now, return ''
    return ''
  else
    return bettersml#ScriptRoot().'/bin/vbs-util'
  endif
endfunction

" Start in directory a:where and walk up the parent folders until it finds a
" file matching a:what; return path to that file
" Credit: vim-syntastic
function! bettersml#util#findGlobInParent(what, where) abort
    let l:here = fnamemodify(a:where, ':p')

    let l:root = '/'

    let l:old = ''
    while l:here !=# ''
        try
            " Vim 7.4.279 and later
            let l:p = globpath(l:here, a:what, 1, 1)
        catch /\m^Vim\%((\a\+)\)\=:E118/
            let l:p = split(globpath(l:here, a:what, 1), "\n")
        endtry

        if !empty(l:p)
            return fnamemodify(l:p[0], ':p')
        elseif l:here ==? l:root || l:here ==? l:old
            break
        endif

        let l:old = l:here

        " we use ':h:h' rather than ':h' since ':p' adds a trailing '/'
        " if 'here' is a directory
        let l:here = fnamemodify(l:here, ':p:h:h')
    endwhile

    return ''
endfunction

function! bettersml#util#LoadDefUse() abort
  return bettersml#util#findGlobInParent('*.du', expand('%:p:h', 1))
endfunction

" Ensure that the *.ud file is up-to-date
function! bettersml#util#LoadUseDef(...) abort
  if a:0 ==# 0
    let l:async = 0
  else
    let l:async = 1
  endif

  let l:vbsUtil = bettersml#util#GetVbsUtil()
  if l:vbsUtil ==# ''
    " The support files are compiling. A message was already printed.
    return ''
  endif

  if !executable(l:vbsUtil)
    echom 'Please build the support files manually.  :help vim-better-sml-support'
    return ''
  endif

  let l:duf = bettersml#util#LoadDefUse()

  " duf doesn't exist; ask user to build
  if l:duf ==# ''
    echom 'You need to build a def-use file first.  :help vim-better-sml-def-use'
    return ''
  endif

  let l:udf = fnamemodify(l:duf, ':r').'.ud'

  " udf doesn't exist or out of date
  if !filereadable(l:udf) || getftime(l:duf) > getftime(l:udf)
    let l:command = l:vbsUtil.' invert '.l:duf.' > '.l:udf

    if l:async
      if exists('*jobstart')
        call jobstart(l:command)
      elseif exists('*job_start')
        call job_start(['/bin/sh', '-c', l:command])
      end
    else
      call system(l:command)
    endif
  endif

  return l:udf
endfunction

" Get line number and column in a format suitable
" for grepping in a def-use or use-def file
function! bettersml#util#SymLineCol() abort
  let l:sympos = getpos('.')
  return l:sympos[1] . '.' . l:sympos[2]
endfunction

function! bettersml#util#LoadConfig() abort
  " We're hard-coding 'sml.json' as the config file name.
  return bettersml#util#findGlobInParent('sml.json', expand('%:p:h', 1))
endfunction

function! bettersml#util#GetCmFilePattern()
  let l:configFile = bettersml#util#LoadConfig()

  if l:configFile ==# ''
    return '*.cm'
  else
    let l:vbsUtil = bettersml#util#GetVbsUtil()

    if l:vbsUtil ==# ''
      echom 'Detected an sml.json file, but the support are still building.'
      return '*.cm'
    elseif !executable(l:vbsUtil)
      echom "Detected an sml.json file, but the support files aren't executable."
      return '*.cm'
    else
      " Use systemlist(...)[0] to avoid trailing newlines
      let l:result = systemlist(l:vbsUtil.' config '.l:configFile.' cm.make/onSave')[0]

      if v:shell_error
        echom l:result
        return '*.cm'
      else
        return l:result
      endif
    endif
  endif
endfunction

function! bettersml#util#GetCmFileOrEmpty() abort
  let l:cmPattern = bettersml#util#GetCmFilePattern()
  return bettersml#util#findGlobInParent(l:cmPattern, expand('%:p:h', 1))
endfunction

function! bettersml#util#GetMlbFileOrEmpty() abort
  return bettersml#util#findGlobInParent('*.mlb', expand('%:p:h', 1))
endfunction

function! bettersml#util#FormattedDefUseCommand(input, output) abort
  let l:cmd = g:sml_def_use_command
  return substitute(substitute(l:cmd, '%i', a:input, ''), '%o', a:output, '')
endfunction
