describe("table", function()
  local meta
  setup(function()
    meta = require "meta"
  end)
  it("mt", function()
    assert.is_table(table)
    local mt = getmetatable(table())
    assert.is_table(mt)
    assert.same(mt, getmetatable(table()))
    assert.same(mt, getmetatable(table({})))
    assert.same(mt, getmetatable(table({"a"})))
    assert.same(mt, getmetatable(table("a")))
  end)
  it("new", function()
    assert.same(table {}, table())
    assert.same(table {}, table(nil))
    assert.same(table {}, table({nil}))
    assert.same(table {"x"}, table({"x"}))
    assert.same(table {"x"}, table("x"))
    assert.same(table {"x", "y"}, table({"x", "y"}))
    assert.same(table {"x", "y"}, table("x", "y"))
    assert.same(table {a="x"}, table({a="x"}))
  end)
  it("insert()", function()
    local o = table({"x", "y"})
    assert.is_function(table.append)
    assert.is_function(o.append)
    assert.equal(table.append, o.append)
    assert.is_nil(table.insert(o, nil))
    assert.is_table(o:append("q"))
    assert.same(table {"x", "y", "q"}, o)
  end)
  it("remove()", function()
    local r = table {"x", "y", "z"}
    assert.same("z", r:remove())
    assert.same("y", r:remove(2))
    assert.same(table {"x"}, r)
  end)
  it("callable", function()
    local x = table {"x", "y"}
    assert.equal(x, table.callable(x))
    assert.equal(x, table.callable(nil, x))
    assert.equal(x, table.callable(nil, x, meta))
    assert.equal(meta, table.callable(nil, meta, x))
  end)
  it("maxi", function()
    assert.is_nil(table.maxi())
    assert.equal(2, table.maxi({"x", "y"}))
    assert.equal(2, table.maxi(table {"x", "y"}))
    assert.equal(0, table.maxi(table {}))
    assert.equal(1, table.maxi(table {"a"}))
    assert.equal(3, table.maxi(table {"a", nil, "x"}))
--    assert.equal(3, #(table {"a", nil, "x"}))
    assert.equal(3, table.maxi({"a", nil, "x", a=1}))
    assert.equal(3, table.maxi({b=2, "a", nil, "x", a=1}))
  end)
  it("empty", function()
    assert.is_nil(table.empty())
    assert.is_true(table.empty({}))
    assert.is_true(table.empty({nil}))
    assert.is_false(table.empty({"x"}))
    assert.is_false(table.empty({a="x"}))
  end)
  it("indexed", function()
    assert.is_nil(table.indexed())
    assert.is_true(table.indexed({"x", "y"}))
    assert.is_true(table.indexed(table {"x", "y"}))
    assert.is_false(table.indexed(table {}))
    assert.is_true(table.indexed(table {"a"}))
    assert.is_true(table.indexed(table {"a", nil, "x"}))
    assert.is_true(table.indexed({"a", nil, "x", a=1}))
    assert.is_true(table.indexed({b=2, "a", nil, "x", a=1}))
    assert.is_false(table.indexed({b=2}))
    assert.is_false(table.indexed({b=2, a=1}))
  end)
  it("unindexed", function()
    assert.is_nil(table.unindexed())
    assert.is_false(table.unindexed({"x", "y"}))
    assert.is_false(table.unindexed(table {"x", "y"}))
    assert.is_false(table.unindexed(table {}))
    assert.is_false(table.unindexed(table {"a"}))
    assert.is_false(table.unindexed(table {"a", nil, "x"}))
    assert.is_false(table.unindexed({"a", nil, "x", a=1}))
    assert.is_false(table.unindexed({b=2, "a", nil, "x", a=1}))
    assert.is_true(table.unindexed({b=2}))
    assert.is_true(table.unindexed({b=2, a=1}))
  end)
  it("copy", function()
    assert.same({}, table():copy())
    assert.same({}, table({}):copy())
    assert.same({}, table {}:copy())
    local o = table {"x", "y", {"a", "b", {"q", "w", "e"}}}
    local c = o:copy()
    assert.same(c, o)
  end)
  it("clone", function()
    assert.same({}, table():clone())
    assert.same({}, table({}):clone())
    assert.same({}, table {}:clone())
    local o = table {"x", "y", {"a", "b", {"q", "w", "e"}}}
    local c = o:clone()
    assert.same(c, o)
  end)
  describe("map", function()
    it("nil/wrong", function()
      assert.same(table(), table.map())
      assert.same(table(), table.map(nil))
      assert.same(table(), table.map(nil, nil))
      assert.same(table(), table.map({}))
      assert.same(table(), table.map(table()))
      assert.same(table(), table.map(table({})))
      assert.same(table(), table.map({}, tostring))
      assert.same(table(), table.map(table(), tostring))
      assert.same(table(), table.map(table({}), tostring))
      assert.same(table(), table.map(table({}), 'tostring'))
    end)
    it("table", function()
      local b = table({"x", "y", "z"})
      assert.same({"x", "y", "z"}, b:map())
      assert.same(b, b:map())
      assert.same({"x", "y", "z"}, b:map(tostring))
      assert.same(b, b:map('tostring'))
      assert.same(b, table.map(b))
      assert.same(b, table.map(b, tostring))
      assert.same(b, table.map(b, 'tostring'))
    end)
    it("make_filter", function()
      local f = table.make_filter(function(x, ...) return x~='init.lua' end)
      assert.equal('sunny', f('sunny'))
      assert.is_nil(f('init.lua'))
    end)
    it("iterator", function()
      local data = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
      local fn = function(x) return data[x] end
      local b = table.map(table.range(10), fn)

      assert.same({}, table.map(function() return nil end))
      assert.same({'1', '2', '3'}, table.map(table.range(3), fn))
      assert.same(data, table.map(table.range(10), fn))
      assert.same(b, table.map(table.range(10), fn))

      local module = meta.module('testdata.loader')
      assert.same_values({'failed', 'dot', 'ok'}, module.mods)
      assert.same_values({'failed.lua', 'init.lua'}, table.map(module.iterfiles))

      assert.same({'failed.lua'}, table.map(module.iterfiles, function(x) if x~='init.lua' then return x end end))
    end)
  end)
  it("filter", function()
    local not_nil = function(x) return x ~= nil end
    local withnil = table {"x", nil, "y", nil, "z"}
    assert.same({"x", "y", "z"}, withnil:filter(not_nil))
    assert.same({'failed.lua'}, table.map(meta.module('testdata.loader').iterfiles, function(x) if x~='init.lua' then return x end end))
  end)
  it("flatten", function()
    assert.same({}, table {}:flatten())
    assert.same({}, table ({}):flatten())
    assert.same({}, table ():flatten())
    assert.same({"x"}, table({"x"}):flatten())
    assert.same({"x", "y"}, table {"x", "y"}:flatten())
    assert.same({"x", "a", "b", "y"}, table {"x", {"a", "b"}, "y"}:flatten())
    assert.same({"x", "y", "a", "b", "q", "w", "e"}, table {"x", "y", {"a", "b", {"q", "w", "e"}}}:flatten())
  end)
  it("size", function()
    assert.equal(0, table():size())
    assert.equal(0, table():size(nil))
    assert.equal(0, table({}):size())

    assert.equal(1, table {"x"}:size())
    assert.equal(3, table {"x", "y", "z"}:size())
    assert.equal(2, table {"x", "y"}:size())
    assert.equal(3, table {"x", "y", "z"}:size())

    assert.equal(1, table {a="x"}:size())
    assert.equal(3, table {a="x", "y", "z"}:size())
    assert.equal(2, table {"x", a="y"}:size())
    assert.equal(3, table {"x", x="x", "z"}:size())
  end)
  it("limit", function()
    assert.same({"x", "y", "z"}, table {"x", "y", "z"}:limit(4))
    assert.same({"x"}, table {"x", "y", "z"}:limit(1))
    assert.same({"x", "y", "z"}, table {"x", "y", "z"}:limit())
  end)
  it("trim", function()
    local to = {"x", "q"}
    assert.is_function(table.trim)
    assert.same(to, table.trim({" x ", " q "}))
    assert.same(to, table {" x ", " q "}:trim())
    assert.same(to, table {" x ", " q "}:trim())
    assert.same(to, table {"x ", " q"}:trim())
    assert.same({"long enough", "also long"}, table {" long enough ", " also long   "}:trim())
  end)
  it("lower", function()
    assert.same(table {}, table {}:lower())
    assert.same(table {"x", "y"}, table {"X", "Y"}:lower())
    assert.same(table {"x", "y"}, table {"x", "y"}:lower())
    assert.same(table {"x", "y", 5}, table {"X", "Y", 5}:lower())
  end)
  it("match", function()
    assert.same(table {"x", "q"}, table(" x ", " q "):match("(%w+)"))
    assert.same(table {"x", "q"}, table({" x ", " q "}):match("(%w+)"))
    assert.same(table {"x", "q"}, table {" x ", " q "}:match("(%w+)"))
    assert.same(table {"x", "q"}, table {" x ", " q ", " q. "}:match("(%w+)%s"))
    assert.same(table {"x"}, table {" x ", " q. "}:match("(%w+)%s"))
    assert.same(table {"x", "x", "q."}, table {" x ", " q. "}:match("(%w+)%s", "(%S+)%s"))
  end)
  it("first/last", function()
    assert.same("x", table {"x", "y", "z"}:first())
    assert.same("x", table {"x", "y", "z"}:first("other"))
    assert.same("z", table {"x", "y", "z"}:last())
    assert.same("z", table {"x", "y", "z"}:last("other"))
    assert.is_nil(table {}:first())
    assert.is_nil(table {}:last())
    assert.same("some", table {}:first("some"))
    assert.same("some", table {}:last("some"))
  end)
  it("pop", function()
    local o = table {"x", "y", "z"}
    assert.same("z", o:pop())
    assert.same({"x", "y"}, o)
    assert.same("y", o:pop())
    assert.same({"x"}, o)
    assert.same("x", o:pop())
    assert.same({}, o)
    assert.is_nil(o:pop())
    assert.same({}, o)
  end)
  it("reverse()", function()
    assert.same(table {}, table {}:reverse())
    assert.same(table {"x"}, table {"x"}:reverse())
    assert.same(table {"y", "x"}, table {"x", "y"}:reverse())
    assert.same(table {"z", "y", "x"}, table {"x", "y", "z"}:reverse())
    assert.same(table {"q", "a", "y", "x"}, table {"x", "y", "a", "q"}:reverse())
    assert.same(table {"w", "q", "a", "y", "x"}, table {"x", "y", "a", "q", "w"}:reverse())
  end)
  it("findvalue()", function()
    assert.truthy(table {"x", "y", "z"}:findvalue("x"))
    assert.is_nil(table {"x", "y", "z"}:findvalue("q"))
    assert.is_nil(table {"x", "y", "z"}:findvalue(nil))
    assert.is_nil(table {"x", "y", "z"}:findvalue())
  end)
  it("any", function()
    assert.falsy(table.any())
    assert.falsy(table():any())
    assert.falsy(table {}:any())
    assert.falsy(table():any("x"))
    assert.falsy(table {}:any("x"))
    assert.truthy(table {"x"}:any("x"))
    assert.truthy(table {"x", "x", "x"}:any("x"))
    assert.truthy(table {"y", "x", "x"}:any("x"))
    assert.truthy(table {"y", "z", "x"}:any("x"))
    assert.truthy(table {"x", "y", "z"}:any("x"))
    assert.falsy(table {"x", "y", "z"}:any("q"))
    assert.falsy(table {"x", "y", "z"}:any(nil))
    assert.falsy(table {"x", "y", "z"}:any())
    assert.truthy(table {"y", "z", "x", "t"}:any("x", "t"))
    assert.truthy(table {"y", "z", "x", "t"}:any({"x", "t"}))
  end)
  it("all", function()
    assert.is_true(table.all())
    assert.is_true(table():all())
    assert.is_true(table {}:all())
    assert.is_true(table():all("x"))
    assert.is_true(table {}:all("x"))
    assert.truthy(table {"x"}:all("x"))
    assert.truthy(table {"x", "x", "x"}:all("x"))
    assert.falsy(table {"x", "y", "z"}:all("x"))
    assert.falsy(table {"x", "y", "z"}:all("q"))
    assert.falsy(table {"x", "y", "z"}:all(nil))
    assert.falsy(table {"x", "y", "z"}:all())
    assert.is_true(table {"x", "y", "y", "x", "y"}:all("x", "z", "y"))
    assert.is_true(table {"x", "y", "z"}:all("x", "z", "y"))
  end)
  it("append_unique()", function()
    assert.same(table {"z"}, table {}:append_unique("z"))
    assert.same(table {"z"}, table {}:append_unique("z"):append_unique("z"))
    assert.same(table {"x", "y", "z"}, table {"x", "y"}:append_unique("z"))
    assert.same(table {"x", "y"}, table {"x", "y"}:append_unique(nil))
    assert.same(table {"x", "y"}, table {"x", "y"}:append_unique())
  end)
  it("append()", function()
    assert.same(table {"x", "y", "z"}, table {"x", "y"}:append("z"))
    assert.same(table {"x", "y", "z", "z"}, table {"x", "y"}:append("z"):append("z"))
    assert.same(table {"x", "y"}, table {"x", "y"}:append(nil))
    assert.same(table {"x", "y"}, table {"x", "y"}:append())
    assert.same(table {}, table {}:append(nil))
    assert.same(table {}, table {}:append())
  end)
  it("delete", function()
    assert.same({"z"}, table({"x", "y", "z"}):delete(2, 1))
    assert.same({"y"}, table({"x", "y", "z"}):delete(3, 1))
  end)
  describe("update", function()
    it("nil", function()
      local t = table {a="x", b="y", c="z"}
      local y = table.clone(t)
      assert.is_nil(table.update())
      assert.is_nil(table.update(nil))
      assert.is_nil(table.update(nil, nil))

      assert.same(y, t:update())
      assert.same(y, t:update(nil))
      assert.same(y, t:update({}))
    end)
    it("valid values", function()
      assert.same({a="x", b="y", c="z"}, table():update({a="x", b="y", c="z"}) )
      assert.same({a="x", b="y", c="z"}, table({}):update({a="x", b="y", c="z"}) )

      assert.same({a="x", b="y", c="z"}, table({a='x'}):update({a="x", b="y", c="z"}, {c='z'}) )
      assert.same({a="x", b="y", c="zz"}, table({a='xx'}):update({a="x", b="y", c="z"}, {c='zz'}) )

      assert.same({a="x", b="y", c="z", d='t'}, table({a="x", b="y", c="z"}):update({d='t'}))
      assert.same({a="x", b="y", c="z", d='d'}, table({a="x", b="y", c="z"}):update({d='t'}):update({d='d'}))
      assert.same({"x", "y", "z", "t"}, table({"x", "y", "z"}):update({"t"}))
    end)
  end)
  it("range", function()
    assert.same({1,2,3,4,5,6}, table.map(table.range(6)))
    assert.same({4,5,6,7,8}, table.map(table.range(4, 8)))
    assert.same({40,50,60,70,80}, table.map(table.range(40, 80, 10)))
  end)
  it("iter + map", function()
    local vv = table({"x", "y", "z"})
    assert.same({"x", "y", "z"}, table.map(vv))
    assert.same(vv, table.map(table.ivalues(vv)))
    local o = {[1] = "Q", [2] = "W", [3] = "E", ["some"] = "R"}
    assert.same({"R"}, table.map(table.values(o)))
    assert.same({"Q", "W", "E"}, table.map(table.ivalues(o)))
    assert.same({"some"}, table.map(table.keys(o)))
    assert.same({1, 2, 3}, table.map(table.ikeys(o)))
    assert.same({"x", "y", "z", "a", "b", "c", "d", "e"}, table.map(table.iter(table({"x", "y", "z", "a", "b", "c", "d", "e"}), true, false)) )
  end)
  it("keys", function()
    local a = table(3, 2, 1)
    local b = table({"x", "y", "z"})
    assert.same(b, table.map(b, tostring))
    for k in table.keys(b) do assert.equal(a:remove(), k) end
    local c = table({})
    assert.same(c, table.map(c, tostring))
    local d = table()
    assert.same(d, table.map(d, tostring))
  end)
  it("ivalues", function()
    local b = table({"a", "b", "c", "d", "e", q="q", w="w", e="e", r="r"})
    local iv = table({})
    local i = 1
    for v in b:ivalues() do
      iv[i]=v
      assert.equal(b[i], v)
      i = i + 1
    end
    i = 1
    for k,v in ipairs(b) do
      assert.equal(i, k)
      assert.equal(iv[i], v)
      i = i + 1
    end
  end)
  it("tohash", function()
    assert.same({}, table():tohash())
    assert.same({}, table {}:tohash())
    assert.same({x = true}, table {"x"}:tohash())
    assert.same({x = true}, table {"x", "x"}:tohash())
    assert.same({x = true, y = true}, table {"x", "y", "x"}:tohash())
    assert.same({x = true, y = true, z = true}, table {"z", "y", "x"}:tohash())

    assert.same({x = 1}, table {"x"}:tohash(1))
  end)
  describe("coalesce", function()
    it("handles normal values", function()
      assert.equal(true, table.coalesce(true, 1, 2), '1')
      assert.equal(false, table.coalesce(false, 1, 2), '2')
      assert.equal(1, table.coalesce(nil, 1, 2), '3')
    end)
    it("handles nils", function()
      assert.is_nil(table.coalesce())
      assert.equal(nil, table.coalesce())
      assert.equal(nil, table.coalesce(nil))
      assert.equal(nil, table.coalesce(nil, nil))
      assert.equal(nil, table.coalesce(nil, nil, nil))

      assert.equal(true, table.coalesce(true, nil, 2))
      assert.equal(2, table.coalesce(nil, nil, 2))
      assert.equal(true, table.coalesce(true, 1, nil))
      assert.equal(1, table.coalesce(nil, 1, nil))
    end)
  end)
  describe("zcoalesce", function()
    it("handles normal values", function()
      assert.equal(true, table.zcoalesce(true, 1, 2), '1')
      assert.equal(1, table.zcoalesce(false, 1, 2), '2')
      assert.equal(1, table.zcoalesce(nil, 1, 2), '3')
    end)
    it("handles nils", function()
      assert.is_nil(table.zcoalesce())
      assert.equal(nil, table.zcoalesce())
      assert.equal(nil, table.zcoalesce(nil))
      assert.equal(nil, table.zcoalesce(nil, nil))
      assert.equal(nil, table.zcoalesce(nil, nil, nil))

      assert.equal(true, table.zcoalesce(true, nil, 2))
      assert.equal(2, table.zcoalesce(nil, nil, 2))
      assert.equal(true, table.zcoalesce(true, 1, nil))
      assert.equal(1, table.zcoalesce(nil, 1, nil))
    end)
  end)
  it("__add / multi add", function()
    assert.same(table {"x", "y", "a"}, table {"x", "y"} + "a")
    assert.same(table {"x", "y", "a", "b"}, table {"x", "y"} + "a" + "b")
  end)
  it("__sub", function()
    assert.same(table {"x", "y"}, table {"x", "y", "a"} - {3})
    assert.same(table {"x", "y"}, table {"x", "y", a = "a"} - {"a"})
    assert.same(table {"x", "y"}, table {"x", "y", a = "a"}:delete("a"))
  end)
  it("__concat / multi concat", function()
    assert.same(table({"x", "y", "a", "b", "c"}), table({"x", "y"}) .. table({"a", "b"}) .. table({"c"}))
    assert.same(table {"x", "y", "a", "b"}, table {"x", "y"} .. table {"a", "b"})
    assert.same(table {"x", "y", a = {}}, table {"x", "y"} .. table {a = {}})
    assert.same(table {"x", "y", __a='AAA'}, table {"x", "y", __a='AAA'} .. table {__a = 'BBB'})
  end)
  describe("__eq", function()
    it("table", function()
      assert.is_true(table({"x", "y", "a", "b", "c"}) == table({"x", "y", "a", "b", "c"}), '1')
      assert.same(table({"x", "y", "a", "b", "c"}), (table({"x", "y"}) .. table({"a", "b"}) .. table({"c"})), '1')
      assert.is_true(table {"x", "y", "a", "b"} == (table({"x", "y"}) .. table({"a", "b"})), '2')
      assert.same(table({"x", "y", a = {}}), (table{"x", "y"} .. table {a = {}}), '3')
    end)
    it("cloned", function()
      local mt = meta.mt

      local x = table {"x"}
      assert.is_table(x)
      local yes = true

      assert.is_true(mt(x).__eq(x, yes))
      assert.is_true(mt(x).__eq(x, true))

      assert.is_false(x==yes)
      assert.is_false(x==true)
      assert.is_false(x==false)

      assert.is_true(toboolean(x))
      assert.is_true(toboolean(x)==true)
    end)
  end)
end)
