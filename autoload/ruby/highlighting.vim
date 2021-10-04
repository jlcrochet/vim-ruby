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

let s:regions = {}

for s:name in s:names
  let s:regions[hlID(s:name)] = 1
endfor

const g:ruby#highlighting#multiline_regions = s:regions

const g:ruby#highlighting#keyword = hlID("rubyKeyword")
const g:ruby#highlighting#define = hlID("rubyDefine")
const g:ruby#highlighting#block_control = hlID("rubyBlockControl")
const g:ruby#highlighting#define_block_control = hlID("rubyDefineBlockControl")
const g:ruby#highlighting#operator = hlID("rubyOperator")
const g:ruby#highlighting#delimiter = hlID("rubyDelimiter")
const g:ruby#highlighting#comma = hlID("rubyComma")
const g:ruby#highlighting#backslash = hlID("rubyBackslash")
const g:ruby#highlighting#comment = hlID("rubyComment")
const g:ruby#highlighting#comment_delimiter = hlID("rubyCommentDelimiter")

unlet s:name s:names s:regions
