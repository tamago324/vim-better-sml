augroup VimBetterSMLFtDetect
  autocmd!
  autocmd BufRead,BufNewFile *.sig setlocal filetype=sml
  autocmd BufRead,BufNewFile *.cm setlocal filetype=smlcm
  autocmd BufRead,BufNewFile *.mlb setlocal filetype=mlbasis
augroup END
