if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match
syn sync minlines=100

" {{{ Operators
syn match tealOperator "\V+"
syn match tealOperator "\V-"
syn match tealOperator "\V*"
syn match tealOperator "\V/"
syn match tealOperator "\V^"
syn match tealOperator "\V%"
syn match tealOperator "\V>"
syn match tealOperator "\V<"
syn match tealOperator "\V.."
syn match tealOperator "\V="
syn match tealOperator "\V#"
syn match tealOperator "\V&"
syn match tealOperator "\V~"
syn match tealOperator "\V|"
syn keyword tealOperator as is and or not
" }}}
syn match tealVarargs "\V..."
" {{{ Comments
" First line may start with #!
syn match   tealComment "\%^#!.*"
syn region  tealComment start="--" end="$" contains=tealTodo,@Spell

syn region  tealComment matchgroup=tealComment start="--\[\z(=*\)\[" end="\]\z1\]" contains=tealTodo,tealDoc,@Spell
syn keyword tealTodo contained TODO FIXME XXX
" }}}
" {{{ Function call
" needs to be defined before paren stuffs
syn match tealFuncCall +\zs\(\k\w*\)\ze\s*\n*\s*(+
syn match tealFuncCall +\zs\(\k\w*\)\ze\s*\n*\s*"+
syn match tealFuncCall +\zs\(\k\w*\)\ze\s*\n*\s*'+
syn match tealFuncCall +\zs\(\k\w*\)\ze\s*\n*\s*{+
syn match tealFuncCall +\zs\(\k\w*\)\ze\s*\n*\s*\[=*\[+
" function calls can have any whitespace between the func name and args
" including newlines
" }}}
" {{{ Type tags

" technically type tags can span many lines and do weird stuffs due to not
" caring about whitespace
" but this is easier to program
" syn region tealTypeRegion start=":" end=",\|=\|$" transparent contained
" syn match tealType "\w\+" contained containedin=tealTypeRegion
" hi! link tealType DraculaCyan
" syn cluster tealTypes contains=tealTypeRegion,tealType

" }}}
" {{{ Delimiters
syn region tealParen      transparent                      start='(' end=')' contains=ALLBUT,@tealLocal,tealParenError,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd,tealBlock,tealLoopBlock,tealIn,tealStatement
syn region tealTableBlock transparent matchgroup=tealTable start="{" end="}" contains=ALLBUT,@tealTypes,@tealLocal,tealBraceError,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd,tealBlock,tealLoopBlock,tealIn,tealStatement

syn match  tealParenError ")"
syn match  tealBraceError "}"
syn match  tealError "\<\%(end\|else\|elseif\|then\|until\|in\)\>"
" }}}
" {{{ Blocks
" function ... end
syn region tealFunctionBlock transparent matchgroup=tealFunction start="\<function\>" end="\<end\>" contains=ALLBUT,@tealTypes,tealTodo,tealSpecial,tealElseifThen,tealElse,tealThenEnd,tealIn
" if ... then
syn region tealIfThen transparent matchgroup=tealCond start="\<if\>" end="\<then\>"me=e-4           contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealElseifThen,tealElse,tealIn nextgroup=tealThenEnd skipwhite skipempty
" then ... end
syn region tealThenEnd contained transparent matchgroup=tealCond start="\<then\>" end="\<end\>" contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealThenEnd,tealIn
" elseif ... then
syn keyword tealElse contained else
" do ... end
syn region tealBlock transparent matchgroup=tealStatement start="\<do\>" end="\<end\>"          contains=ALLBUT,@tealTypes,tealTodo,tealSpecial,tealElseifThen,tealElse,tealThenEnd,tealIn
" repeat ... until
syn region tealLoopBlock transparent matchgroup=tealRepeat start="\<repeat\>" end="\<until\>"   contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealElseifThen,tealElse,tealThenEnd,tealIn
" while ... do
syn region tealLoopBlock transparent matchgroup=tealRepeat start="\<while\>" end="\<do\>"me=e-2 contains=ALLBUT,@tealTypes,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd,tealIn nextgroup=tealBlock skipwhite skipempty
" for ... do and for ... in ... do
syn region tealLoopBlock transparent matchgroup=tealRepeat start="\<for\>" end="\<do\>"me=e-2   contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd nextgroup=tealBlock skipwhite skipempty
" Teal specifics
" record ... end
syn region tealRecordBlock transparent matchgroup=tealRecord start="\<record\>" end="\<end\>"   contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd
" enum ... end
syn region tealEnumBlock transparent matchgroup=tealEnum start="\<enum\>" end="\<end\>"         contains=ALLBUT,@tealTypes,@tealLocal,tealTodo,tealSpecial,tealIfThen,tealElseifThen,tealElse,tealThenEnd
syn keyword tealIn contained in
" }}}
" {{{ Strings
syn match  tealSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syn region tealString2 matchgroup=tealString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syn region tealString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=tealSpecial,@Spell
syn region tealString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=tealSpecial,@Spell
" }}}
" {{{ local ... <attrib>
" teal supports lua 5.4 const stuffs
syn match tealLocalAttrib "<\zs\w\+\ze>" containedin=tealLocalAttribTag
syn region tealLocalAttribTag transparent start="<" end=">" containedin=tealLocalDec contains=NONE
syn region tealLocalDec transparent start="\<local\>" end="\<=\>" contains=NONE
syn cluster tealLocal contains=tealLocalDec,tealLocalAttribTag,tealLocalAttrib
" }}}
" {{{ other keywords
syn keyword tealSelf self
syn keyword tealStatement return break global local
syn keyword tealConstant nil
syn keyword tealConstant true false
syn keyword tealStatement goto
syn match tealLabel "::\I\i*::"
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
" {{{ Bulit ins
syn keyword tealFunc assert collectgarbage dofile error next
syn keyword tealFunc print rawget rawset tonumber tostring type _VERSION
syn keyword tealFunc getmetatable setmetatable
syn keyword tealFunc ipairs pairs
syn keyword tealFunc pcall xpcall
syn keyword tealFunc _G loadfile rawequal require
syn keyword tealFunc load select
syn keyword tealFunc _ENV rawlen warn
syn match   tealFunc /\<package\.cpath\>/
syn match   tealFunc /\<package\.loaded\>/
syn match   tealFunc /\<package\.loadlib\>/
syn match   tealFunc /\<package\.path\>/
syn match   tealFunc /\<coroutine\.close\>/
syn match   tealFunc /\<coroutine\.running\>/
syn match   tealFunc /\<coroutine\.create\>/
syn match   tealFunc /\<coroutine\.resume\>/
syn match   tealFunc /\<coroutine\.status\>/
syn match   tealFunc /\<coroutine\.wrap\>/
syn match   tealFunc /\<coroutine\.yield\>/
syn match   tealFunc /\<string\.byte\>/
syn match   tealFunc /\<string\.char\>/
syn match   tealFunc /\<string\.dump\>/
syn match   tealFunc /\<string\.find\>/
syn match   tealFunc /\<string\.format\>/
syn match   tealFunc /\<string\.gsub\>/
syn match   tealFunc /\<string\.len\>/
syn match   tealFunc /\<string\.lower\>/
syn match   tealFunc /\<string\.rep\>/
syn match   tealFunc /\<string\.sub\>/
syn match   tealFunc /\<string\.upper\>/
syn match   tealFunc /\<string\.gmatch\>/
syn match   tealFunc /\<string\.match\>/
syn match   tealFunc /\<string\.reverse\>/
syn match   tealFunc /\<table\.pack\>/
syn match   tealFunc /\<table\.unpack\>/
syn match   tealFunc /\<table\.concat\>/
syn match   tealFunc /\<table\.sort\>/
syn match   tealFunc /\<table\.insert\>/
syn match   tealFunc /\<table\.remove\>/
syn match   tealFunc /\<math\.abs\>/
syn match   tealFunc /\<math\.acos\>/
syn match   tealFunc /\<math\.asin\>/
syn match   tealFunc /\<math\.atan\>/
syn match   tealFunc /\<math\.atan2\>/
syn match   tealFunc /\<math\.ceil\>/
syn match   tealFunc /\<math\.sin\>/
syn match   tealFunc /\<math\.cos\>/
syn match   tealFunc /\<math\.tan\>/
syn match   tealFunc /\<math\.deg\>/
syn match   tealFunc /\<math\.exp\>/
syn match   tealFunc /\<math\.floor\>/
syn match   tealFunc /\<math\.log\>/
syn match   tealFunc /\<math\.max\>/
syn match   tealFunc /\<math\.min\>/
syn match   tealFunc /\<math\.huge\>/
syn match   tealFunc /\<math\.fmod\>/
syn match   tealFunc /\<math\.modf\>/
syn match   tealFunc /\<math\.ult\>/
syn match   tealFunc /\<math\.tointeger\>/
syn match   tealFunc /\<math\.maxinteger\>/
syn match   tealFunc /\<math\.mininteger\>/
syn match   tealFunc /\<math\.pow\>/
syn match   tealFunc /\<math\.rad\>/
syn match   tealFunc /\<math\.sqrt\>/
syn match   tealFunc /\<math\.random\>/
syn match   tealFunc /\<math\.randomseed\>/
syn match   tealFunc /\<math\.pi\>/
syn match   tealFunc /\<io\.close\>/
syn match   tealFunc /\<io\.flush\>/
syn match   tealFunc /\<io\.input\>/
syn match   tealFunc /\<io\.lines\>/
syn match   tealFunc /\<io\.open\>/
syn match   tealFunc /\<io\.output\>/
syn match   tealFunc /\<io\.popen\>/
syn match   tealFunc /\<io\.read\>/
syn match   tealFunc /\<io\.stderr\>/
syn match   tealFunc /\<io\.stdin\>/
syn match   tealFunc /\<io\.stdout\>/
syn match   tealFunc /\<io\.tmpfile\>/
syn match   tealFunc /\<io\.type\>/
syn match   tealFunc /\<io\.write\>/
syn match   tealFunc /\<os\.clock\>/
syn match   tealFunc /\<os\.date\>/
syn match   tealFunc /\<os\.difftime\>/
syn match   tealFunc /\<os\.execute\>/
syn match   tealFunc /\<os\.exit\>/
syn match   tealFunc /\<os\.getenv\>/
syn match   tealFunc /\<os\.remove\>/
syn match   tealFunc /\<os\.rename\>/
syn match   tealFunc /\<os\.setlocale\>/
syn match   tealFunc /\<os\.time\>/
syn match   tealFunc /\<os\.tmpname\>/
syn match   tealFunc /\<debug\.debug\>/
syn match   tealFunc /\<debug\.gethook\>/
syn match   tealFunc /\<debug\.getinfo\>/
syn match   tealFunc /\<debug\.getlocal\>/
syn match   tealFunc /\<debug\.getupvalue\>/
syn match   tealFunc /\<debug\.setlocal\>/
syn match   tealFunc /\<debug\.setupvalue\>/
syn match   tealFunc /\<debug\.sethook\>/
syn match   tealFunc /\<debug\.traceback\>/
syn match   tealFunc /\<debug\.getmetatable\>/
syn match   tealFunc /\<debug\.setmetatable\>/
syn match   tealFunc /\<debug\.getregistry\>/
syn match   tealFunc /\<debug\.getuservalue\>/
syn match   tealFunc /\<debug\.setuservalue\>/
syn match   tealFunc /\<debug\.upvalueid\>/
syn match   tealFunc /\<debug\.upvaluejoin\>/
syn match   tealFunc /\<utf8\.char\>/
syn match   tealFunc /\<utf8\.charpattern\>/
syn match   tealFunc /\<utf8\.codepoint\>/
syn match   tealFunc /\<utf8\.codes\>/
syn match   tealFunc /\<utf8\.len\>/
syn match   tealFunc /\<utf8\.offset\>/
" }}}
" {{{ Highlight
hi def link tealStatement        Statement
hi def link tealRepeat           Repeat
hi def link tealFor              Repeat
hi def link tealString           String
hi def link tealString2          String
hi def link tealNumber           Number
hi def link tealOperator         Operator
hi def link tealIn               Operator
hi def link tealConstant         Constant
hi def link tealCond             Conditional
hi def link tealElse             Conditional
hi def link tealFunction         Keyword
hi def link tealFuncCall         Function
hi def link tealComment          Comment
hi def link tealTodo             Todo
hi def link tealTable            Structure
hi def link tealError            Error
hi def link tealParenError       Error
hi def link tealBraceError       Error
hi def link tealSpecial          SpecialChar
hi def link tealFunc             Identifier
hi def link tealLabel            Label
hi def link tealSelf             Keyword
hi def link tealLocalAttrib      Keyword
hi def link tealEnum             Keyword
hi def link tealRecord           Keyword
" }}}
let b:current_syntax = "teal"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: et ts=8 sw=2
