" Vim syntax file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if has_key(b:, "current_syntax")
  finish
endif

let b:current_syntax = "ruby"

" Syntax {{{1
" This pattern matches all operators that can be used as methods; these
" are also the only operators that can be referenced as symbols.
let s:overloadable_operators = [
      \ '[&|^/%]',
      \ '=\%(==\=\|\~\)',
      \ '>[=>]\=',
      \ '<\%(<\|=>\=\)\=',
      \ '[+\-~]@\=',
      \ '\*\*\=',
      \ '\[]=\=',
      \ '![=~]'
      \ ]
let s:overloadable_operators = '\%('.join(s:overloadable_operators, '\|').'\)'

syn cluster rubyTop contains=TOP

" Comments {{{2
syn region rubyComment matchgroup=rubyCommentDelimiter start=/\%#=1#/ end=/\%#=1\_$/ oneline contains=rubyTodo
syn region rubyComment matchgroup=rubyCommentDelimiter start=/\%#=1\_^=begin\>/ end=/\%#=1\_^=end\>/ contains=rubyTodo
syn keyword rubyTodo TODO NOTE XXX FIXME HACK TBD contained

syn region rubyShebang start=/\%#=1\%^#!/ end=/\%#=1\_$/ oneline

" Operators {{{2
syn match rubyOperator /\%#=1=\%(==\=\|[>~]\)\=/ contained
syn match rubyOperator /\%#=1![=~]/ contained
syn match rubyOperator /\%#=1<\%(<=\=\|=>\=\)\=/ contained
syn match rubyOperator /\%#=1>>\==\=/ contained
syn match rubyOperator /\%#=1+=\=/ contained
syn match rubyOperator /\%#=1-=\=/ contained
syn match rubyOperator /\%#=1\*\*\==\=/ contained
syn match rubyOperator /\%#=1\// contained
" NOTE: The corresponding assignment operator for the above is defined
" below /-style regexes in order to take precedence
syn match rubyOperator /\%#=1%=\=/ contained
syn match rubyOperator /\%#=1?/ contained
syn match rubyOperator /\%#=1:/ contained
syn match rubyOperator /\%#=1&&\==\=/ contained
syn match rubyOperator /\%#=1||\==\=/ contained
syn match rubyOperator /\%#=1\^=\=/ contained

syn match rubyOperator /\%#=1&\=\./ nextgroup=rubyVariableOrMethod,rubyOperatorMethod skipwhite
execute 'syn match rubyOperatorMethod /\%#=1'.s:overloadable_operators.'/ contained nextgroup=rubyOperator,rubyRangeOperator,rubyString,rubySymbol,rubyRegex,rubyCommand,rubyHeredoc,rubyHashKey skipwhite'

syn match rubyRangeOperator /\%#=1\.\.\.\=/ nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyNamespaceOperator /\%#=1::/

" Delimiters {{{2
syn match rubyDelimiter /\%#=1(/ nextgroup=rubyHashKey skipwhite skipnl
syn match rubyDelimiter /\%#=1)/ nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyDelimiter /\%#=1\[/
syn match rubyDelimiter /\%#=1]/ nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyDelimiter /\%#=1{/ nextgroup=rubyHashKey,rubyBlockParameters skipwhite skipnl
syn match rubyDelimiter /\%#=1}/ nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyDelimiter /\%#=1,/ nextgroup=rubyHashKey skipwhite skipnl

syn match rubyDelimiter /\%#=1\\/

" Identifiers {{{2
syn match rubyInstanceVariable /\%#=1@\h\w*/ nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn match rubyClassVariable /\%#=1@@\h\w*/ nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn match rubyGlobalVariable /\%#=1\$\%(\h\w*\|[!@~&`'+=/\\,;.<>_*$?]\|-[ailp]\|0\|[1-9]\d*\)/ nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyConstant /\%#=1\u\w*/ nextgroup=rubyOperator,rubyRangeOperator,rubyNamespaceOperator skipwhite
syn match rubyVariableOrMethod /\%#=1[_[:lower:]]\w*[=?!]\=/ nextgroup=rubyOperator,rubyRangeOperator,rubyString,rubySymbol,rubyRegex,rubyCommand,rubyHeredoc,rubyHashKey skipwhite

syn match rubyHashKey /\%#=1\h\w*[?!]\=::\@!/he=e-1 contained

