" Vim plugin file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

" vim-endwise
if get(g:, "loaded_endwise")
  augroup endwise
    autocmd! FileType ruby
          \ let b:endwise_addition = "end" |
          \ let b:endwise_words = "def,class,module,if,unless,case,while,until,for,begin,do" |
          \ let b:endwise_syngroups = "rubyKeyword,rubyDefine"
  augroup END
endif
