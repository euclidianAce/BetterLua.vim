
function BetterLua#GetLuaColors()
	if exists("g:colors_name")
		if g:colors_name == "dracula"
			hi! link luaSelf            DraculaPurpleItailc
			hi! link luaBuiltIn         DraculaCyan
			hi! link luaFunctionArgName DraculaOrangeItalic
		endif
	endif
	if exists("g:loaded_endwise")
		let b:endwise_addition = 'end'
		let b:endwise_words = 'function,do,then'
		let b:endwise_pattern = '\zs\%(\<function\>\)\%(.*\<end\>\)\@!\|\<\%(then\|do\)\ze\s*$'
		let b:endwise_syngroups = 'luaFunction,luaDoEnd,luaIfStatement'
	endif
endfunction

autocmd FileType lua call BetterLua#GetLuaColors()
