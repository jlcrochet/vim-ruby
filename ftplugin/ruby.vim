" Vim ftplugin file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

setlocal shiftwidth=2
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal suffixesadd=.rb

if get(g:, "ruby_fold")
  let g:ruby_simple_indent = 0
endif

" matchit.vim
let b:match_words = g:ruby#ftplugin#match_words
let b:match_skip = 'S:^ruby\%(Keyword\|Define\|BlockControl\|DefineBlockControl\)$'
