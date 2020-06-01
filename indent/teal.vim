
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent
setlocal indentexpr=GetTealIndent()
setlocal indentkeys+==end,=until,=elseif,=else

if exists("*GetTealIndent")
	finish
endif

function IsValidMatch()
	return synIDattr(synID(line('.'), col('.'), 1), 'name') =~ '\%(Comment\|String\)$'
endfunction

function GetTealIndent()
	let open = '\%(\<\%(function\|then\|repeat\|do\|enum\|record\)\>\|(\|{\|\[\)'
	let middle = '\<\%(else\|elseif\)\>'
	let close = '\%(\<\%(end\|until\)\>\|)\|}\|\]\)'

	let curPos = getpos(".")

	let prevLine = prevnonblank(v:lnum - 1)
	while synIDattr(synID(prevLine, 1, 1), 'name') =~ 'String$'
		let prevLine = prevnonblank(prevLine - 1)
	endwhile

	if prevLine == 0
		return 0
	endif

	let i = 0

	call cursor(v:lnum, 1)
	let pair = searchpair(open, middle, close, 'mWrb',
		\ "IsValidMatch()", prevLine)
	if pair > 0
		let i += pair
	endif

	call cursor(prevLine, col([prevLine, '$']))
	let pair = searchpair(open, middle, close, 'mWr',
		\ "IsValidMatch()", v:lnum)
	if pair > 0
		let i -= pair
	endif

	call cursor(prevLine - 1, col([prevLine - 1, '$']))
	let pair = searchpair('(', '', ')', 'mWr',
		\ "IsValidMatch()", prevLine)
	if pair > 0
		let i -= 1
	endif

	call cursor(prevLine, col([prevLine, '$']))
	let pair = searchpair('(', '', ')', 'mWr',
		\ "IsValidMatch()", v:lnum)
	if pair > 0
		let i += 1
	endif
	
	call setpos(".", curPos)

	return indent(prevLine) + (&sw * i)
endfunction
