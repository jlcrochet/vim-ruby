" Vim ftplugin file
" Language: Ruby Signature (RBS) <github.com/ruby/rbs>
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

setlocal shiftwidth=2
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal suffixesadd=.rbs

" matchit.vim
let b:match_words = '\<\%(class\|module\|interface\)\>:\<end\>'
let b:match_skip = 's:^rbs\%(String\|Symbol\|Comment\)$'
