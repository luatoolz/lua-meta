local memoize = require "meta.memoize"
local len = function(s)
  assert(type(s) == 'string')
  return #s
end
describe('memoize', function()
  it("len", function()
    local c = memoize(len)
    assert.has_error(function() return c[nil] end)
  end)
  it("len", function()
    local c = memoize(len)
    assert.equal(4, c.test)
    assert.equal(4, rawget(c, 'test'))
    assert.is_nil(rawget(c, 'TEST'))
    assert.equal(4, c.TEST)
    assert.equal(4, rawget(c, 'TEST'))
    assert.equal(0, c[''])
    assert.equal(1, c['q'])
  end)
  it("len_normalized", function()
    local c = memoize(len, string.lower)
    assert.equal(4, c.test)
    assert.equal(4, rawget(c, 'test'))
    assert.is_nil(rawget(c, 'TEST'))
    assert.equal(4, c.TEST)
    assert.is_nil(rawget(c, 'TEST'))
    assert.equal(0, c[''])
    assert.equal(1, c['q'])
  end)
end)
