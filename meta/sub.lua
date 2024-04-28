require "compat53"

local conf = require "meta.conf"

local sep = conf.sep
return function(mod, key)
  if type(mod)=='nil' then return nil end
  mod=tostring(mod)
  if type(mod)=='nil' then return nil end
  assert(type(mod)=='string', 'should be string, but got ' .. type(mod))
  assert(type(key)=='nil' or type(key)=='string')
--  local kdots = (key or ''):match(conf.mdot)
  local mdots = mod:match(conf.mdot)
  local mslash = mod:match(conf.msep)
  if not (mdots and mslash) then
    mod = mod:gsub(conf.mdot, sep)
  end
  return key and table.concat({mod, key}, sep) or mod
end