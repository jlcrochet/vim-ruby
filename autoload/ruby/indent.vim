" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

" Caching important syntax ID's for use in indentation logic
let s:names = [
      \ "rubyString",
      \ "rubyStringEscape",
      \ "rubyStringInterpolationDelimiter",
      \ "rubyStringParenthesisEscape",
      \ "rubyStringSquareBracketEscape",
      \ "rubyStringCurlyBraceEscape",
      \ "rubyStringAngleBracketEscape",
      \ "rubyArrayEscape",
      \ "rubySymbol",
      \ "rubyRegex",
      \ "rubyRegexGroup",
      \ "rubyRegexComment",
      \ "rubyRegexEscape",
      \ "rubyCommand",
      \ "rubyHeredocLine",
      \ "rubyHeredocLineRaw",
      \ "rubyHeredocEnd"
      \ ]

let g:ruby#indent#multiline_regions = {}

for s:name in s:names
  let g:ruby#indent#multiline_regions[hlID(s:name)] = 1
endfor

lockvar g:ruby#indent#multiline_regions

unlet s:name s:names

const g:ruby#indent#keyword = hlID("rubyKeyword")
const g:ruby#indent#define = hlID("rubyDefine")
const g:ruby#indent#block_control = hlID("rubyBlockControl")
const g:ruby#indent#define_block_control = hlID("rubyDefineBlockControl")
const g:ruby#indent#operator = hlID("rubyOperator")
const g:ruby#indent#delimiter = hlID("rubyDelimiter")
const g:ruby#indent#comma = hlID("rubyComma")
const g:ruby#indent#backslash = hlID("rubyBackslash")
const g:ruby#indent#comment = hlID("rubyComment")
