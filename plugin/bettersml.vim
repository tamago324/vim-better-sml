" Bettersml entrypoint
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 24 Aug 2018
" License: MIT License

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

" ----- Commands ------------------------------------------------------------

command! -nargs=0 SMLTypeQuery call bettersml#typequery#TypeQuery()
command! -nargs=0 SMLJumpToDef call bettersml#jumptodef#JumpToDef()

command! -nargs=0 SMLReplStart call bettersml#repl#ReplStart()
command! -nargs=0 SMLReplStop call bettersml#repl#ReplStop()
command! -nargs=0 SMLReplUse call bettersml#repl#ReplUse()
command! -nargs=0 SMLReplBuild call bettersml#repl#ReplBuild()
command! -nargs=0 SMLReplClear call bettersml#repl#ReplClear()
command! -nargs=0 SMLReplOpen call bettersml#repl#ReplOpen()
command! -nargs=? SMLReplPrintDepth call bettersml#repl#ReplPrintDepth(<f-args>)

" Neovim has a robust healthcheck framework for reporting checks.
" For Vim 8, we just echo messages.
if exists(':checkhealth')
  command! -nargs=0 SMLCheckHealth checkhealth bettersml
elseif exists(':CheckHealth')
  command! -nargs=0 SMLCheckHealth CheckHealth bettersml
else
  command! -nargs=0 SMLCheckHealth call health#bettersml#check()
end
