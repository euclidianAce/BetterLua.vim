
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
		hi! link luaSelf             DraculaPurple
	endif
endfunction

function BetterLua#GetTealColors()
	if g:colors_name == "dracula"
		hi! link tealTable           DraculaFg
		hi! link tealFunctionArgName DraculaOrange
		hi! link tealSelf            DraculaPurple
		hi! link tealBuiltin         DraculaCyan
		hi! link tealAttribute       DraculaOrangeItalic
	endif
endfunction
autocmd FileType lua call BetterLua#GetLuaColors()
autocmd FileType teal call BetterLua#GetTealColors()
