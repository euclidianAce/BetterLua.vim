

syn cluster tealBase contains=
	\ tealComment,tealLongComment,
	\ tealConstant,tealNumber,tealString,tealLongString,
	\ tealBuiltin
syn cluster tealExpression contains=
	\ @tealBase,tealParen,tealBracket,tealBrace,
	\ tealOperator,tealFunctionBlock,tealFunctionCall,tealError,
	\ tealTableConstructor,tealRecordBlock,tealEnumBlock
syn cluster tealStatement contains=
	\ @tealExpression,tealIfThen,tealBlock,tealLoop,
	\ tealRepeatBlock,tealWhileDo,tealForDo,
	\ tealGoto,tealLabel

" {{{ Types
syn match tealUnion /|/ contained
	\ nextgroup=@tealSingleType
	\ skipwhite skipempty
syn match tealBasicType /\K\k*\(\.\K\k*\)*/ contained
	\ nextgroup=tealUnion
	\ skipwhite skipempty
hi! link tealBasicType Type
syn match tealFunctionType /\<function\>/ contained
	\ nextgroup=tealFunctionTypeArgs,tealUnion
	\ skipwhite skipempty
syn region tealFunctionTypeArgs contained transparent
	\ matchgroup=Error
	\ start=/(/ end=/)/
	\ contains=@tealSingleType
	\ nextgroup=tealParenTypesAnnotation
	\ skipwhite skipempty
syn match tealParenTypesAnnotation /:/ contained
	\ nextgroup=tealParenTypes
	\ skipwhite skipempty
hi! def link tealParenTypesAnnotation DraculaGreenItalic
syn region tealParenTypes contained transparent
	\ matchgroup=tealParen
	\ start=/(/ end=/)/
	\ contains=@tealSingleType
	\ nextgroup=tealUnion
	\ skipwhite skipempty
syn region tealTableType start=/{/ end=/}/ contained
	\ nextgroup=tealUnion
	\ skipwhite skipempty
	\ contains=@tealSingleType
syn cluster tealSingleType contains=
	\ tealBasicType,
	\ tealFunctionType,
	\ tealFunctionTypeArgs,
	\ tealParenTypesAnnotation,
	\ tealParenTypes,
	\ tealTableType
hi! def link tealParens DraculaYellowItalic
" }}}
" {{{ Comments
syn match tealComment "\%^#!"
syn match tealComment /--.*$/ contains=tealTodo,@Spell
syn keyword tealComment contained TODO FIXME XXX
syn region tealLongComment start=/--\[\z(=*\)\[/ end=/\]\z1\]/

hi def link tealComment Comment
hi def link tealLongComment Comment
" }}}
" {{{ function ... end
syn region tealFunctionBlock
	\ matchgroup=tealKeyword
	\ start=/\<function\>/ end=/\<end\>/
	\ contains=@tealStatement,tealFunctionArgs,
	\ tealFunctionName