" Literals {{{2
syn keyword rubyNil nil nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn keyword rubyBoolean true false nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn keyword rubySelf self nextgroup=rubyOperator,rubyRangeOperator skipwhite

" Numbers {{{3
function s:or(...)
  return '\%('.join(a:000, '\|').'\)'
endfunction

function s:optional(re)
  return '\%('.a:re.'\)\='
endfunction

let s:exponent_suffix = '[eE][+-]\=\d\+\%(_\=\d\+\)*i\='
let s:fraction = '\.\d\+\%(_\d\+\)*' . s:or(s:exponent_suffix, 'r\=i\=')

let s:nonzero_re = '[1-9]\+\%(_\=\d\+\)*' . s:or(
      \ s:exponent_suffix,
      \ s:fraction,
      \ 'r\=i\=',
      \ )

let s:zero_re = '0' . s:or(
      \ s:fraction,
      \ '\o*\%(_\o\+\)*r\=i\=\>',
      \ '[bB][01]\+\%(_[01]\+\)*r\=i\=\>',
      \ '[oO]\o\+\%(_\o\+\)*r\=i\=\>',
      \ '[dD]\d\+\%(_\d\+\)*r\=i\=',
      \ '[xX]\x\+\%(_\x\+\)*r\=i\=',
      \ ) . '\='

let s:syn_match_template = 'syn match rubyNumber /\%%#=1%s/ nextgroup=rubyOperator,rubyRangeOperator skipwhite'

execute printf(s:syn_match_template, s:nonzero_re)
execute printf(s:syn_match_template, s:zero_re)

delfunction s:or
delfunction s:optional

unlet s:exponent_suffix s:fraction s:nonzero_re s:zero_re s:syn_match_template

