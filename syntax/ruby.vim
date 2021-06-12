" Vim syntax file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if exists("b:current_syntax")
  finish
endif

if get(g:, "ruby_fold")
  setlocal foldmethod=syntax
endif

" Syntax {{{1
syn iskeyword @,48-57,_,?,!

if get(b:, "is_eruby")
  syn cluster rubyTop contains=@ruby
else
  syn cluster rubyTop contains=TOP
endif

syn cluster rubyPostfix contains=rubyOperator,rubyRangeOperator,rubyPostfixKeyword,rubyComma
syn cluster rubyArguments contains=rubyNumber,rubyString,rubySymbol,rubyRegex,rubyCommand,rubyHeredoc,rubyHeredocSkip,rubyHashKey

" Comments {{{2
if get(b:, "is_eruby")
  syn region rubyComment matchgroup=rubyCommentDelimiter start=/\%#=1#/ end=/\%#=1\%($\|\ze-\=%>\)/ oneline contains=rubyTodo
else
  syn region rubyComment matchgroup=rubyCommentDelimiter start=/\%#=1#/ end=/\%#=1$/ oneline contains=rubyTodo
endif

syn region rubyComment matchgroup=rubyCommentDelimiter start=/\%#=1^=begin\>.*/ end=/\%#=1^=end\>.*/ contains=rubyTodo
syn keyword rubyTodo BUG DEPRECATED FIXME NOTE WARNING OPTIMIZE TODO XXX TBD contained

syn region rubyShebang start=/\%#=1\%^#!/ end=/\%#=1$/ oneline

" Operators {{{2
syn match rubyUnaryOperator /\%#=1[+*!~&^]/
syn match rubyUnaryOperator /\%#=1->\=/

syn match rubyOperator /\%#=1=\%(==\=\|[>~]\)\=/ contained
syn match rubyOperator /\%#=1![=~]/ contained
syn match rubyOperator /\%#=1<\%(<=\=\|=>\=\)\=/ contained
syn match rubyOperator /\%#=1>>\==\=/ contained
syn match rubyOperator /\%#=1+=\=/ contained
syn match rubyOperator /\%#=1-=\=/ contained
syn match rubyOperator /\%#=1\*\*\==\=/ contained
syn match rubyOperator /\%#=1[/?:]/ contained
syn match rubyOperator /\%#=1%=\=/ contained
syn match rubyOperator /\%#=1&&\==\=/ contained
syn match rubyOperator /\%#=1||\==\=/ contained
syn match rubyOperator /\%#=1\^=\=/ contained

syn match rubyOperator /\%#=1&\=\./ nextgroup=rubyVariableOrMethod,rubyOperatorMethod skipwhite
execute 'syn match rubyOperatorMethod /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained nextgroup=@rubyPostfix,@rubyArguments skipwhite'

syn match rubyRangeOperator /\%#=1\.\.\.\=/ nextgroup=rubyOperator,rubyPostfixKeyword skipwhite

syn match rubyNamespaceOperator /\%#=1::/ nextgroup=rubyConstant

" Delimiters {{{2
syn match rubyDelimiter /\%#=1(/ nextgroup=rubyHashKey skipwhite skipnl
syn match rubyDelimiter /\%#=1)/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1\[/
syn match rubyDelimiter /\%#=1]/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1{/ nextgroup=rubyHashKey,rubyBlockParameters skipwhite skipnl
syn match rubyDelimiter /\%#=1}/ nextgroup=@rubyPostfix skipwhite

syn match rubyComma /\%#=1,/ contained nextgroup=rubyHashKey skipwhite skipnl

syn match rubyBackslash /\%#=1\\/

" Identifiers {{{2
syn match rubyInstanceVariable /\%#=1@\h\w*/ nextgroup=@rubyPostfix skipwhite
syn match rubyClassVariable /\%#=1@@\h\w*/ nextgroup=@rubyPostfix skipwhite
syn match rubyGlobalVariable /\%#=1\$\%(\h\w*\|[!@~&`'+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)/ nextgroup=@rubyPostfix skipwhite

