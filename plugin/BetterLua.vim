
function BetterLua#GetLuaColors()
	if g:colors_name == "dracula"
		hi! link emmyLuaAnnotation   DraculaPink
		hi! link emmyLuaAliasName    DraculaOrangeItalic
		hi! link emmyLuaAliasType    DraculaCyanItalic
		hi! link emmyLuaTypeName     DraculaCyanItalic
		hi! link emmyLuaTypeSymbols  Operator
		hi! link emmyLuaAliasName    DraculaOrangeItalic
		hi! link emmyLuaVarName      DraculaOrangeItalic
		hi! link emmyLuaBrackets     DraculaFg
		" hi! link luaLocalAttrib      DraculaOrangeItalic
		hi! link luaSelf             DraculaPurpleItailc
	endif
endfunction

function BetterLua#GetTealColors()
	if g:colors_name == "dracula"
		hi! link tealTable           DraculaFg
		hi! link tealFunctionArgName DraculaOrangeItalic
		hi! link tealSelf            DraculaPurple
		hi! link tealBuiltin         DraculaCyan
		hi! link tealGeneric         DraculaOrangeItalic
		hi! link tealSelf            DraculaPurpleItailc
	endif
endfunction
autocmd FileType lua call BetterLua#GetLuaColors()
autocmd FileType teal call BetterLua#GetTealColors()
