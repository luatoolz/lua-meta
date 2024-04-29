require "compat53"

local prequire = require "meta.prequire"
local sub = require "meta.sub"

-- local require = require "meta.require"(...)
-- local x = require ".submodule"
return function(p, ...)
	return function(m, toerror)
    toerror=type(toerror)=='nil' and true or toerror
	  assert(type(m)=='string', 'require want string, got ' .. type(m))
		if m:sub(1,1)=='.' then m=sub(p, m:sub(2)) end
		return toerror and assert(prequire(m, true)) or prequire(m)
  end
end
