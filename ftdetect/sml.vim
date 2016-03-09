" SML signature files
augroup VimBetterSMLFtDetect
  autocmd!
  autocmd BufRead,BufNewFile *.sig setlocal filetype=sml
augroup END
