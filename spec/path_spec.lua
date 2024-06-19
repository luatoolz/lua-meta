describe("path", function()
  local meta
  setup(function()
    meta = require "meta"
    meta.no.track('testdata')
  end)
  describe("object", function()
    it("callable", function()
      local m = meta.module('testdata.loader')
      assert.is_true(m.exists)
      assert.equal('testdata/loader', m.dir)
      assert.equal('testdata', tostring(m.parent))
      assert.is_table(m.parent.loader)

      local td = meta.path('testdata')
      local ok = td.loader.meta_path.ok
      assert.is_table(ok)
      assert.equal('OK', tostring(ok))
      assert.equal('ok', ok[0].message)

      assert.equal('OK', ok())

      assert.is_nil(rawget(ok, 'message'))
      assert.equal('ok', ok.message)
      assert.is_nil(rawget(ok, 'message'))
    end)
    it("function callable", function()
      local m = meta.path('meta')
      assert.is_table(m.no)
      assert.is_function(m.is.boolean[0])
      assert.is_true(m.is.boolean(true))
    end)
    it("equal", function()
      local m = meta.path('meta')
      local a, b = m.is.boolean, m.is.boolean
      assert.is_true(rawequal(a, b))
    end)
  end)
end)
