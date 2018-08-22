" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Aug 2018
" License: MIT License
"
" Spawn and manage an SML/NJ repl.
"
" ----- Implementation notes ------------------------------------------------
"
" This feature was inpired by parsonsmatt/intero-neovim.
" This code is significantly less involved for a number of reasons:
"
" - It supports multiple Haskell REPLs (intero, GHCi, etc.).
"   We support only one SML REPL (SML/NJ).
"
" - It builds intero into the current stack project.
"   We just use the global SML/NJ executable.
"
" - It has features like InteroType that depend on parsing REPL output.
"   We don't look at or parse the REPL's output.
"
" If in the future you're considering invalidating any of these points,
" consider studying the intero-neovim codebase as a frame of reference.

" ----- Defaults ------------------------------------------------------------

if !exists('g:sml_repl_backend')
  if exists('*jobstart')
    let g:sml_repl_backend = 'neovim'
  elseif exists('$TMUX') && exists(':VimuxRunCommand')
    let g:sml_repl_backend = 'vimux'
  else
    let g:sml_repl_backend = ''
  endif
endif

if !exists('g:sml_smlnj_executable')
  let g:sml_smlnj_executable = 'sml'
endif

if !exists('g:sml_repl_options')
  let g:sml_repl_options = ''
endif

if !exists('g:sml_mlton_executable')
  let g:sml_mlton_executable = 'mlton'
endif

" ----- Sanity checks -------------------------------------------------------

function! bettersml#process#CheckBackend(backend) abort
  let l:backends = {
        \ 'neovim': 1,
        \ 'vimux': 1,
        \ }
  if !has_key(l:backends, a:backend)
    if a:backend ==# ''
      return [
      \   'error',
      \   'No REPL backend available.',
      \   [
      \     'To use the SML/NJ REPL, you must either be using Neovim',
      \     'or be using tmux and have benmills/vimux installed.',
      \   ]
      \ ]
    else
      return [
      \   'error',
      \   "Invalid REPL backend: '".g:sml_repl_backend."'.",
      \   ['Valid backends: '.join(keys(l:backends), ', ')]
      \ ]
    endif
  else
    return ['ok', 'REPL backend is available and valid: '.a:backend, []]
  endif
endfunction

function! bettersml#process#CheckJobStart() abort
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

" ----- Terminal buffer / pane control --------------------------------------

" Creates a new buffer for the SML/NJ repl
function! bettersml#process#StartBuffer(options) abort
  if exists('s:repl_buffer_id')
    call bettersml#Error('SML/NJ repl buffer has already been started.')
    return
  endif

  call bettersml#Enforce(bettersml#check#Smlnj(g:sml_smlnj_executable))

  let l:args = [g:sml_smlnj_executable, g:sml_repl_options, a:options]
  if executable('rlwrap')
    call insert(l:args, 'rlwrap', 0)
  endif
  let l:command = join(l:args)

  if g:sml_repl_backend ==# 'neovim'
    let l:original_window = winnr()

    " Create and set up the terminal buffer
    vert split
    enew
    silent call termopen(l:command)
    silent file SMLNJ
    set noswapfile
    set filetype=smlnj

    augroup smlnjCleanup
      autocmd!
      autocmd TermClose <buffer> silent! unlet s:repl_job_id
      autocmd TermClose <buffer> silent! unlet s:repl_buffer_id
    augroup END

    let s:repl_job_id = b:terminal_job_id
    let s:repl_buffer_id = bufnr('%')

    " Switch focus back to original window
    exe 'silent! ' . l:original_window . 'wincmd w'

  elseif g:sml_repl_backend ==# 'vimux'
    let s:repl_buffer_id = '[vimux]'
    let g:VimuxResetSequence = 'C-u'
    VimuxRunCommand l:command

  else
    call bettersml#Enforce(bettersml#process#CheckBackend(g:sml_repl_backend))

  endif
endfunction

" Kills the SML/NJ buffer, if it exists
function! bettersml#process#KillBuffer() abort
  if !exists('s:repl_buffer_id')
    call bettersml#Error("SML/NJ repl buffer isn't started or has already been killed.")
    silent! unlet s:repl_job_id
    return
  end

  if g:sml_repl_backend ==# 'neovim'
    if bufexists(s:repl_buffer_id)
      " Deleting a terminal buffer implicitly stops the job
      exe 'bdelete! ' . s:repl_buffer_id
    endif
  elseif g:sml_repl_backend ==# 'vimux'
    VimuxCloseRunner
    silent! unlet s:repl_job_id
    silent! unlet s:repl_buffer_id
  else
    call bettersml#Enforce(bettersml#process#CheckBackend(g:sml_repl_backend))
  end
endfunction

" Sends a command to the terminal backend.
function! bettersml#process#SendCommand(command) abort
  if !exists('s:repl_buffer_id')
      call bettersml#Error('The SML/NJ repl buffer is not running. Start it with :SMLReplStart')
      return
  endif

  if g:sml_repl_backend ==# 'neovim'
    " The trailing '' is to ask Neovim to send a newline after the command
    call jobsend(s:repl_job_id, [a:command, ''])
  elseif g:sml_repl_backend ==# 'vimux'
    " Vimux hands the command right off to tmux, where ; usually ends up
    " terminating the tmux command, instead of making it through to the repl.
    VimuxRunCommand escape(a:command, ';')
  else
    call bettersml#Enforce(bettersml#process#CheckBackend(g:sml_repl_backend))
  endif
endfunction

