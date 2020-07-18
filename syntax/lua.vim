" Options:	lua_subversion = 1, 2, 3, or 4
"               default: 3
"               BetterLua_enable_emmylua = 0 or 1
"               default: 1

if exists("b:current_syntax")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

if !exists("lua_subversion")
	let lua_subversion = 3
endif
if !exists("BetterLua_enable_emmylua")
	let BetterLua_enable_emmylua = 1
endif

syn case match
syn sync fromstart

syn cluster luaBase contains=
	\ luaComment,luaLongComment,luaEmmyComment,
	\ luaConstant,luaNumber,luaString,luaLongString
syn cluster luaExpression contains=
	\ @luaBase,luaParen,luaBuiltin,luaBracket,luaBrace,
	\ luaOperator,luaFunctionBlock,luaFunctionCall,luaError,
	\ luaTableConstructor,luaSelf,
	\ luaVarargs
syn cluster luaStatement contains=
	\ @luaExpression,luaIfThen,luaThenEnd,luaBlock,luaLoop,
	\ luaRepeatBlock,luaWhileDo,luaForDo,
	\ luaGoto,luaLabel,luaBreak,luaReturn,
	\ luaLocal

" {{{ ), ], end, etc error
syntax match luaError "\()\|}\|\]\)"
syntax match luaError "\<\%(end\|else\|elseif\|then\|until\|in\)\>"
" }}}
" {{{ Function call
syn match luaFunctionCall /\(:\?\)\@1<=\zs\K\k*\ze\s*\n*\s*\(["'({]\|\[=*\[\)/
" }}}
" {{{ Operators
" Symbols
syn match luaOperator "[#<>=~^&|*/%+-]\|\.\."
" Words
syn keyword luaOperator and or not
syn match luaVarargs /\.\.\./
" }}}
" {{{ Comments
syn match luaComment "\%^#!.*$"
syn match luaComment /--.*$/ contains=luaTodo,@Spell
syn keyword luaTodo contained TODO FIXME XXX
syn region luaLongComment start=/--\[\z(=*\)\[/ end=/\]\z1\]/

" }}}
" {{{ Emmylua
if BetterLua_enable_emmylua == 1
	syn match luaEmmyComment /---.*$/ contains=luaTodo,@Spell
	syn match luaEmmyType /\K\k*/ contained containedin=luaEmmyComment
	syn match luaEmmyClassColon /:/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyBar /|/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyClassName /\K\k*/ contained
		\ nextgroup=luaEmmyClassColon
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@class/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyClassName
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@type/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyAliasName /\K\k*/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@alias/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyAliasName
		\ skipnl skipempty skipwhite
	syn match luaEmmyParamName /\K\k*/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@param/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyParamName
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@return/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyFieldName /\K\k*/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	syn match luaEmmyFieldExposure /\<\%(public\|protected\|private\)\>/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyFieldName
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@field/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyFieldExposure,luaEmmyFieldName
		\ skipnl skipempty skipwhite
	syn match luaEmmyGenericParentName /\K\k*/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyComma
		\ skipnl skipempty skipwhite
	syn match luaEmmyGenericColon /:/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyGenericParentName
		\ skipnl skipempty skipwhite
	syn match luaEmmyGenericComma /,/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyGenericName
		\ skipnl skipempty skipwhite
	syn match luaEmmyGenericName /\K\k*/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyGenericColon,luaEmmyGenericComma
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@generic/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyGenericName
		\ skipnl skipempty skipwhite
	syn match luaEmmyKeyword /@vararg/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyType
		\ skipnl skipempty skipwhite
	"TODO make a plugin that makes this work
	syn match luaEmmyLang /\K\k*/ contained containedin=luaEmmyComment
	syn match luaEmmyKeyword /@language/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmyLang
		\ skipnl skipempty skipwhite
	syn match luaEmmySeeReference /\K\k*#\K\k*/ contained containedin=luaEmmyComment
	syn match luaEmmyKeyword /@see/ contained containedin=luaEmmyComment
		\ nextgroup=luaEmmySeeReference
		\ skipnl skipempty skipwhite

	syn match luaEmmyFluff /[^@-]\S*/ contained containedin=luaEmmyComment
endif
" }}}
" {{{ local ... <const>, break, return, self
if lua_subversion >= 4
	syn region luaAttributeBrackets contained transparent
		\ matchgroup=luaParens
		\ start=/</ end=/>/
		\ contains=luaAttribute
		\ nextgroup=luaVarComma
		\ skipwhite skipempty skipnl
	syn match luaAttribute contained /\K\k*/
endif
syn match luaVarName contained /\K\k*/
	\ nextgroup=luaAttributeBrackets,luaVarComma
	\ skipwhite skipempty skipnl
syn match luaVarComma /,/ contained
	\ nextgroup=luaVarName
	\ skipwhite skipempty skipnl
syn keyword luaLocal local
	\ nextgroup=luaFunctionBlock,luaVarName
	\ skipwhite skipempty skipnl
syn keyword luaBreak break
syn keyword luaReturn return
syn keyword luaSelf self

" }}}
" {{{ Parens
syn region luaParen transparent
	\ matchgroup=luaParens
	\ start=/(/ end=/)/
	\ contains=@luaExpression
syn region luaBracket transparent
	\ matchgroup=luaBrackets
	\ start=/\[/ end=/\]/
	\ contains=@luaExpression
" }}}
" {{{ function ... end
syn region luaFunctionBlock transparent
	\ matchgroup=luaFunction
	\ start=/\<function\>/ end=/\<end\>/
	\ contains=@luaStatement,luaFunctionSignature
syn region luaFunctionSignature contained transparent
	\ start=/\(\<function\>\)\@<=/ end=/)/ keepend
	\ contains=luaFunctionName,luaFunctionArgs
syn match luaFunctionName /\K\k*\(\.\K\k*\)*\(:\K\k*\)\?/ contained
	\ nextgroup=luaFunctionArgs
	\ skipwhite skipempty skipnl
syn region luaFunctionArgs contained transparent
	\ matchgroup=luaParens
	\ start=/(/ end=/)/
	\ contains=@luaBase,luaFunctionArgNames
syn match luaFunctionArgName contained /\K\k*/
	\ nextgroup=luaFunctionArgComma
	\ skipwhite skipempty skipnl
" }}}
" {{{ if ... then, elseif ... then, then ... end, else
syn region luaIfThen
	\ transparent matchgroup=luaIfStatement
	\ start=/\<if\>/ end=/\<then\>/me=e-4
	\ contains=@luaExpression
syn region luaElseifThen
	\ transparent matchgroup=luaIfStatement
	\ start=/\<elseif\>/ end=/\<then\>/
	\ contains=@luaExpression
syn region luaThenEnd
	\ transparent matchgroup=luaIfStatement
	\ start=/\<then\>/ end=/\<end\>/
	\ contains=@luaStatement,luaElseifThen,luaElse
syn keyword luaElse else contained
" }}}
" {{{ for ... do ... end, in
syn region luaForDo
	\ matchgroup=luaFor transparent
	\ contains=luaIn,@luaExpression
	\ start=/\<for\>/ end=/\<do\>/me=e-2
syn keyword luaIn in contained
" }}}
" {{{ while ... do ... end
syn region luaWhileDo
	\ matchgroup=luaWhile transparent
	\ contains=@luaExpression
	\ start=/\<while\>/ end=/\<do\>/me=e-2
" }}}
" {{{ do ... end
syn region luaBlock
	\ matchgroup=luaDoEnd transparent
	\ contains=@luaStatement
	\ start=/\<do\>/ end=/\<end\>/
" }}}
" {{{ repeat ... until
syn region luaRepeatBlock
	\ matchgroup=luaRepeatUntil transparent
	\ contains=@luaStatement
	\ start=/\<repeat\>/ end=/\<until\>/
" }}}
" {{{ Table Constructor
syn region luaTableConstructor
	\ matchgroup=luaTable
	\ start=/{/ end=/}/
	\ contains=@luaExpression

" }}}
" {{{ Goto
if lua_subversion >= 2
	syn keyword luaGoto goto
	syn match luaLabel /::\K\k*::/
endif

" }}}
" {{{ true, false, nil, etc...
syn keyword luaConstant nil true false
" }}}
" {{{ Strings
syn match luaSpecial contained #\\[\\abfnrtv'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
if lua_subversion >= 2
	syn match luaSpecial contained #\\z#
endif
syn region luaLongString matchgroup=luaString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syn region luaString  start=+'+ end=+'\|$+ skip=+\\\\\|\\'+ contains=luaSpecial,@Spell
syn region luaString  start=+"+ end=+"\|$+ skip=+\\\\\|\\"+ contains=luaSpecial,@Spell
" }}}
" {{{ Numbers
" integer number
syn match luaNumber "\<\d\+\>"
" floating point number, with dot, optional exponent
syn match luaNumber  "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
" floating point number, starting with a dot, optional exponent
syn match luaNumber  "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
" floating point number, without dot, with exponent
syn match luaNumber  "\<\d\+[eE][-+]\=\d\+\>"
" hex numbers
syn match luaNumber "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
" }}}
" {{{ Built ins

syn keyword luaBuiltIn assert error collectgarbage
	\ print tonumber tostring type
	\ getmetatable setmetatable
	\ ipairs pairs next
	\ pcall xpcall
	\ _G _VERSION require
	\ rawequal rawget rawset rawlen
	\ loadfile load dofile select

if lua_subversion >= 4
	syn match luaBuiltIn /\<coroutine\.close\>/
	syn keyword luaBuiltIn warn
endif
if lua_subversion < 3
	syn match luaBuiltIn /\<math\.sinh\>/
	syn match luaBuiltIn /\<math\.cosh\>/
	syn match luaBuiltIn /\<math\.tanh\>/
	syn match luaBuiltIn /\<math\.atan2\>/
	syn match luaBuiltIn /\<math\.frexp\>/
	syn match luaBuiltIn /\<math\.ldexp\>/
else
	syn match luaBuiltIn /\<table\.move\>/
	syn match luaBuiltIn /\<string\.pack\>/
	syn match luaBuiltIn /\<string\.unpack\>/
	syn match luaBuiltIn /\<string\.packsize\>/
	syn match luaBuiltIn /\<utf8\.char\>/
	syn match luaBuiltIn /\<utf8\.charpattern\>/
	syn match luaBuiltIn /\<utf8\.codepoint\>/
	syn match luaBuiltIn /\<utf8\.codes\>/
	syn match luaBuiltIn /\<utf8\.len\>/
	syn match luaBuiltIn /\<utf8\.offset\>/
	syn match luaBuiltIn /\<math\.ult\>/
	syn match luaBuiltIn /\<math\.tointeger\>/
	syn match luaBuiltIn /\<math\.maxinteger\>/
	syn match luaBuiltIn /\<math\.mininteger\>/
endif
if lua_subversion == 2
	syn match luaBuiltIn /\<bit32\.arshift\>/
	syn match luaBuiltIn /\<bit32\.band\>/
	syn match luaBuiltIn /\<bit32\.bnot\>/
	syn match luaBuiltIn /\<bit32\.bor\>/
	syn match luaBuiltIn /\<bit32\.btest\>/
	syn match luaBuiltIn /\<bit32\.bxor\>/
	syn match luaBuiltIn /\<bit32\.extract\>/
	syn match luaBuiltIn /\<bit32\.lrotate\>/
	syn match luaBuiltIn /\<bit32\.lshift\>/
	syn match luaBuiltIn /\<bit32\.replace\>/
	syn match luaBuiltIn /\<bit32\.rrotate\>/
	syn match luaBuiltIn /\<bit32\.rshift\>/
endif
if lua_subversion < 2
	syn match luaBuiltIn /\<math\.log10\>/
	syn keyword luaBuiltIn unpack getfenv setfenv loadstring
else
	syn match luaBuiltIn /\<package\.searchpath\>/
	syn keyword luaBuiltIn _ENV
	syn match luaBuiltIn /\<table\.unpack\>/
	syn match luaBuiltIn /\<debug\.getuservalue\>/
	syn match luaBuiltIn /\<debug\.setuservalue\>/
endif
syn match luaBuiltIn /\<package\.cpath\>/
syn match luaBuiltIn /\<package\.loaded\>/
syn match luaBuiltIn /\<package\.loadlib\>/
syn match luaBuiltIn /\<package\.path\>/
syn match luaBuiltIn /\<coroutine\.running\>/
syn match luaBuiltIn /\<coroutine\.create\>/
syn match luaBuiltIn /\<coroutine\.resume\>/
syn match luaBuiltIn /\<coroutine\.status\>/
syn match luaBuiltIn /\<coroutine\.wrap\>/
syn match luaBuiltIn /\<coroutine\.yield\>/
syn match luaBuiltIn /\<string\.byte\>/
syn match luaBuiltIn /\<string\.char\>/
syn match luaBuiltIn /\<string\.dump\>/
syn match luaBuiltIn /\<string\.find\>/
syn match luaBuiltIn /\<string\.format\>/
syn match luaBuiltIn /\<string\.gsub\>/
syn match luaBuiltIn /\<string\.len\>/
syn match luaBuiltIn /\<string\.lower\>/
syn match luaBuiltIn /\<string\.rep\>/
syn match luaBuiltIn /\<string\.sub\>/
syn match luaBuiltIn /\<string\.upper\>/
syn match luaBuiltIn /\<string\.gmatch\>/
syn match luaBuiltIn /\<string\.match\>/
syn match luaBuiltIn /\<string\.reverse\>/
syn match luaBuiltIn /\<table\.pack\>/
syn match luaBuiltIn /\<table\.concat\>/
syn match luaBuiltIn /\<table\.sort\>/
syn match luaBuiltIn /\<table\.insert\>/
syn match luaBuiltIn /\<table\.remove\>/
syn match luaBuiltIn /\<math\.abs\>/
syn match luaBuiltIn /\<math\.acos\>/
syn match luaBuiltIn /\<math\.asin\>/
syn match luaBuiltIn /\<math\.atan\>/
syn match luaBuiltIn /\<math\.ceil\>/
syn match luaBuiltIn /\<math\.sin\>/
syn match luaBuiltIn /\<math\.cos\>/
syn match luaBuiltIn /\<math\.tan\>/
syn match luaBuiltIn /\<math\.deg\>/
syn match luaBuiltIn /\<math\.exp\>/
syn match luaBuiltIn /\<math\.floor\>/
syn match luaBuiltIn /\<math\.log\>/
syn match luaBuiltIn /\<math\.max\>/
syn match luaBuiltIn /\<math\.min\>/
syn match luaBuiltIn /\<math\.huge\>/
syn match luaBuiltIn /\<math\.fmod\>/
syn match luaBuiltIn /\<math\.modf\>/
syn match luaBuiltIn /\<math\.pow\>/
syn match luaBuiltIn /\<math\.rad\>/
syn match luaBuiltIn /\<math\.sqrt\>/
syn match luaBuiltIn /\<math\.random\>/
syn match luaBuiltIn /\<math\.randomseed\>/
syn match luaBuiltIn /\<math\.pi\>/
syn match luaBuiltIn /\<io\.close\>/
syn match luaBuiltIn /\<io\.flush\>/
syn match luaBuiltIn /\<io\.input\>/
syn match luaBuiltIn /\<io\.lines\>/
syn match luaBuiltIn /\<io\.open\>/
syn match luaBuiltIn /\<io\.output\>/
syn match luaBuiltIn /\<io\.popen\>/
syn match luaBuiltIn /\<io\.read\>/
syn match luaBuiltIn /\<io\.stderr\>/
syn match luaBuiltIn /\<io\.stdin\>/
syn match luaBuiltIn /\<io\.stdout\>/
syn match luaBuiltIn /\<io\.tmpfile\>/
syn match luaBuiltIn /\<io\.type\>/
syn match luaBuiltIn /\<io\.write\>/
syn match luaBuiltIn /\<os\.clock\>/
syn match luaBuiltIn /\<os\.date\>/
syn match luaBuiltIn /\<os\.difftime\>/
syn match luaBuiltIn /\<os\.execute\>/
syn match luaBuiltIn /\<os\.exit\>/
syn match luaBuiltIn /\<os\.getenv\>/
syn match luaBuiltIn /\<os\.remove\>/
syn match luaBuiltIn /\<os\.rename\>/
syn match luaBuiltIn /\<os\.setlocale\>/
syn match luaBuiltIn /\<os\.time\>/
syn match luaBuiltIn /\<os\.tmpname\>/
syn match luaBuiltIn /\<debug\.debug\>/
syn match luaBuiltIn /\<debug\.gethook\>/
syn match luaBuiltIn /\<debug\.getinfo\>/
syn match luaBuiltIn /\<debug\.getlocal\>/
syn match luaBuiltIn /\<debug\.getupvalue\>/
syn match luaBuiltIn /\<debug\.setlocal\>/
syn match luaBuiltIn /\<debug\.setupvalue\>/
syn match luaBuiltIn /\<debug\.sethook\>/
syn match luaBuiltIn /\<debug\.traceback\>/
syn match luaBuiltIn /\<debug\.getmetatable\>/
syn match luaBuiltIn /\<debug\.setmetatable\>/
syn match luaBuiltIn /\<debug\.getregistry\>/
syn match luaBuiltIn /\<debug\.upvalueid\>/
syn match luaBuiltIn /\<debug\.upvaluejoin\>/

" }}}
" {{{ Highlight
hi def link luaKeyword               Keyword
hi def link luaFunction              Keyword
hi def link luaFunctionName          Function
hi def link luaFunctionArgName       Identifier
hi def link luaLocal                 Keyword
hi def link luaBreak                 Keyword
hi def link luaReturn                Keyword
hi def link luaIn                    Keyword
hi def link luaSelf                  Special
hi def link luaTable                 Structure
hi def link luaAttribute             StorageClass
hi def link luaParens                Identifier
hi def link luaIfStatement           Conditional
hi def link luaElse                  Conditional
hi def link luaFor                   Repeat
hi def link luaWhile                 Repeat
hi def link luaDoEnd                 Keyword
hi def link luaRepeatUntil           Repeat
hi def link luaFunctionCall          Function
hi def link luaGoto                  Keyword
hi def link luaLabel                 Label
hi def link luaString                String
hi def link luaLongString            String
hi def link luaSpecial               Special
hi def link luaComment               Comment
hi def link luaLongComment           Comment
hi def link luaConstant              Constant
hi def link luaNumber                Number
hi def link luaOperator              Operator
hi def link luaBuiltIn               Identifier
hi def link luaError                 Error
hi def link luaTodo                  Todo
hi def link luaEmmyComment           Comment
hi def link luaEmmyClassName         Special
hi def link luaEmmyType              Type
hi def link luaEmmyAliasName         Special
hi def link luaEmmyParamName         Special
hi def link luaEmmyFieldName         Special
hi def link luaEmmyFieldExposure     StorageClass
hi def link luaEmmyGenericName       Special
hi def link luaEmmyGenericParentName Type
hi def link luaEmmySeeReference      SpecialComment
hi def link luaEmmyKeyword           PreProc
" }}}

let b:current_syntax = "lua"

let &cpo = s:cpo_save
unlet s:cpo_save
