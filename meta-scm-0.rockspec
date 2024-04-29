rockspec_format = "3.0"
package = "meta"
version = "scm-0"

source = {
  url = "git+https://github.com/luatoolz/lua-meta",
}

description = {
  summary = "lua meta methods library",
  detailed = [[
set of meta methods:
- recursive autoloader with preloading and match/iterate of submodules
- require with dots `require "t/seo/google.com"`
- relative `require ".submodule"` (after `local require = require "meta.require"(...)`)
- module path normalizing
- instance/type meta methods manipulations
]],
  homepage = "https://github.com/luatoolz/lua-meta",
  license = "MIT",
  issues_url = "https://github.com/luatoolz/lua-meta/issues",
  maintainer = "luatoolz@somahorse.com"
}

dependencies = {
  "lua >= 5.1",
  "paths",
  "compat53"
}

test_dependencies = {
  "busted",
}

test = {
  type = "busted",
}

rocks_servers = {
	"https://luarocks.org/repositories/rocks",
	"https://luarocks.org/dev",
}

build = {
  copy_directories = {},
  type = "builtin",
  modules = {
    ["meta.cache"] = "meta/cache.lua",
    ["meta.computed"] = "meta/computed.lua",
    ["meta.conf"] = "meta/conf.lua",
    ["meta.dir"] = "meta/dir.lua",
    ["meta.get"] = "meta/get.lua",
    ["meta.init"] = "meta/init.lua",
    ["meta.isdir"] = "meta/isdir.lua",
    ["meta.loader"] = "meta/loader.lua",
    ["meta.loaders"] = "meta/loaders.lua",
    ["meta.memoize"] = "meta/memoize.lua",
    ["meta.methods"] = "meta/methods.lua",
    ["meta.path"] = "meta/path.lua",
    ["meta.preload"] = "meta/preload.lua",
    ["meta.prequire"] = "meta/prequire.lua",
    ["meta.require"] = "meta/require.lua",
    ["meta.searcher"] = "meta/searcher.lua",
    ["meta.set"] = "meta/set.lua",
    ["meta.sub"] = "meta/sub.lua",
  }
}
