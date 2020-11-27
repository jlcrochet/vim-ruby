" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

" Caching important syntax ID's for use in indentation logic
const g:ruby#multiline_regions = {}

for id in ["rubyString", "rubySymbol", "rubyRegex", "rubyCommand", "rubyComment", "rubyHeredocLine", "rubyHeredocLine", "rubyHeredocDelimiter"]
  let g:ruby#multiline_regions[hlID(id)] = 1
endfor

const g:ruby#keyword = hlID("rubyKeyword")
const g:ruby#operator = hlID("rubyOperator")
const g:ruby#delimiter = hlID("rubyDelimiter")
const g:ruby#comment = hlID("rubyComment")
const g:ruby#comment_delimiter = hlID("rubyCommentDelimiter")
