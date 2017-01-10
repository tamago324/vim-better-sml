" SML signature files
augroup VimBetterSMLFtDetect
  autocmd!
  autocmd BufRead,BufNewFile *.sig setlocal filetype=sml
  autocmd BufRead,BufNewFile *.cm setlocal filetype=smlcm
augroup END
