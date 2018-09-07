" Environment checks and feature detection
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License


function! bettersml#check#Smlnj() abort
  if executable(g:sml_smlnj_executable)
    return ['ok', "SML/NJ is executable at '".g:sml_smlnj_executable."'.", []]
  else
    return [
    \   'error',
    \   "SML/NJ is not executable: '".g:sml_smlnj_executable."'.",
    \   [
    \     'SML/NJ only required to launch an integrated REPL.',
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

function! bettersml#check#Support() abort
  let l:vbs_util = bettersml#ScriptRoot().'/bin/vbs-util'
  if executable(l:vbs_util)
    return ['ok', "Support files are executable at '".l:vbs_util."'.", []]
  else
    return [
    \   'error',
    \   'The support files are not executable.',
    \   [
    \     'Certain features like type information and jump to definition',
    \     'require that the support files be built. When MLton is installed,',
    \     "the support files are auto-built; in fact, it's possible they're",
    \     'being built right now (you can check by running :messages).',
    \     'Otherwise, see :help vim-better-sml-support for manual setup.',
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#JobStart() abort
  if !exists('*jobstart') && !exists('*job_start')
    return [
    \   'error',
    \   'Asynchronous jobs are not available.',
    \   [
    \     'Async jobs are required to launch certain background tasks,',
    \     'like using MLton to compile the support files and auto create',
    \     'def-use indices for type information.',
    \     'See :help vim-better-sml-def-use for manual setup instructions.',
    \   ],
    \ ]
  else
    return ['ok', 'Asynchronous jobs are available.', []]
  endif
endfunction

function! bettersml#check#Mlton() abort
  if executable(g:sml_mlton_executable)
    return ['ok', "MLton is executable at '".g:sml_mlton_executable."'.", []]
  else
    return [
    \   'error',
    \   "MLton is not executable: '".g:sml_mlton_executable."'.",
    \   [
    \     'MLton is only required for features like :SMLTypeQuery and :SMLJumpToDef.',
    \     "Potential fix: Ensure the 'mlton' command is in your $PATH.",
    \     'Potential fix: Set g:sml_mlton_executable to the absolute path to MLton.',
    \   ]
    \ ]
  endif
endfunction

function! bettersml#check#Diagnostics() abort
  if exists('g:loaded_ale') && exists('g:loaded_syntastic_plugin')
    return [
    \   'warn',
    \   'Both ALE and Syntastic are loaded. Consider only uninstalling one.',
    \   [
    \     'ALE and Syntastic offer similar features, and frequently step on',
    \     "each others toes. We recommend ALE, as it's faster and more robust.",
    \   ]
    \ ]
  elseif !exists('g:loaded_ale') && !exists('g:loaded_syntastic_plugin')
    return [
    \   'warn',
    \   'Compilation errors will not be reported.',
    \   [
    \     'To have Vim report SML errors and warnings alongside your code,',
    \     'install one of w0rp/ale or scrooloose/syntastic.',
    \     'Also be sure to have SML/NJ installed.',
    \   ]
    \ ]
  else
    return ['ok', 'Either ALE or Syntastic is installed.', []]
  endif
endfunction

function! bettersml#check#MLB() abort
  let l:mlbfile = bettersml#util#GetMlbFileOrEmpty()

  if l:mlbfile !=# ''
    return ['ok', 'MLBasis file found: '.l:mlbfile, []]
  endif

  let l:cmfile = bettersml#util#GetCmFileOrEmpty()

  if l:cmfile !=# ''
    return [
    \   'warn',
    \   'Found CM file for project, but no MLB file.',
    \   [
    \     'vim-better-sml requires an MLB file for multi-file projects to',
    \     'provide features like type information and jump to definition.',
    \     'See :help vim-better-sml-mlbasis for more information.',
    \   ]
    \ ]
  elseif g:sml_auto_create_def_use ==# 'mlb'
    return [
    \   'warn',
    \   'def-use files will not be auto-built',
    \   [
    \     'We did not find an MLBasis file for your project, and you have',
    \     "g:sml_auto_create_def_use = 'mlb'. This means that def-use files",
    \     'will only be auto-built for multi-file projects.',
    \     'See :help g:sml_auto_create_def_use for more information.',
    \   ]
    \ ]
  else
    return [
    \   'warn',
    \   'Running mlton in single-file mode.',
    \   [
    \     'vim-better-sml usually looks for an MLB file to provide features ',
    \     'like type information and jump to definition. If your SML file is',
    \     'actually part of a larger project, consider creating an MLB file.',
    \     'See :help vim-better-sml-mlbasis for more information.',
    \   ]
    \ ]
  endif
endfunction