syn match tealFunctionName contained /\(\<function\>\)\@<=\s\+\K\k*\(\.\K\k*\)*\(:\K\k*\)\?\s*\((\|<\)\@=/
	\ nextgroup=tealFunctionGeneric,tealFunctionArgs
	\ skipwhite skipempty skipnl
syn region tealFunctionGeneric contained transparent
	\ start=/</ end=/>/
	\ contains=tealBasicType
	\ nextgroup=tealFunctionArgs
	\ skipwhite skipempty skipnl
syn region tealFunctionArgs contained transparent
	\ matchgroup=tealParens
	\ start=/(/ end=/)/
	\ contains=@tealBase,tealFunctionArgName,
	\ tealFunctionArgTypeAnnotation,@tealSingleType
	\ nextgroup=tealFunctionReturnTypeAnnotation
syn match tealFunctionArgName contained /\K\k*/
	\ nextgroup=tealFunctionArgTypeAnnotation,tealFunctionArgComma
	\ skipwhite skipempty skipnl
syn match tealFunctionArgTypeAnnotation contained /:/
	\ nextgroup=@tealSingleType
	\ skipwhite skipempty skipnl
syn match tealFunctionArgComma contained /,/
	\ nextgroup=tealFunctionArgName
	\ skipwhite skipempty skipnl
syn match tealFunctionReturnTypeAnnotation /:/ contained
	\ nextgroup=@tealSingleType
	\ skipwhite skipempty skipnl

" TODO: support functions with multiple returns without using parens


hi! link tealFunctionReturnTypeAnnotation DraculaPinkItalic
hi! link tealFunctionName DraculaGreen
hi! link tealFunctionArgName DraculaOrange
hi! link tealFunctionArgTypeAnnotation DraculaRed

" }}}
" {{{ record ... end
syn region tealRecordBlock
	\ matchgroup=tealRecord transparent
 	\ start=/\<record\>/ end=/\<end\>/
	\ contains=tealRecordItem,tealRecordTypeAnnotation,tealRecordAssign
syn match tealRecordItem /\K\k\*/ contained
	\ nextgroup=tealRecordTypeAnnotation,tealRecordAssign
	\ skipwhite skipnl skipempty
syn match tealRecordTypeAnnotation /:/
	\ nextgroup=@tealSingleType
	\ skipwhite skipnl skipempty
syn match tealRecordAssign /=/ contained
	\ nextgroup=tealRecordBlock
	\ skipwhite skipnl skipempty
hi! link tealRecord DraculaGreen
" }}}
" {{{ enum ... end
syn region tealEnumBlock
	\ matchgroup=tealEnum transparent
	\ start="\<enum\>" end="\<end\>"
	\ contains=tealString
hi! link tealEnum DraculaYellowItalic
" }}}
" {{{ if ... then, elseif ... then, then ... end, else
syn region tealIfThen
	\ transparent matchgroup=tealIfStatement
	\ start=/\<if\>/ end=/\<then\>/me=e-4
	\ contains=@tealExpression
syn region tealElseifThen
	\ transparent matchgroup=tealIfStatement
	\ start=/\<elseif\>/ end=/\<then\>/
	\ contains=@tealExpression
syn region tealThenEnd
	\ transparent matchgroup=tealIfStatement
	\ start=/\<then\>/ end=/\<end\>/
	\ contains=@tealStatement,tealElseifThen,tealElse
syn keyword tealElse else contained
hi! link tealIfStatement DraculaRed
hi! link tealElse tealIfStatement
" }}}
" {{{ for ... do ... end, in
syn region tealForDo
	\ matchgroup=tealFor transparent
	\ contains=tealIn,@tealExpression
	\ start=/\<for\>/ end=/\<do\>/me=e-2
syn keyword tealIn in contained
hi! link tealFor DraculaPurpleItalic
" }}}
" {{{ while ... do ... end
syn region tealWhileDo
	\ matchgroup=tealWhile transparent
	\ contains=@tealExpression
	\ start=/\<while\>/ end=/\<do\>/me=e-2
hi! link tealWhile DraculaOrange
" }}}
" {{{ do ... end
syn region tealBlock
	\ matchgroup=tealDoEnd transparent
	\ contains=@tealStatement
	\ start=/\<do\>/ end=/\<end\>/
hi! link tealDoEnd DraculaPurpleItalic
" }}}
" {{{ repeat ... until
syn region tealRepeatBlock
	\ matchgroup=tealRepeatUntil transparent
	\ contains=@tealStatement
	\ start=/\<repeat\>/ end=/\<until\>/
hi! link tealRepeatUntil DraculaYellow
" }}}
" {{{ local .../global ...
syn keyword tealLocal local
syn keyword tealGlobal global

hi! link tealLocal Keyword
hi! link tealGlobal Keyword
" }}}
" {{{ Parens
syn region tealParen transparent
	\ matchgroup=tealParens
	\ start=/(/ end=/)/
	\ contains=@tealExpression
syn region tealBracket transparent
	\ matchgroup=tealBrackets
	\ start=/\[/ end=/\]/
	\ contains=@tealExpression
" }}}
" {{{ Table Constructor
syn region tealTableConstructor
	\ matchgroup=tealTable
	\ start=/{/ end=/}/
	\ contains=@tealExpression
hi! link tealTable DraculaGreen

" }}}
" {{{ Function call
" }}}
" {{{ Goto
" }}}
" {{{ Operators
" }}}
" {{{ true, false, nil, etc...
syn keyword tealConstant nil true false
hi def link tealConstant Constant
" }}}
" {{{ Strings
syn match tealSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syn region tealLongString matchgroup=luaString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syn region tealString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=luaSpecial,@Spell
syn region tealString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=luaSpecial,@Spell
hi! def link tealString DraculaYellow
hi! def link tealLongString DraculaYellow
" }}}
" {{{ Numbers
" integer number
syn match tealNumber "\<\d\+\>"
" floating point number, with dot, optional exponent
syn match tealNumber  "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
" floating point number, starting with a dot, optional exponent
syn match tealNumber  "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
" floating point number, without dot, with exponent
syn match tealNumber  "\<\d\+[eE][-+]\=\d\+\>"
" hex numbers
syn match tealNumber "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
hi def link tealNumber Number
" }}}
" {{{ TODO: Built ins

" }}}

" {{{ Highlight
hi def link tealKeyword Keyword
" }}}
