
function BetterLua#GetColors()
	if g:colors_name == "dracula"
		hi! link luaSelf          DraculaPurpleItalic
		hi! link luaDocAnnotation DraculaPink
		hi! link luaDocName       DraculaOrangeItalic
		hi! link luaDocType       DraculaCyanItalic
		hi! link luaLocalAttrib   DraculaOrangeItalic
	endif
endfunction

autocmd FileType lua call BetterLua#GetColors()
