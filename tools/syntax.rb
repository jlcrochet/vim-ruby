def choice(*xs)
  '\%(' + xs.join('\|') + '\)'
end

# Number patterns:
exponent_suffix = '[eE][+-]\=\d\+\%(_\d\+\)*i\='
fraction = '\.\d\+\%(_\d\+\)*' + choice(exponent_suffix, 'r\=i\=')

nonzero_re = '[1-9]\d*\%(_\d\+\)*' + choice(
  exponent_suffix,
  fraction,
  'ri\=',
  'i'
) + '\='

zero_re = '0' + choice(
  exponent_suffix,
  fraction,
  'ri\=',
  'i',
  '\o\+\%(_\o\+\)*r\=i\=',
  '[bB][01]\+\%(_[01]\+\)*r\=i\=',
  '[oO]\o\+\%(_\o\+\)*r\=i\=',
  '[dD]\d\+\%(_\d\+\)*r\=i\=',
  '[xX]\x\+\%(_\x\+\)*r\=i\='
) + '\='

# This pattern matches all operators that can be used as methods; these
# are also the only operators that can be referenced as symbols.
overloadable_operators = choice(
  '[&|^/%]',
  '=\%(==\=\|\~\)',
  '>[=>]\=',
  '<\%(<\|=>\=\)\=',
  '[+\-~]@\=',
  '\*\*\=',
  '\[]=\=',
  '![@=~]\='
)

# Onigmo groups and reerences are kinda complicated, so we're defining
# the patterns here:
onigmo_escape = "\\\\" + choice(
  '\d\+',
  'x\%(\x\x\|{\x\+}\)',
  'u\x\x\x\x',
  'c.',
  'C-.',
  'M-\%(\\\\C-.\|.\)',
  'p{\^\=\h\w*}',
  'P{\h\w*}',
  'k' + choice('<\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\=>', '\'\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\=\''),
  'g' + choice('<\%(\h\w*\|-\=\d\+\)>', '\'\%(\h\w*\|-\=\d\+\)\''),
  '.'
)

onigmo_group_modifier = "?" + choice(
  '[imxdau]\+\%(-[imx]\+\)\=:\=',
  '[:=!>~]',
  '<[=!]',
  '<\h\w*>',
  "(" + choice('\d\+', '<\h\w*>', '\'\h\w*\'') + ")"
)

puts <<EOF
syn match rubyNumber /\\%#=1#{nonzero_re}/ nextgroup=@rubyPostfix skipwhite
syn match rubyNumber /\\%#=1#{zero_re}/ nextgroup=@rubyPostfix skipwhite
syn match rubyOperatorMethod /\\%#=1#{overloadable_operators}/ contained nextgroup=@rubyPostfix,@rubyArguments skipwhite
syn match rubySymbol /\\%#=1#{overloadable_operators} contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite
syn match rubyMethodDefinition /\\%#=1#{overloadable_operators}/ contained nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey skipwhite
syn match rubySymbolAlias /\\%#=1#{overloadable_operators} contained
syn match rubyMethodAlias /\\%#=1#{overloadable_operators} contained
syn match rubyOnigmoEscape /\\%#=1#{onigmo_escape}/ contained
syn match rubyOnigmoGroup matchgroup=rubyOnigmoMetaCharacter start=/\\%#=1(\\%(#{onigmo_group_modifier}\\)\\=/ end=/\\%#=1)/ contained transparent

syn match rbsMethodName /\\%#=1\\%(\\<self\\>?\\=\\.\\)\\=#{overloadable_operators}/ contained nextgroup=rbsMethodDeclarationOperator skipwhite
syn match rbsAttributeName /\\%#=1#{overloadable_operators}/ contained nextgroup=rbsAttributeDeclarationOperator skipwhite
syn match rbsMethodAliasName /\\%#=1\\%(\\<self\\>\\.\\)\\=#{overloadable_operators}/ contained nextgroup=rbsMethodAliasName skipwhite
EOF
