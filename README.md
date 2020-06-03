# Better Lua Syntax For Vim 
### It's just what it says on the tin. (and a little more)

Edited from the original vim file, it adds support for 5.3 and 5.4, while
removing support for 4.0 and 5.0 because literally nobody ever uses those
anymore.

### Teal!
[Teal](https://github.com/teal-language/tl/) is a typed dialect of Lua (think
typescript but for Lua) that I have quite enjoyed using, so I've taken the
liberty of adopting a Lua syntax file into a Teal one.

# Changes
- Built in functions are given a different highlight group so they actually show
  up by default
- Added built ins from 5.3 and 5.4
- Attribute tags from 5.4 have a highlight group
	- `luaLocalAttrib`
		- `local x <const> = 5`
		- `local y <close> = setmetatable(...)`
	- this one may have some unintentional consequences as it ends the
	  highlight region with the = sign, but `local x <const>` is useless,
	  but valid code. So for now, just don't make nil consts.
- Function calls have a highlight group
	- `luaFuncCall`
- EmmyLua style comments have their own highlight groups (all prefixed with
  `emmyLua`)
	- `emmyLuaAnnotation`
		- The `@` directives like `@param`, `@type`
	- `emmyLuaVarName`
		- Variable names, the `foo` in `@param foo string`
	- `emmyLuaTypeName`
		- Type names, the `string` in `@param foo string`
			- or `@type string` for var annotations
	- `emmyLuaTypeSymbols`
		- For `|` and `:` in type declarations
	- `emmyLuaBrackets`
		- For `<>[],` in type declarations like `@type table<number,
		  string>`
	- `emmyLuaAliasName`, `emmyLuaAliasType`
		- `@alias foo bar`
- Self, while not a keyword, has a highlight group
	- `luaSelf`
- Operator symbols are now highlighted
	- `luaSymbol`
- Varargs has a separate highlight group to not get highlighted as a partial
  concatenation operator
  	- `luaVarargs`
# Not-Changes
- The clever error checking via syntax highlighting is still there with out of
  place keywords and mismatched parens getting highlighted

# TODO
- Add screenshots
- Probably some testing, some proof-reading, and refactors
