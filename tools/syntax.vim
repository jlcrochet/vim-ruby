function s:choice(...)
  return '\%('..a:000->join('\|')..'\)'
endfunction

" Number patterns:
let s:exponent_suffix = '[eE][+-]\=\d\+\%(_\d\+\)*i\='
let s:fraction = '\.\d\+\%(_\d\+\)*'..s:choice(s:exponent_suffix, 'r\=i\=')

let s:nonzero_re = '[1-9]\d*\%(_\d\+\)*'..s:choice(
      \ s:exponent_suffix,
      \ s:fraction,
      \ 'ri\=',
      \ 'i'
      \ )..'\='

let s:zero_re = '0'..s:choice(
      \ s:exponent_suffix,
      \ s:fraction,
      \ 'ri\=',
      \ 'i',
      \ '\o\+\%(_\o\+\)*r\=i\=',
      \ '[bB][01]\+\%(_[01]\+\)*r\=i\=',
      \ '[oO]\o\+\%(_\o\+\)*r\=i\=',
      \ '[dD]\d\+\%(_\d\+\)*r\=i\=',
      \ '[xX]\x\+\%(_\x\+\)*r\=i\='
      \ )..'\='

" This pattern matches all operators that can be used as methods; these
" are also the only operators that can be referenced as symbols.
let s:overloadable_operators = s:choice(
      \ '[&|^/%]',
      \ '=\%(==\=\|\~\)',
      \ '>[=>]\=',
      \ '<\%(<\|=>\=\)\=',
      \ '[+\-~]@\=',
      \ '\*\*\=',
      \ '\[]=\=',
      \ '![@=~]\='
      \ )

" Onigmo groups and references are kinda complicated, so we're defining
" the patterns here:
let s:onigmo_escape = '\\'..s:choice(
      \ '\d\+',
      \ 'x\%(\x\x\|{\x\+}\)',
      \ 'u\x\x\x\x',
      \ 'c.',
      \ 'C-.',
      \ 'M-\%(\\\\C-.\|.\)',
      \ 'p{\^\=\h\w*}',
      \ 'P{\h\w*}',
      \ 'k'..s:choice('<\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\=>', '''\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\='''),
      \ 'g'..s:choice('<\%(\h\w*\|-\=\d\+\)>', '''\%(\h\w*\|-\=\d\+\)'''),
      \ '.'
      \ )

let s:onigmo_group_modifier = "?"..s:choice(
      \ '[imxdau]\+\%(-[imx]\+\)\=:\=',
      \ '[:=!>~]',
      \ '<[=!]',
      \ '<\h\w*>',
      \ "("..s:choice('\d\+', '<\h\w*>', '''\h\w*''')..")"
      \ )

let g:ruby_number_nonzero = printf('syn match rubyNumber /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:nonzero_re)
let g:ruby_number_zero = printf('syn match rubyNumber /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:zero_re)
let g:ruby_operator_method = printf('syn match rubyOperatorMethod /\%%#=1%s/ contained nextgroup=@rubyPostfix,@rubyArguments skipwhite', s:overloadable_operators)
let g:ruby_symbol = printf('syn match rubySymbol /\%%#=1%s/ contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite', s:overloadable_operators)
let g:ruby_method_definition = printf('syn match rubyMethodDefinition /\%%#=1%s/ contained nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey skipwhite', s:overloadable_operators)
let g:ruby_symbol_alias = printf('syn match rubySymbolAlias /\%%#=1%s/ contained', s:overloadable_operators)
let g:ruby_method_alias = printf('syn match rubyMethodAlias /\%%#=1%s/ contained', s:overloadable_operators)
let g:ruby_onigmo_escape = printf('syn match rubyOnigmoEscape /\%%#=1%s/ contained', s:onigmo_escape)
let g:ruby_onigmo_group = printf('syn match rubyOnigmoGroup matchgroup=rubyOnigmoMetaCharacter start=/\%%#=1(\%%(%s\)\=/ end=/\%%#=1)/ contained transparent', s:onigmo_group_modifier)

let g:rbs_method_name = printf('syn match rbsMethodName /\%%#=1\%%(\<self\>?\=\.\)\=%s/ contained nextgroup=rbsMethodDeclarationOperator skipwhite', s:overloadable_operators)
let g:rbs_attribute_name = printf('syn match rbsAttributeName /\%%#=1%s/ contained nextgroup=rbsAttributeDeclarationOperator skipwhite', s:overloadable_operators)
let g:rbs_method_alias_name = printf('syn match rbsMethodAliasName /\%%#=1\%%(\<self\>\.\)\=%s/ contained nextgroup=rbsMethodAliasName skipwhite', s:overloadable_operators)

delfunction s:choice
unlet s:exponent_suffix s:fraction s:nonzero_re s:zero_re s:overloadable_operators s:onigmo_escape s:onigmo_group_modifier
