describe("is", function()
  local meta, is, cache
  setup(function()
    meta = require "meta"
    require "meta.assert"
    cache = meta.cache
    is = meta.is
  end)
  it("std", function()
    assert.is_true(is.loader(meta))
    assert.equal(is, is('meta'))
  end)
  describe("path values", function()
    it("callable", function()
      assert.is_callable(is.loader)
      assert.is_callable(is.indexable)
    end)
    it("tostring", function()
      assert.equal('net/ip', tostring(is.net.ip))
    end)
  end)
  it("call", function()
    assert.is_true(is.callable(string.format))
    assert.is_true(is.cache(cache.loaded))
    assert.equal('table', type(meta))
  end)
  it("tonumber", function()
    assert.equal(0, tonumber(0))
    assert.equal(0, tonumber('0'))
    assert.equal(nil, tonumber(''))
    assert.equal(nil, tonumber('ui'))
    assert.equal(nil, tonumber(nil))
  end)
  it("nil", function()
    assert.is_true(is['nil']())
    assert.is_true(is['nil'](nil))
    assert.is_true(is.Nil(nil))
    assert.is_true(is.null(nil))
    assert.is_true(is.null())
  end)
  it("number", function() assert.is_true(is.number(7)) end)
  it("string", function() assert.is_true(is.string("a")) end)
  it("file", function() assert.is_file(io.stdin) end)
  it("table", function() assert.is_true(is.table({88, 99})) end)
  it("boolean", function() assert.is_true(is.boolean(true)) end)
  it("func", function()
    assert.is_true(is.func(table.remove))
    assert.is_true(is['function'](table.remove))
  end)
  it("callable", function()
    assert.is_true(is.callable(table.remove))
    assert.is_true(is.callable(table))
    assert.is_true(is.callable(meta.loader))
  end)
  it("iterable", function()
    assert.is_true(is.iterable(table))
    assert.is_true(is.iterable(meta.loader))
  end)
  it("indexable", function()
    assert.is_true(is.indexable(table))
    assert.is_true(is.indexable(meta))
  end)
  it("loader", function()
    assert.is_callable(is.loader)
--    assert.is_false(is.table(meta))
    assert.is_true(is.loader(meta))
    assert.is_true(is.loader(meta.loader))
  end)
  it("require", function()
    assert.is_table(is)
    assert.not_nil(is.integer)
    assert.callable(is.integer)
    assert.truthy(is.integer(77))
  end)
end)
