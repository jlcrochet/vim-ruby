" Vim ftplugin file
" Language: Ruby Signature (RBS) <github.com/ruby/rbs>
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_ftplugin')
  finish
endif

setlocal
      \ shiftwidth=2
      \ comments=:#
      \ commentstring=#\ %s
      \ suffixesadd=.rbs

if get(g:, "ruby_fold")
  setlocal foldmethod=syntax
endif

" matchit.vim
let b:match_words = '\<\%(class\|module\|interface\)\>:\<end\>'
let b:match_skip = 's:^rbs\%(String\|Symbol\|Comment\)$'

let b:undo_ftplugin = "setl shiftwidth< comments< commentstring< suffixesadd<"

let b:did_ftplugin = 1
