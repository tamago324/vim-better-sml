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

function! bettersml#process#ValidateBackend(backend) abort
  let l:backends = {
        \ 'neovim': 1,
        \ 'vimux': 1,
        \ }
  if !has_key(l:backends, a:backend)
    let l:keys = join(keys(l:backends), ', ')

    echohl Error
    if a:backend ==# '[default]'
      echomsg 'No REPL backend available. See :help vim-better-sml-repl to learn more.'
    else
      echomsg 'Invalid REPL backend: '.g:sml_repl_backend.'. Valid backends: '.l:keys
    endif
    echohl None
  endif
endfunction

" Creates a new buffer for the SML/NJ repl, using a:command.
function! bettersml#process#StartBuffer(options) abort
  if exists('s:repl_buffer_id')
    echohl Error
    echomsg 'SML/NJ repl buffer has already been started.'
    echohl None
    return
  endif

  let l:command = join([
          \ g:sml_repl_command,
          \ g:sml_repl_options,
          \ a:options,
          \ ])

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
    call bettersml#process#ValidateBackend(g:sml_repl_backend)

  endif
endfunction

" Kills the SML/NJ buffer, if it exists
function! bettersml#process#KillBuffer() abort
  if !exists('s:repl_buffer_id')
    echohl Error
    echomsg "SML/NJ repl buffer isn't started or has already been killed."
    echohl None
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
    call bettersml#process#ValidateBackend(g:sml_repl_backend)
  end
endfunction


" Sends a command to the terminal backend.
function! bettersml#process#SendCommand(command) abort
  if !exists('s:repl_buffer_id')
      echohl Error
      echomsg 'The SML/NJ repl buffer is not running. Start it with :SMLReplStart'
      echohl None
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
    call bettersml#process#ValidateBackend(g:sml_repl_backend)
  endif
endfunction