" Strings {{{3
syn match rubyCharacter /\%#=1?\%(\\\%(\o\{1,3}\|x\x\x\=\|u\%(\x\{4}\|{\x\{1,6}}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\|\_.\)\|.\)/ contains=rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1"/ end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn match rubyStringEscape /\%#=1\\\%(\o\{1,3}\|x\x\x\=\|u\%(\x\{4}\|{\x\{1,6}\%(\s\x\{1,6}\)*}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\|\_.\)/ contained
syn region rubyStringInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#{/ end=/\%#=1}/ contained contains=@rubyTop,rubyNestedBraces
syn region rubyStringInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#\%(\$\|@@\=\)\@=/ end=/\%#=1\>/ oneline contained contains=rubyInstanceVariable,rubyClassVariable,rubyGlobalVariable

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringSquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\={/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1'/ end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn match rubyQuoteEscape /\%#=1\\[\\']/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q(/ end=/\%#=1)/ contains=rubyRawStringParentheses,rubyParenthesisEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRawStringParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained contains=rubyRawStringParentheses,rubyParenthesisEscape
syn match rubyParenthesisEscape /\%#=1\\[\\()]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q\[/ end=/\%#=1]/ contains=rubyRawStringSquareBrackets,rubySquareBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRawStringSquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained contains=rubyRawStringSquareBrackets,rubySquareBracketEscape
syn match rubySquareBracketEscape /\%#=1\\[\\[\]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q{/ end=/\%#=1}/ contains=rubyRawStringCurlyBraces,rubyCurlyBraceEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRawStringCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained contains=rubyRawStringCurlyBraces,rubyCurlyBraceEscape
syn match rubyCurlyBraceEscape /\%#=1\\[\\{}]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q</ end=/\%#=1>/ skip=/\%#=1<.\{-}>/ contains=rubyRawStringAngleBrackets,rubyAngleBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRawStringAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained contains=rubyRawStringAngleBrackets,rubyAngleBracketEscape
syn match rubyAngleBracketEscape /\%#=1\\[\\<>]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w(/ end=/\%#=1)/ contains=rubyStringArrayParentheses,rubyArrayParenthesisEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringArrayParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained contains=rubyStringArrayParentheses,rubyArrayParenthesisEscape
syn match rubyArrayParenthesisEscape /\%#=1\\[()[:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w\[/ end=/\%#=1]/ contains=rubyStringArraySquareBrackets,rubyArraySquareBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringArraySquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained contains=rubyStringArraySquareBrackets,rubyArraySquareBracketEscape
syn match rubyArraySquareBracketEscape /\%#=1\\[[\][:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w{/ end=/\%#=1}/ contains=rubyStringArrayCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringArrayCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained contains=rubyStringArrayCurlyBraces,rubyArrayCurlyBraceEscape
syn match rubyArrayCurlyBraceEscape /\%#=1\\[{}[:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w</ end=/\%#=1>/ contains=rubyStringArrayAngleBrackets,rubyArrayAngleBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyStringArrayAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained contains=rubyStringArrayAngleBrackets,rubyArrayAngleBracketEscape
syn match rubyArrayAngleBracketEscape /\%#=1\\[<>[:space:]]/ contained

" Here Documents {{{3
syn region rubyHeredoc matchgroup=rubyHeredocDelimiter start=/\%#=1<<[-~]\=\(`\=\)\z(\w\+\)\1/ end=/\%#=1\_^\s*\z1\>/ keepend transparent contains=@rubyTop,rubyHeredocLine nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyHeredocLine start=/\%#=1\_^/ end=/\%#=1\_$/ oneline contained contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyHeredocLine skipempty

syn region rubyHeredoc matchgroup=rubyHeredocDelimiter start=/\%#=1<<[-~]\='\z(\w\+\)'/ end=/\%#=1\_^\s*\z1\>/ keepend transparent contains=@rubyTop,rubyHeredocLineRaw nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyHeredocLineRaw start=/\%#=1\_^/ end=/\%#=1\_$/ oneline contained nextgroup=rubyHeredocLineRaw skipempty

" Symbols {{{3
syn match rubySymbol /\%#=1:\h\w*[=?!]\=/ contains=rubySymbolDelimiter nextgroup=rubyOperator,rubyRangeOperator skipwhite
execute 'syn match rubySymbol /\%#=1:'.s:overloadable_operators.'/ contains=rubySymbolDelimiter nextgroup=rubyOperator,rubyRangeOperator skipwhite'

syn match rubySymbolDelimiter /\%#=1:/ contained

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1:"/ end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1:'/ end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i(/  end=/\%#=1)/ contains=rubyStringArrayParentheses,rubyArrayParenthesisEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i\[/ end=/\%#=1]/ contains=rubyStringArraySquareBrackets,rubyArraySquareBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i{/  end=/\%#=1}/ contains=rubyStringArrayCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i</  end=/\%#=1>/ contains=rubyStringArrayAngleBrackets,rubyArrayAngleBracketEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

" Regular Expressions {{{3
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1\// end=/\%#=1\/[imx]*/ oneline contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite

" NOTE: This is defined here in order to take precedence over /-style
" regexes
syn match rubyOperator /\%#=1\/=/ contained

syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r(/  end=/\%#=1)/ skip=/\%#=1(.\{-})/  contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r\[/ end=/\%#=1]/ skip=/\%#=1\[.\{-}]/ contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r{/  end=/\%#=1}/ skip=/\%#=1{.\{-}}/  contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r</  end=/\%#=1>/ skip=/\%#=1<.\{-}>/  contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn match rubyRegexMetacharacter /\%#=1[.^$|]/ contained
syn match rubyRegexQuantifier /\%#=1[*+?]/ contained
syn match rubyRegexQuantifier /\%#=1{\d*,\=\d*}/ contained
syn region rubyRegexClass matchgroup=rubyRegexMetacharacter start=/\%#=1\[\^\=/ end=/\%#=1]/ oneline transparent contained contains=rubyRegexEscape,rubyRegexPOSIXClass
syn match rubyRegexPOSIXClass /\%#=1\[\^\=:\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|xdigit\):]/ contained
syn region rubyRegexGroup matchgroup=rubyRegexMetacharacter start=/\%#=1(\%(?\%([:>|=!]\|<\%([=!]\|\h\w*>\)\|[imx]\+\)\)\=/ end=/\%#=1)/ transparent oneline contained
syn region rubyRegexComment start=/\%#=1(#/ end=/\%#=1)/ oneline contained
syn match rubyRegexEscape /\%#=1\\[dDsSwWAZbBG]/ contained
syn region rubyRegexEscape matchgroup=rubyRegexMetacharacter start=/\%#=1\\Q/ end=/\%#=1\\E/ transparent contained contains=NONE
syn match rubyRegexCapturedGroup /\%#=1\\\%(\d\+\|g\%({\w\+}\|<\w\+>\)\)/ contained

syn cluster rubyRegexSpecial contains=
      \ rubyRegexMetacharacter,rubyRegexClass,rubyRegexGroup,rubyRegexComment,
      \ rubyRegexEscape,rubyRegexCapturedGroup,rubyRegexQuantifier

" Commands {{{3
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1`/ end=/\%#=1`/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%r|/  end=/\%#=1|/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite

" Additional % Literals {{{3
if get(g:, "ruby_extended_delimiters")
  let s:string_delimiters = {
        \ '\~': "Tilde",
        \ '`': "Grave",
        \ '!': "Bang",
        \ '@': "At",
        \ '#': "Hash",
        \ '\$': "Dollar",
        \ '%': "Percent",
        \ '\^': "Caret",
        \ '&': "Ampersand",
        \ '\*': "Asterisk",
        \ '_': "Underscore",
        \ '\-': "Dash",
        \ '+': "Plus",
        \ '=': "Equals",
        \ '|': "Bar",
        \ '\\': "Backslash",
        \ ':': "Colon",
        \ ';': "Semicolon",
        \ '"': "DoubleQuote",
        \ "'": "SingleQuote",
        \ ',': "Comma",
        \ '\.': "Period",
        \ '?': "QuestionMark",
        \ '\/': "Slash"
        \ }

  let s:string_template = 'syn region rubyString matchgroup=rubyStringDelimiter start=/\%%#=1%%Q\=%s/ end=/\%%#=1%s/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:raw_string_template = 'syn region rubyString matchgroup=rubyStringDelimiter start=/\%%#=1%%q%s/ end=/\%%#=1%s/ contains=ruby%sEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:string_array_template = 'syn region rubyString matchgroup=rubyStringDelimiter start=/\%%#=1%%w%s/ end=/\%%#=1%s/ contains=rubyArray%sEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:symbol_template = 'syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%%#=1%%s%s/ end=/\%%#=1%s/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:symbol_array_template = 'syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%%#=1%%i%s/ end=/\%%#=1%s/ contains=rubyArray%sEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:regex_template = 'syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%%#=1%%r%s/ end=/\%%#=1%s/ contains=rubyStringInterpolation,rubyStringEscape,@rubyRegexSpecial nextgroup=rubyOperator,rubyRangeOperator skipwhite'
  let s:command_template = 'syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%%#=1%%x%s/ end=/\%%#=1%s/ contains=rubyStringInterpolation,rubyStringEscape nextgroup=rubyOperator,rubyRangeOperator skipwhite'

  let s:escape_template = 'syn match ruby%sEscape /\%%#=1\\[\\%s]/ contained'
  let s:array_escape_template = 'syn match rubyArray%sEscape /\%%#=1\\[\\%s[:space:]]/ contained'

  for [s:delim, s:name] in items(s:string_delimiters)
    execute printf(s:string_template, s:delim, s:delim)
    execute printf(s:raw_string_template, s:delim, s:delim, s:name)
    execute printf(s:string_array_template, s:delim, s:delim, s:name)
    execute printf(s:symbol_template, s:delim, s:delim)
    execute printf(s:symbol_array_template, s:delim, s:delim, s:name)
    execute printf(s:regex_template, s:delim, s:delim)
    execute printf(s:command_template, s:delim, s:delim)

    execute printf(s:escape_template, s:name, s:delim)
    execute printf(s:array_escape_template, s:name, s:delim)

    execute 'hi def link ruby'.s:name.'Escape rubyStringEscape'
    execute 'hi def link rubyArray'.s:name.'Escape rubyStringEscape'
  endfor

  unlet
        \ s:string_delimiters s:delim s:name
        \ s:string_template s:raw_string_template s:string_array_template
        \ s:symbol_template s:symbol_array_template
        \ s:regex_template s:command_template
        \ s:escape_template s:array_escape_template
endif

" Definitions {{{2
syn keyword rubyKeyword def nextgroup=rubyMethodReceiver,rubyMethodDefinition skipwhite
syn match rubyMethodDefinition /\%#=1[[:lower:]_]\w*[=?!]\=/ contained
syn match rubyMethodReceiver /\%#=1\h\w*\./he=e-1 contained contains=rubyMethodReceiverConstant,rubyMethodReceiverSelf nextgroup=rubyMethodDefinition
syn match rubyMethodReceiverConstant /\%#=1\<\u\w*/ contained
syn keyword rubyMethodReceiverSelf self contained
execute 'syn match rubyMethodDefinition /\%#=1'.s:overloadable_operators.'/ contained'

syn keyword rubyKeyword class module nextgroup=rubyTypeDefinition skipwhite
syn match rubyTypeDefinition /\%#=1\u\w*\%(::\u\w*\)*/ contained contains=rubyNamespaceOperator

" Miscellaneous {{{2
syn keyword rubyKeyword
      \ BEGIN END and begin break case else elsif end ensure
      \ for if next not or redo rescue retry return then undef unless
      \ until when while yield attr attr_reader attr_writer
      \ attr_accessor using public private protected require

syn keyword rubyKeyword in nextgroup=rubyHashKey skipwhite

syn keyword rubyKeyword alias nextgroup=rubyAliasLine
syn region rubyAliasLine start=/\%#=1/ end=/\%#=1\_$/ oneline contained contains=rubySymbolAlias,rubyGlobalVariableAlias
syn match rubySymbolAlias /\%#=1:\h\w*[=?!]\=/ contained
syn match rubyGlobalVariableAlias /\%#=1\$\%(\h\w*\|[!@~&`'+=/\\,;.<>_*$?]\|-[ailp]\|0\|[1-9]\d*\)/ contained

syn keyword rubyKeyword do nextgroup=rubyBlockParameters skipwhite
syn region rubyBlockParameters matchgroup=rubyDelimiter start=/\%#=1|/ end=/\%#=1|/ transparent oneline contained

syn region rubyNestedBraces start=/\%#=1{/ matchgroup=rubyDelimiter end=/\%#=1}/ contained contains=@rubyTop,rubyNestedBraces
" }}}2

unlet s:overloadable_operators

" Synchronization {{{1
syn sync match rubySync grouphere rubyComment /\%#=1\_^=begin\>/

" Highlighting {{{1
hi def link rubyComment Comment
hi def link rubyCommentDelimiter rubyComment
hi def link rubyTodo Todo
hi def link rubyShebang Special
hi def link rubyOperator Operator
hi def link rubyRangeOperator rubyOperator
hi def link rubyNamespaceOperator rubyOperator
hi def link rubyDelimiter Delimiter
hi def link rubyInstanceVariable Identifier
hi def link rubyClassVariable Identifier
hi def link rubyGlobalVariable Identifier
hi def link rubyConstant Identifier
hi def link rubyNil Constant
hi def link rubyBoolean Boolean
hi def link rubySelf Constant
hi def link rubyNumber Number
hi def link rubyCharacter Character
hi def link rubyString String
hi def link rubyStringDelimiter rubyString
hi def link rubyStringEscape PreProc
hi def link rubyStringInterpolationDelimiter PreProc
hi def link rubyStringParenthesisEscape rubyStringEscape
hi def link rubyStringSquareBracketEscape rubyStringEscape
hi def link rubyStringCurlyBraceEscape rubyStringEscape
hi def link rubyStringAngleBracketEscape rubyStringEscape
hi def link rubyArrayParenthesisEscape rubyStringEscape
hi def link rubyArraySquareBracketEscape rubyStringEscape
hi def link rubyArrayCurlyBraceEscape rubyStringEscape
hi def link rubyArrayAngleBracketEscape rubyStringEscape
hi def link rubyHeredocLine String
hi def link rubyHeredocLineRaw rubyHeredocLine
hi def link rubyHeredocDelimiter rubyHeredocLine
hi def link rubySymbol String
hi def link rubySymbolDelimiter rubySymbol
hi def link rubyRegex String
hi def link rubyRegexDelimiter rubyRegex
hi def link rubyRegexMetacharacter SpecialChar
hi def link rubyRegexPOSIXClass rubyRegexMetacharacter
hi def link rubyRegexComment Comment
hi def link rubyRegexEscape PreProc
hi def link rubyRegexCapturedGroup rubyRegexMetacharacter
hi def link rubyRegexQuantifier rubyRegexMetacharacter
hi def link rubyCommand String
hi def link rubyCommandDelimiter rubyCommand
hi def link rubyKeyword Keyword
hi def link rubyMethodDefinition Typedef
hi def link rubyMethodReceiver rubyVariableOrMethod
hi def link rubyMethodReceiverConstant rubyConstant
hi def link rubyMethodReceiverSelf rubySelf
hi def link rubyTypeDefinition Typedef
hi def link rubySymbolAlias rubySymbol
hi def link rubyGlobalVariableAlias rubyGlobalVariable
" }}}1

" vim:fdm=marker
