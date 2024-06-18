describe("boolean", function()
  setup(function() require "meta" end)
  describe("toboolean", function()
    it("ok", function()
      assert.is_function(toboolean)
      assert.equal(toboolean, require "meta.boolean")
    end)
    it("truthy", function()
      assert.truthy(toboolean(1))
      assert.truthy(toboolean(7))
      assert.truthy(toboolean(-1))
      assert.truthy(toboolean(-7))
      assert.truthy(toboolean('any'))
      assert.truthy(toboolean(' '))
      assert.truthy(toboolean('true'))
      assert.truthy(toboolean('TRUE'))
      assert.truthy(toboolean(true))
    end)
    it("falsy", function()
      assert.falsy(toboolean(0), '0')
      assert.falsy(toboolean(""), '""')
      assert.falsy(toboolean(false), 'false')
      assert.falsy(toboolean(nil), 'nil')
      assert.falsy(toboolean({}), '{}')

      assert.falsy(toboolean("false"), '"false"')
      assert.falsy(toboolean("0"), '"0"')

      assert.falsy(toboolean("FALSE"), '"FALSE"')
    end)
  end)
end)
