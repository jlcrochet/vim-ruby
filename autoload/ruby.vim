" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

" Caching important syntax ID's for use in indentation logic
const g:ruby#string = hlID("rubyString")
const g:ruby#symbol = hlID("rubySymbol")
const g:ruby#regex = hlID("rubyRegex")
const g:ruby#command = hlID("rubyCommand")
const g:ruby#comment = hlID("rubyComment")
const g:ruby#heredoc_line = hlID("rubyHeredocLine")
const g:ruby#heredoc_line_raw = hlID("rubyHeredocLineRaw")
const g:ruby#heredoc_delimiter = hlID("rubyHeredocDelimiter")

const g:ruby#multiline_regions = {}

for id in [g:ruby#string, g:ruby#symbol, g:ruby#regex, g:ruby#command, g:ruby#comment, g:ruby#heredoc_line, g:ruby#heredoc_line_raw, g:ruby#heredoc_delimiter]
  let g:ruby#multiline_regions[id] = 1
endfor

const g:ruby#keyword = hlID("rubyKeyword")
const g:ruby#operator = hlID("rubyOperator")
const g:ruby#delimiter = hlID("rubyDelimiter")
const g:ruby#comment_delimiter = hlID("rubyCommentDelimiter")
