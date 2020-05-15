
function BetterLua#GetColors()
	if g:colors_name == "dracula"
		hi! link emmyLuaAnnotation   DraculaPink
		hi! link emmyLuaAliasName    DraculaOrangeItalic
		hi! link emmyLuaAliasType    DraculaCyanItalic
		hi! link emmyLuaTypeName     DraculaCyanItalic
		hi! link emmyLuaTypeSymbols  Operator
		hi! link emmyLuaAliasName    DraculaOrangeItalic
		hi! link emmyLuaVarName      DraculaOrangeItalic
		hi! link emmyLuaBrackets     DraculaFg
		hi! link luaSelf             DraculaPurple
	endif
endfunction

autocmd FileType lua call BetterLua#GetColors()