syn match rubyConstant /\%#=1\u\w*/ nextgroup=@rubyPostfix,rubyNamespaceOperator skipwhite
syn match rubyVariableOrMethod /\%#=1[[:lower:]_]\w*[=?!]\=/ nextgroup=@rubyPostfix,@rubyArguments skipwhite

syn match rubyHashKey /\%#=1\h\w*[?!]\=::\@!/ contained contains=rubySymbolDelimiter nextgroup=rubyComma skipwhite

" Literals {{{2
syn keyword rubyNil nil nextgroup=@rubyPostfix skipwhite
syn keyword rubyBoolean true false nextgroup=@rubyPostfix skipwhite
syn keyword rubySelf self nextgroup=@rubyPostfix skipwhite

" Numbers {{{3
execute g:ruby#syntax#numbers

" Strings {{{3
syn match rubyCharacter /\%#=1?\%(\\\%(\o\{1,3}\|x\x\{,2}\|u\%(\x\{,4}\|{\x\{1,6}}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\|\_.\)\|.\)/ contains=rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1"/ end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn match rubyStringInterpolation /\%#=1#@@\=\h\w*/ contained contains=rubyStringInterpolationDelimiter,rubyInstanceVariable,rubyClassVariable
syn match rubyStringInterpolation /\%#=1#\$\%(\h\w*\|[!@~&`'+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)/ contained contains=rubyStringInterpolationDelimiter,rubyGlobalVariable
syn match rubyStringInterpolationDelimiter /\%#=1#/ contained
syn region rubyStringInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#{/ end=/\%#=1}/ contained contains=@rubyTop,rubyNestedBraces
syn region rubyNestedBraces start=/\%#=1{/ matchgroup=rubyDelimiter end=/\%#=1}/ contained transparent nextgroup=@rubyPostfix skipwhite

syn match rubyStringEscape /\%#=1\\\_./ contained
syn match rubyStringEscapeError /\%#=1\\\%(x\|u\x\{,3}\)/ contained
syn match rubyStringEscape /\%#=1\\\%(\o\{1,3}\|x\x\x\=\|u\%(\x\{4}\|{\s*\x\{1,6}\%(\s\+\x\{1,6}\)*\s*}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\)/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1'/ end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix skipwhite
syn match rubyQuoteEscape /\%#=1\\[\\']/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringSquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\={/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn match rubyParenthesisEscape /\%#=1\\[\\()]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubySquareBracketEscape /\%#=1\\[\\\[\]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q{/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn match rubyCurlyBraceEscape /\%#=1\\[\\{}]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyAngleBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyAngleBracketEscape /\%#=1\\[\\<>]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayParenthesisEscape /\%#=1\\[()[:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArraySquareBracketEscape /\%#=1\\[\[\][:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w{/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayCurlyBraceEscape /\%#=1\\[{}[:space:]]/ contained

syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayAngleBracketEscape /\%#=1\\[<>[:space:]]/ contained

" Symbols {{{3
syn match rubySymbol /\%#=1:\h\w*[=?!]\=/ contains=rubySymbolDelimiter nextgroup=@rubyPostfix skipwhite
execute 'syn match rubySymbol /\%#=1:'.g:ruby#syntax#overloadable_operators.'/ contains=rubySymbolDelimiter nextgroup=@rubyPostfix skipwhite'

syn match rubySymbolDelimiter /\%#=1:/ contained

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1:"/ end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1:'/ end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix skipwhite

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite

" Regular Expressions {{{3
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1\/\s\@!/ end=/\%#=1\/[imx]*/ skip=/\%#=1\\\\\|\\\// oneline keepend contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite

" NOTE: This is defined here in order to take precedence over /-style
" regexes
syn match rubyOperator /\%#=1\/=/ contained

syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r(/  end=/\%#=1)/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r\[/ end=/\%#=1]/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r{/  end=/\%#=1}/ skip=/\%#=1{.\{-}}/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r</  end=/\%#=1>/ skip=/\%#=1<.\{-}>/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite

syn cluster rubyRegexSpecial contains=
      \ rubyRegexMetacharacter,rubyRegexClass,rubyRegexGroup,rubyRegexComment,
      \ rubyRegexEscape,rubyRegexCapturedGroup,rubyRegexQuantifier

syn match rubyRegexMetacharacter /\%#=1[.^$|]/ contained
syn match rubyRegexQuantifier /\%#=1[*+?]/ contained
syn match rubyRegexQuantifier /\%#=1{\d*,\=\d*}/ contained
syn region rubyRegexClass matchgroup=rubyRegexMetacharacter start=/\%#=1\[\^\=/ end=/\%#=1]/ oneline transparent contained contains=rubyRegexEscape,rubyRegexPOSIXClass
syn match rubyRegexPOSIXClass /\%#=1\[\^\=:\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|xdigit\):]/ contained
syn region rubyRegexGroup matchgroup=rubyRegexMetacharacter start=/\%#=1(\%(?\%([:>|=!]\|<\%([=!]\|\h\w*>\)\|[imx]\+\)\)\=/ end=/\%#=1)/ transparent contained
syn region rubyRegexComment start=/\%#=1(#/ end=/\%#=1)/ contained
syn match rubyRegexEscape /\%#=1\\[pP]{\h\w*}/ contained
syn match rubyRegexCapturedGroup /\%#=1\\\%(\d\+\|g\%({\w\+}\|<\w\+>\)\)/ contained

" Commands {{{3
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1`/ end=/\%#=1`/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

" Additional % Literals {{{3
syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%Q\=\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%q\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ nextgroup=@rubyPostfix skipwhite
syn region rubyString matchgroup=rubyStringDelimiter start=/\%#=1%w\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%s\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolDelimiter start=/\%#=1%i\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexDelimiter start=/\%#=1%r\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1[imx]*/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandDelimiter start=/\%#=1%x\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn match rubyArrayEscape /\%#=1\\\s/ contained

" Here Documents {{{3
syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\(`\=\)\z(\w\+\)\1/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ transparent contains=rubyHeredocStartLine,rubyHeredocLine
syn region rubyHeredocStartLine start=/\%#=1/ end=/\%#=1$/ contained oneline transparent keepend contains=TOP nextgroup=rubyHeredocLine skipnl
syn region rubyHeredocLine start=/\%#=1^/ end=/\%#=1$/ contained oneline contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=rubyHeredocLine skipnl

syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\='\z(\w\+\)'/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ transparent contains=rubyHeredocStartLineRaw,rubyHeredocLineRaw
syn region rubyHeredocStartLineRaw start=/\%#=1/ end=/\%#=1$/ contained oneline transparent keepend contains=TOP nextgroup=rubyHeredocLineRaw skipnl
syn region rubyHeredocLineRaw start=/\%#=1^/ end=/\%#=1$/ contained oneline nextgroup=rubyHeredocLineRaw skipnl

syn region rubyHeredocSkip matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\([`']\=\)\w\+\1/ end=/\%#=1\ze<<[-~]\=[`']\=\w/ transparent oneline nextgroup=rubyHeredoc,rubyHeredocSkip

" Blocks {{{2
if get(g:, "ruby_simple_indent") || get(b:, "is_eruby")
  syn keyword rubyKeyword if unless case while until for begin else ensure
  syn keyword rubyKeyword rescue nextgroup=rubyConstant,rubyOperator skipwhite
  syn keyword rubyKeyword end nextgroup=@rubyPostfix skipwhite
  syn keyword rubyKeyword do nextgroup=rubyBlockParameters skipwhite

  syn keyword rubyKeyword def nextgroup=rubyMethodDefinition,rubyMethodReceiver,rubyMethodSelf,rubyMethodColon skipwhite
  syn keyword rubyKeyword class module nextgroup=rubyTypeDefinition skipwhite

  syn keyword rubyKeyword public private protected nextgroup=rubySymbol skipwhite
else
  " NOTE: When definition blocks are highlighted, the following keywords
  " have to be matched with :syn-match instead of :syn-keyword to
  " prevent the block regions from being clobbered.

  syn region rubyBlock matchgroup=rubyKeyword start=/\%#=1\<\%(if\|unless\|case\|begin\|while\|until\|for\)\>/ end=/\%#=1\<\.\@1<!end:\@!\>/ contains=@rubyTop,rubyBlockControl nextgroup=@rubyPostfix skipwhite
  syn keyword rubyBlockControl else ensure contained
  syn keyword rubyBlockControl rescue nextgroup=rubyConstant,rubyOperator skipwhite

  syn region rubyBlockSkip matchgroup=rubyKeyword start=/\%#=1\<\%(while\|until\|for\)\>/ end=/\%#=1\ze\<\.\@1<!do:\@!\>/ transparent oneline nextgroup=rubyBlock

  syn match rubyKeyword /\%#=1\<do\>/ nextgroup=rubyBlockParameters skipwhite contained containedin=rubyBlock
  syn region rubyBlock start=/\%#=1\<do\>/ matchgroup=rubyKeyword end=/\%#=1\<\.\@1<!end:\@!\>/ contains=@rubyTop,rubyBlockControl nextgroup=@rubyPostfix skipwhite

  syn match rubyDefine /\%#=1\<def\>/ nextgroup=rubyMethodDefinition,rubyMethodReceiver,rubyMethodSelf,rubyMethodColon skipwhite
  syn match rubyDefine /\%#=1\<\%(class\|module\)\>/ nextgroup=rubyTypeDefinition skipwhite contained containedin=rubyDefineBlock

  syn region rubyDefineBlock start=/\%#=1\<\%(def:\@!\|class\|module\)\>/ matchgroup=rubyDefine end=/\%#=1\<\.\@1<!end:\@!\>/ contains=@rubyTop,rubyDefineBlockControl fold
  syn keyword rubyDefineBlockControl else ensure contained
  syn keyword rubyDefineBlockControl rescue contained nextgroup=rubyConstant,rubyOperator skipwhite

  syn keyword rubyDefine public private protected nextgroup=rubyDefineBlock,rubySymbol skipwhite
endif

syn match rubyTypeDefinition /\%#=1\u\w*/ contained nextgroup=rubyTypeNamespace,rubyInheritanceOperator skipwhite
syn match rubyTypeNamespace /\%#=1::/ contained nextgroup=rubyTypeDefinition
syn match rubyInheritanceOperator /\%#=1</ contained nextgroup=rubyConstant skipwhite

syn match rubyMethodDefinition /\%#=1[[:lower:]_]\w*[=?!]\=/ contained nextgroup=rubyMethodAssignmentOperator,rubyHashKey skipwhite
execute 'syn match rubyMethodDefinition /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained nextgroup=rubyMethodAssignmentOperator,rubyHashKey skipwhite'
syn match rubyMethodReceiver /\%#=1\h\w*\./ contained contains=rubyMethodReceiverVariable,rubyMethodReceiverConstant,rubyMethodReceiverSelf,rubyMethodReceiverDot nextgroup=rubyMethodDefinition
syn match rubyMethodReceiverVariable /\%#=1[[:lower:]_]\w*/ contained
syn match rubyMethodReceiverConstant /\%#=1\u\w*/ contained
syn keyword rubyMethodReceiverSelf self contained
syn match rubyMethodReceiverDot /\%#=1\./ contained
syn match rubyMethodColon /\%#=1:/ contained nextgroup=rubyMethodDefinition skipwhite skipnl
syn match rubyMethodAssignmentOperator /\%#=1=/ contained

" Miscellaneous {{{2
syn keyword rubyKeyword and or not then elsif when undef
syn keyword rubyKeyword include extend nextgroup=rubyConstant skipwhite
syn keyword rubyKeyword return next break yield redo retry nextgroup=rubyPostfixKeyword skipwhite

syn keyword rubyKeyword alias nextgroup=rubyAlias
syn region rubyAlias start=/\%#=1/ end=/\%#=1$/ contained oneline contains=rubySymbolAlias,rubyGlobalVariableAlias,rubyMethodAlias
syn match rubySymbolAlias /\%#=1:[[:lower:]_]\w*[=?!]\=/ contained
execute 'syn match rubySymbolAlias /\%#=1:'.g:ruby#syntax#overloadable_operators.'/ contained'
syn match rubyGlobalVariableAlias /\%#=1\$\%(\h\w*\|-\w\)/ contained
syn match rubyMethodAlias /\%#=1[[:lower:]_]\w*[=?!]\=/ contained
execute 'syn match rubyMethodAlias /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained'

syn keyword rubyPostfixKeyword if unless while until rescue in contained

syn keyword rubyKeyword require require_relative nextgroup=rubyString skipwhite
syn keyword rubyKeyword in nextgroup=rubyHashKey skipwhite

syn keyword rubyKeyword BEGIN END

syn region rubyBlockParameters matchgroup=rubyDelimiter start=/\%#=1|/ end=/\%#=1|/ transparent oneline contained
" }}}2

" Synchronization {{{1
syn sync fromstart

" Highlighting {{{1
hi def link rubyComment Comment
hi def link rubyCommentDelimiter rubyComment
hi def link rubyTodo Todo
hi def link rubyShebang Special
hi def link rubyOperator Operator
hi def link rubyUnaryOperator rubyOperator
hi def link rubyRangeOperator rubyOperator
hi def link rubyDelimiter Delimiter
hi def link rubyInstanceVariable Identifier
hi def link rubyClassVariable Identifier
hi def link rubyGlobalVariable Identifier
hi def link rubyConstant Identifier
hi def link rubyHashKey rubySymbol
hi def link rubyNil Constant
hi def link rubyBoolean Boolean
hi def link rubySelf Constant
hi def link rubyNumber Number
hi def link rubyCharacter Character
hi def link rubyString String
hi def link rubyStringDelimiter rubyString
hi def link rubyStringEscape SpecialChar
hi def link rubyStringEscapeError Error
hi def link rubyQuoteEscape rubyStringEscape
hi def link rubyStringInterpolationDelimiter PreProc
hi def link rubyStringParenthesisEscape rubyStringEscape
hi def link rubyStringSquareBracketEscape rubyStringEscape
hi def link rubyStringCurlyBraceEscape rubyStringEscape
hi def link rubyStringAngleBracketEscape rubyStringEscape
hi def link rubyArrayEscape rubyStringEscape
hi def link rubyArrayParenthesisEscape rubyStringEscape
hi def link rubyArraySquareBracketEscape rubyStringEscape
hi def link rubyArrayCurlyBraceEscape rubyStringEscape
hi def link rubyArrayAngleBracketEscape rubyStringEscape
hi def link rubyHeredocLine String
hi def link rubyHeredocLineRaw rubyHeredocLine
hi def link rubyHeredocStart rubyHeredocLine
hi def link rubyHeredocEnd rubyHeredocStart
hi def link rubySymbol String
hi def link rubySymbolDelimiter rubySymbol
hi def link rubyRegex String
hi def link rubyRegexDelimiter rubyRegex
hi def link rubyRegexMetacharacter SpecialChar
hi def link rubyRegexPOSIXClass rubyRegexMetacharacter
hi def link rubyRegexComment Comment
hi def link rubyRegexEscape rubyRegexMetacharacter
hi def link rubyRegexCapturedGroup rubyRegexMetacharacter
hi def link rubyRegexQuantifier rubyRegexMetacharacter
hi def link rubyCommand String
hi def link rubyCommandDelimiter rubyCommand
hi def link rubyKeyword Keyword
hi def link rubyDefine Define
hi def link rubyBlockControl rubyKeyword
hi def link rubyDefineBlockControl rubyDefine
hi def link rubyMethodDefinition Typedef
hi def link rubyMethodReceiverConstant rubyConstant
hi def link rubyMethodReceiverSelf rubySelf
hi def link rubyMethodReceiverDot rubyOperator
hi def link rubyMethodColon rubyOperator
hi def link rubyMethodAssignmentOperator rubyOperator
hi def link rubyTypeDefinition Typedef
hi def link rubyTypeNamespace rubyOperator
hi def link rubySymbolAlias rubySymbol
hi def link rubyGlobalVariableAlias rubyGlobalVariable
hi def link rubyMethodAlias rubyMethodDefinition
" }}}1

let b:current_syntax = "ruby"

" vim:fdm=marker
