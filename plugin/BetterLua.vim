
function BetterLua#GetLuaColors()
	if exists("g:colors_name")
		if g:colors_name == "dracula"
			hi! link luaAttrib       DraculaOrangeItalic
			hi! link luaSelf         DraculaPurpleItailc
		endif
	endif
endfunction

autocmd FileType lua call BetterLua#GetLuaColors()
