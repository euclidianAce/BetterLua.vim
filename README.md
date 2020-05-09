# Better Lua Syntax For Vim 
### It's just what it says on the tin.

Edited from the original vim file, it adds support for 5.3 and 5.4, while
removing support for 4.0 and 5.0 because literally nobody ever uses those
anymore.

# Installation
- Vundle
```
Plugin '3uclidian/BetterLua.vim' 
```
- NeoBundle
```
NeoBundle '3uclidian/BetterLua.vim' 
```
- Vim Plug
```
Plug '3uclidian/BetterLua.vim'
```
- Pathogen
```
cd ~/.vim/bundle
git clone https://github.com/3uclidian/BetterLua.vim
```
- Vim 8 package

cd into your preferred directory,
`cd ~/.vim/pack/*/opt/` or `cd ~/.vim/pack/*/start/`
```
git clone https://github.com/3uclidian/BetterLua.vim
```
If necessary, add
```
packadd! BetterLua.vim
```
to your vimrc

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
- EmmyLua style comments have their own highlight groups
	- `luaDocAnnotation`
		- things like `@param`
	- `luaDocName`
		- variable names, the `foo` in `@param foo string`
	- `luaDocType`
		- type names, the `string` in `@param foo string`
			- or `@type string` for var annotations
- Self, while not a keyword, has a highlight group
	- `luaSelf`
- Operator symbols are now highlighted
	- `luaSymbol`
# Not-Changes
- The clever error checking via syntax highlighting is still there with out of
  place keywords and mismatched parens getting highlighted

# TODO
- Add screenshots
- Probably some testing, some proof-reading, and refactors
