
syn case match
syn sync minlines=100

syn cluster tealBase contains=
	\ tealComment,tealLongComment,
	\ tealConstant,tealNumber,tealString,tealLongString,
	\ tealBuiltin
syn cluster tealExpression contains=
	\ @tealBase,tealParen,tealBracket,tealBrace,
	\ tealOperator,tealFunctionBlock,tealFunctionCall,tealError,
	\ tealTableConstructor,tealRecordBlock,tealEnumBlock,tealSelf
syn cluster tealStatement contains=
	\ @tealExpression,tealIfThen,tealBlock,tealLoop,
	\ tealRepeatBlock,tealWhileDo,tealForDo,
	\ tealGoto,tealLabel,tealBreak,tealReturn,
	\ tealLocal,tealGlobal

" {{{ Types
syn match tealUnion /|/ contained
	\ nextgroup=@tealSingleType
	\ skipwhite skipempty
syn match tealBasicType /\K\k*\(\.\K\k*\)*/ contained
	\ nextgroup=tealUnion
	\ skipwhite skipempty
syn match tealFunctionType /\<function\>/ contained
	\ nextgroup=tealFunctionTypeArgs,tealUnion
	\ skipwhite skipempty
syn region tealFunctionTypeArgs contained transparent
	\ matchgroup=tealParen
	\ start=/(/ end=/)/
	\ contains=@tealSingleType
	\ nextgroup=tealParenTypesAnnotation
	\ skipwhite skipempty
syn match tealParenTypesAnnotation /:/ contained
	\ nextgroup=tealParenTypes
	\ skipwhite skipempty
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
" }}}
" {{{ Operators
" Symbols
syn match tealOperator "[#<>=~^&|*/%+-]\|\.\."
" Words
syn keyword tealOperator and or not
syn keyword tealOperator is as
	\ nextgroup=@tealSingleType
	\ skipempty skipnl skipwhite
" }}}
" {{{ Comments
syn match tealComment "\%^#!.*$"
syn match tealComment /--.*$/ contains=tealTodo,@Spell
syn keyword tealComment contained TODO FIXME XXX
syn region tealLongComment start=/--\[\z(=*\)\[/ end=/\]\z1\]/

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



" }}}
" {{{ record ... end
syn region tealRecordBlock
	\ matchgroup=tealRecord transparent
 	\ start=/\<record\>/ end=/\<end\>/
	\ contains=tealRecordItem,tealRecordTypeAnnotation,tealRecordAssign
syn match tealRecordItem /\K\k\*/ contained
	\ nextgroup=tealRecordTypeAnnotation,tealRecordAssign
	\ skipwhite skipnl skipempty
syn match tealRecordTypeAnnotation /:/ contained
	\ nextgroup=@tealSingleType
	\ skipwhite skipnl skipempty
syn match tealRecordAssign /=/ contained
	\ nextgroup=tealRecordBlock
	\ skipwhite skipnl skipempty
" }}}
" {{{ enum ... end
syn region tealEnumBlock
	\ matchgroup=tealEnum transparent
	\ start="\<enum\>" end="\<end\>"
	\ contains=tealString
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
" }}}
" {{{ for ... do ... end, in
syn region tealForDo
	\ matchgroup=tealFor transparent
	\ contains=tealIn,@tealExpression
	\ start=/\<for\>/ end=/\<do\>/me=e-2
syn keyword tealIn in contained
" }}}
" {{{ while ... do ... end
syn region tealWhileDo
	\ matchgroup=tealWhile transparent
	\ contains=@tealExpression
	\ start=/\<while\>/ end=/\<do\>/me=e-2
" }}}
" {{{ do ... end
syn region tealBlock
	\ matchgroup=tealDoEnd transparent
	\ contains=@tealStatement
	\ start=/\<do\>/ end=/\<end\>/
" }}}
" {{{ repeat ... until
syn region tealRepeatBlock
	\ matchgroup=tealRepeatUntil transparent
	\ contains=@tealStatement
	\ start=/\<repeat\>/ end=/\<until\>/
" }}}
" {{{ local, global, break, return, self
syn keyword tealLocal local
syn keyword tealGlobal global
syn keyword tealBreak break
syn keyword tealReturn return
syn keyword tealSelf self

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

