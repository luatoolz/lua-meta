local testdata = 'testdata'
local meta = require "meta"
local t = require "testdata/loader"
describe('loader', function()
  it("ok", function()
    assert.is_not_nil(t)
    assert.is_not_nil(t.ok)
    assert.equal('ok', t.ok.message.data)
  end)
  it("dot", function()
    assert.is_not_nil(t)
    assert.is_not_nil(t.dot)
    assert.equal('ok', t.dot['ok.message'].data)
  end)
  it("path", function()
    assert.equal(testdata .. '/loader', meta.loader.path('loader'))
    assert.equal(testdata .. '/loader', meta.loader.path(testdata .. '/loader'))
    assert.equal(testdata .. '/loader/noinit', meta.loader.path('loader', 'noinit'))
  end)
  it("noinit", function()
    assert.is_not_nil(t)
    assert.equal('table', type(t))
    assert.is_not_nil(t.noinit)
    assert.equal('table', type(t.noinit))
    assert.equal('ok', t.noinit['ok.message'].data)
    assert.equal('ok', t.noinit.message.data)
  end)
  it("failed", function()
    assert.has_error(function() return t.failed end)
  end)
end)
