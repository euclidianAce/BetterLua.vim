# Better Lua Syntax For Vim 
### It's just what it says on the tin.

Edited from the original vim file, it adds support for 5.3 and 5.4, while
removing support for 4.0 and 5.0 because literally nobody ever uses those
anymore.

# Installation
- Vim Plug


# Changes
- Built in functions are given a different highlight group so they actually show
  up by default
- Added built ins from 5.3 and 5.4
- Attribute tags from 5.4 have a highlight group
	- luaLocalAttrib
		- `local x <const> = 5`
		- `local y <close> = setmetatable(...)`
	- this one may have some unintentional consequences as it ends the
	  highlight region with the = sign, but `local x <const>` is useless,
	  but valid code. So for now, just don't make nil consts.
- Function calls have a highlight group
	- luaFuncCall
- EmmyLua style comments have their own highlight groups
	- luaDocAnnotation
		- things like `@param`
	- luaDocName
		- variable names, the `foo` in `@param foo string`
	- luaDocType
		- type names, the `string` in `@param foo string`
			- or `@type string` for var annotations
- Self, while not a keyword, has a highlight group
	- luaSelf

# Not-Changes
- The clever error checking via syntax highlighting is still there with out of
  place keywords and mismatched parens getting highlighted

# TODO
- Add screenshots
- Probably some testing, some proof-reading, and refactors