" }}}
" {{{ Function call
syn match tealFunctionCall /\K\k*\("\|'\|(\|{\|\[=*\[\)\@=/
" }}}
" {{{ Goto
syn keyword tealGoto goto
syn match tealLabel /::\K\k*::/

" }}}
" {{{ true, false, nil, etc...
syn keyword tealConstant nil true false
" }}}
" {{{ Strings
syn match tealSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syn region tealLongString matchgroup=tealString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syn region tealString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=luaSpecial,@Spell
syn region tealString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=luaSpecial,@Spell
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
" }}}
" {{{ Built ins

syn keyword luaBuiltIn assert error collectgarbage
	\ print tonumber tostring type
	\ getmetatable setmetatable
	\ ipairs pairs next
	\ pcall xpcall
	\ _G _ENV _VERSION require
	\ rawequal rawget rawset rawlen
	\ loadfile load dofile select
	\ /\<package\.cpath\>/
	\ /\<package\.loaded\>/
	\ /\<package\.loadlib\>/
	\ /\<package\.path\>/
	\ /\<coroutine\.running\>/
	\ /\<coroutine\.create\>/
	\ /\<coroutine\.resume\>/
	\ /\<coroutine\.status\>/
	\ /\<coroutine\.wrap\>/
	\ /\<coroutine\.yield\>/
	\ /\<string\.byte\>/
	\ /\<string\.char\>/
	\ /\<string\.dump\>/
	\ /\<string\.find\>/
	\ /\<string\.format\>/
	\ /\<string\.gsub\>/
	\ /\<string\.len\>/
	\ /\<string\.lower\>/
	\ /\<string\.rep\>/
	\ /\<string\.sub\>/
	\ /\<string\.upper\>/
	\ /\<string\.gmatch\>/
	\ /\<string\.match\>/
	\ /\<string\.reverse\>/
	\ /\<table\.pack\>/
	\ /\<table\.unpack\>/
	\ /\<table\.concat\>/
	\ /\<table\.sort\>/
	\ /\<table\.insert\>/
	\ /\<table\.remove\>/
	\ /\<math\.abs\>/
	\ /\<math\.acos\>/
	\ /\<math\.asin\>/
	\ /\<math\.atan\>/
	\ /\<math\.atan2\>/
	\ /\<math\.ceil\>/
	\ /\<math\.sin\>/
	\ /\<math\.cos\>/
	\ /\<math\.tan\>/
	\ /\<math\.deg\>/
	\ /\<math\.exp\>/
	\ /\<math\.floor\>/
	\ /\<math\.log\>/
	\ /\<math\.max\>/
	\ /\<math\.min\>/
	\ /\<math\.huge\>/
	\ /\<math\.fmod\>/
	\ /\<math\.modf\>/
	\ /\<math\.ult\>/
	\ /\<math\.tointeger\>/
	\ /\<math\.maxinteger\>/
	\ /\<math\.mininteger\>/
	\ /\<math\.pow\>/
	\ /\<math\.rad\>/
	\ /\<math\.sqrt\>/
	\ /\<math\.random\>/
	\ /\<math\.randomseed\>/
	\ /\<math\.pi\>/
	\ /\<io\.close\>/
	\ /\<io\.flush\>/
	\ /\<io\.input\>/
	\ /\<io\.lines\>/
	\ /\<io\.open\>/
	\ /\<io\.output\>/
	\ /\<io\.popen\>/
	\ /\<io\.read\>/
	\ /\<io\.stderr\>/
	\ /\<io\.stdin\>/
	\ /\<io\.stdout\>/
	\ /\<io\.tmpfile\>/
	\ /\<io\.type\>/
	\ /\<io\.write\>/
	\ /\<os\.clock\>/
	\ /\<os\.date\>/
	\ /\<os\.difftime\>/
	\ /\<os\.execute\>/
	\ /\<os\.exit\>/
	\ /\<os\.getenv\>/
	\ /\<os\.remove\>/
	\ /\<os\.rename\>/
	\ /\<os\.setlocale\>/
	\ /\<os\.time\>/
	\ /\<os\.tmpname\>/
	\ /\<debug\.debug\>/
	\ /\<debug\.gethook\>/
	\ /\<debug\.getinfo\>/
	\ /\<debug\.getlocal\>/
	\ /\<debug\.getupvalue\>/
	\ /\<debug\.setlocal\>/
	\ /\<debug\.setupvalue\>/
	\ /\<debug\.sethook\>/
	\ /\<debug\.traceback\>/
	\ /\<debug\.getmetatable\>/
	\ /\<debug\.setmetatable\>/
	\ /\<debug\.getregistry\>/
	\ /\<debug\.getuservalue\>/
	\ /\<debug\.setuservalue\>/
	\ /\<debug\.upvalueid\>/
	\ /\<debug\.upvaluejoin\>/
	\ /\<utf8\.char\>/
	\ /\<utf8\.charpattern\>/
	\ /\<utf8\.codepoint\>/
	\ /\<utf8\.codes\>/
	\ /\<utf8\.len\>/
	\ /\<utf8\.offset\>/

" }}}
" {{{ Highlight
hi def link tealKeyword                      Keyword
hi def link tealFunctionName                 Function
" hi def link tealFunctionArgName              DraculaOrange
hi def link tealFunctionArgName              Identifier
hi def link tealLocal                        Keyword
hi def link tealGlobal                       Keyword
hi def link tealBreak                        Keyword
hi def link tealReturn                       Keyword
hi def link tealSelf                         Special
" hi def link tealTable                        DraculaGreen
hi def link tealTable                        Structure
hi def link tealBasicType                    Type
hi def link tealFunctionType                 Type
" hi def link tealParens                       
hi def link tealRecord                       Keyword
hi def link tealEnum                         Keyword
hi def link tealIfStatement                  Conditional
hi def link tealElse                         Conditional
hi def link tealFor                          Repeat
hi def link tealWhile                        Repeat
hi def link tealDoEnd                        Keyword
hi def link tealRepeatUntil                  Repeat
hi def link tealFunctionCall                 Function
hi def link tealGoto                         Keyword
hi def link tealLabel                        Label
hi def link tealString                       String
hi def link tealLongString                   String
hi def link tealComment                      Comment
hi def link tealLongComment                  Comment
hi def link tealConstant                     Constant
hi def link tealNumber                       Number
hi def link tealOperator                     Operator
" }}}
