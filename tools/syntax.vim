function s:choice(...)
  return '\%('..a:000->join('\|')..'\)'
endfunction

" alphanumeric + underscore + non-7-bit:
let s:word_character = '[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]'
" letters + underscore + non-7-bit:
let s:head_character = '[^\x00-\x40\x5B-\x5E`\x7B-\x7F]'
" lowercase + underscore + non-7-bit:
let s:variable_start = '[^\x00-\x5E`\x7B-\x7F]'

" Identifiers:
let s:identifier = s:head_character .. s:word_character .. '*'

let s:variable = s:variable_start .. s:word_character .. '*'
let s:variable_or_method = s:variable .. '[?!]\='
let s:method_definition = s:variable .. '[?!=]\='
let s:constant = '\u' .. s:word_character .. '*'
let s:instance_variable = '@@\=' .. s:identifier
let s:global_variable = '\$' .. s:choice(
      \ s:identifier,
      \ '[!@~&`''"+=/\\,;:.<>_*$?]',
      \ '-\w',
      \ '0',
      \ '[1-9]\d*'
      \ )
let s:hash_key = s:identifier .. '[?!]\=::\@!'
let s:symbol = s:identifier .. '[?!=]\='

" Number patterns:
let s:exponent_suffix = '[eE][+-]\=\d\+\%(_\d\+\)*i\='
let s:fraction = '\.\d\+\%(_\d\+\)*'..s:choice(s:exponent_suffix, 'ri\=', 'i')..'\='

let s:nonzero_re = '[1-9]\d*\%(_\d\+\)*'..s:choice(
      \ s:exponent_suffix,
      \ s:fraction,
      \ 'ri\=',
      \ 'i'
      \ )..'\=\>'

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
      \ )..'\=\>'

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
      \ 'p{\^\=\u\a*}',
      \ 'P{\u\a*}',
      \ 'k'..s:choice(
      \   '<'..s:choice(s:identifier, '-\=\d\+')..'\%([+-]\d\+\)\='..'>',
      \   "'"..s:choice(s:identifier, '-\=\d\+')..'\%([+-]\d\+\)\='.."'"
      \ ),
      \ 'g'..s:choice(
      \   '<'..s:choice(s:identifier, '[+-]\=\d\+')..'>',
      \   "'"..s:choice(s:identifier, '[+-]\=\d\+').."'"
      \ ),
      \ '.'
      \ )

let s:onigmo_group_modifier = "?"..s:choice(
      \ '[imxdau]\+\%(-[imx]\+\)\=:\=',
      \ '[:=!>~]',
      \ '<[=!]',
      \ '<'..s:identifier..'>',
      \ "("..s:choice('\d\+', '<'..s:identifier..'>', "'"..s:identifier.."'")..")"
      \ )

let g:ruby_number_nonzero = printf('syn match rubyNumber /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:nonzero_re)
let g:ruby_number_zero = printf('syn match rubyNumber /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:zero_re)
let g:ruby_operator_method = printf('syn match rubyOperatorMethod /\%%#=1%s/ contained nextgroup=@rubyPostfix,@rubyArguments skipwhite', s:overloadable_operators)
let g:ruby_symbol = printf('syn match rubySymbol /\%%#=1:\%%(%s\|%s\)/ contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite', s:symbol, s:overloadable_operators)
let g:ruby_method_definition = printf('syn match rubyMethodDefinition /\%%#=1\%%(\%%(%s\|%s\)\.\)\=\%%(%s\|%s\)/ contained contains=@rubyMethodReceivers nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey skipwhite', s:constant, s:variable, s:method_definition, s:overloadable_operators)
let g:ruby_type_definition = printf('syn match rubyTypeDefinition /\%%#=1%s/ contained nextgroup=rubyTypeNamespace,rubyInheritanceOperator skipwhite', s:constant)
let g:ruby_symbol_alias = printf('syn match rubySymbolAlias /\%%#=1:\%%(%s\|%s\)/ contained contains=rubySymbolStart nextgroup=@rubyAliases skipwhite', s:symbol, s:overloadable_operators)
let g:ruby_global_variable_alias = printf('syn match rubyGlobalVariableAlias /\%%#=1\$\%%(%s\|-\w\)/ contained nextgroup=@rubyAliases skipwhite', s:identifier)
let g:ruby_method_alias = printf('syn match rubyMethodAlias /\%%#=1\%%(%s\|%s\)/ contained nextgroup=@rubyAliases skipwhite', s:method_definition, s:overloadable_operators)
let g:ruby_onigmo_escape = printf('syn match rubyOnigmoEscape /\%%#=1%s/ contained', s:onigmo_escape)
let g:ruby_onigmo_group = printf('syn region rubyOnigmoGroup matchgroup=rubyOnigmoMetaCharacter start=/\%%#=1(\%%(%s\)\=/ end=/\%%#=1)/ contained transparent', s:onigmo_group_modifier)
let g:ruby_variable_or_method = printf('syn match rubyVariableOrMethod /\%%#=1%s/ nextgroup=@rubyPostfix,@rubyArguments skipwhite', s:variable_or_method)
let g:ruby_constant = printf('syn match rubyConstant /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:constant)
let g:ruby_instance_variable = printf('syn match rubyInstanceVariable /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:instance_variable)
let g:ruby_global_variable = printf('syn match rubyGlobalVariable /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite', s:global_variable)
let g:ruby_hash_key = printf('syn match rubyHashKey /\%%#=1%s/ contained contains=rubySymbolStart nextgroup=rubyComma skipwhite', s:hash_key)
let g:ruby_string_interpolation = printf('syn match rubyStringInterpolation /\%%#=1#\%%(%s\|%s\)/ contained contains=rubyStringInterpolationDelimiter,rubyInstanceVariable,rubyGlobalVariable', s:instance_variable, s:global_variable)
let g:ruby_heredoc = printf('syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%%#=1<<[-~]\=\z(%s\+\)/ matchgroup=rubyHeredocEnd end=/\%%#=1^\s*\z1$/ contains=rubyHeredocStartLine,rubyHeredocLine', s:word_character)
let g:ruby_heredoc_skip = printf('syn region rubyHeredocSkip matchgroup=rubyHeredocStart start=/\%%#=1<<[-~]\=\%%(\(["`'']\).\{-}\1\|%s\+\)/ end=/\%%#=1\ze<<[-~]\=[^\x00-\x21\x23-\x26\x28-\x40\x5B-\x5E\x7B-\x7F]/ contains=@rubyPostfix,@rubyArguments oneline nextgroup=rubyHeredoc,rubyHeredocSkip', s:word_character)
let g:ruby_define_line = printf('syn region rubyDefineLine matchgroup=rubyDefineNoBlock start=/\%%#=1\<def\>/ matchgroup=rubyMethodAssignmentOperator end=/\%%#=1=/ skip=/\%%#=1\%%((.*)\|=\%%([>~]\|==\=\)\|!=\|\[\]=\|%s=\=\)/ oneline contains=rubyMethodDefinition', s:variable)
let g:ruby_method_receiver_variable = printf('syn match rubyMethodReceiverVariable /\%%#=1%s\.\@=/ contained nextgroup=rubyMethodReceiverDot', s:variable)
let g:ruby_method_receiver_constant = printf('syn match rubyMethodReceiverConstant /\%%#=1%s\.\@=/ contained nextgroup=rubyMethodReceiverDot', s:constant)

let g:rbs_class_name = printf('syn match rbsClassName ')
