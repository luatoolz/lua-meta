local testdata = 'testdata'
local meta = require "meta"
local prequire = meta.prequire
describe('prequire', function()
  it("ok", function()
    local t, err = prequire (testdata .. ".ok")
    assert.is_not_nil(t)
    assert.is_nil(err)
    assert.equal('ok', t.message.data)
  end)
  it("failed", function()
    local t, err = prequire (testdata .. ".failed")
    assert.is_nil(t)
    assert.is_not_nil(err)
  end)
  it("or", function()
    assert.truthy(prequire("noneexistent") or prequire(testdata .. ".ok"))
    assert.truthy(prequire(testdata .. ".ok") or prequire("noneexistent"))
    assert.truthy(prequire("noneexistent") or prequire("os"))
    assert.truthy(prequire("os") or prequire("noneexistent"))
    assert.truthy((prequire("noneexistent") or prequire("os")).remove)
  end)
end)
