" Environment checks and feature detection
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License


function! bettersml#check#Smlnj(smlnj_exe) abort
  if executable(a:smlnj_exe)
    return ['ok', "SML/NJ is executable at '".a:smlnj_exe."'.", []]
  else
    return [
    \   'error',
    \   "SML/NJ is not executable: '".a:smlnj_exe."'.",
    \   [
    \     "Potential fix: Ensure the 'sml' command is in your $PATH.",
    \     'Potential fix: Set g:sml_smlnj_executable to the absolute path to SML/NJ.',
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#Rlwrap() abort
  if executable('rlwrap')
    return ['ok', 'rlwrap is available and will be used to launch REPLs', []]
  else
    return [
    \   'warn',
    \   'rlwrap was not found on your $PATH.',
    \   [
    \     "rlwrap is optional. When found, it's used to launch the SML/NJ REPL.",
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#Support(vbs_util) abort
  if executable(a:vbs_util)
    return ['ok', 'The support files have been compiled.', []]
  else
    return [
    \   'error',
    \   'The support files are not executable.',
    \   [
    \     'Certain features like type information and jump to definition',
    \     'require that the support files be built.',
    \     'When MLton is installed, the support files are auto-built.',
    \     'See :help vim-better-sml-def-use for manual setup instructions.',
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#Mlton(mlton_exe) abort
  if executable(a:mlton_exe)
    return ['ok', "MLton is executable at '".a:mlton_exe."'.", []]
  else
    return [
    \   'error',
    \   "MLton is not executable: '".a:mlton_exe."'.",
    \   [
    \     'MLton is only required for features like :SMLTypeQuery and :SMLJumpToDef.',
    \     "Potential fix: Ensure the 'mlton' command is in your $PATH.",
    \     'Potential fix: Set g:sml_mlton_executable to the absolute path to MLton.',
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#Ale() abort
  if exists('g:loaded_ale')
    return ['ok', 'ALE is installed.', []]
  else
    return [
    \   'error',
    \   'The :SMLRepl* functions require w0rp/ale to be installed.',
    \   [
    \     'Why? ALE is able to robustly discover CM files for SML/NJ projects.',
    \     "Rather than duplicate that logic, we call into ALE's helpers.",
    \     "Note that you don't have to have any SML linters enabled;",
    \     'you just have to have the ALE plugin installed.',
    \   ]
    \ ]
  endif
endfunction
