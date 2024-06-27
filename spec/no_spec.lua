describe('no', function()
  local no, cache
  setup(function()
    require "compat53"
    require "meta.assert"
    cache = require "meta.cache"
    no = require "meta.no"
  end)
  describe("computed", function()
    it("nil", function()
      assert.is_nil(no.computed({}))
      assert.is_nil(no.computed({}, nil))
      assert.is_nil(no.computed({}, 7))
      assert.is_nil(no.computed({}, true))
      assert.is_nil(no.computed({}, 'x'))
      assert.is_nil(no.computed({a=function(...) return 777 end}, 'a'))
    end)
    it("value", function()
      assert.is_function(no.computed(setmetatable({}, {a=function(...) return 777 end}), 'a'))

      local t = setmetatable({}, {x=function(...) return 999 end, __computed={a=function(...) return 777 end}, __computable={b=function(...) return 888 end}})
      assert.is_function(no.computed(t, 'x'))

      assert.equal(888, no.computed(t, 'b'))
      assert.is_nil(rawget(t, 'b'))
      assert.is_nil(t.b)

      assert.equal(777, no.computed(t, 'a'))
      assert.equal(777, rawget(t, 'a'))
      assert.equal(777, t.a)
    end)
  end)
  describe("computable", function()
    it("nil", function()
      assert.is_nil(no.computable())
      assert.is_nil(no.computable(nil))
      assert.is_nil(no.computable(nil, nil))
      assert.is_nil(no.computable(nil, nil, nil))
      assert.is_nil(no.computable(nil, nil, 'a'))
      assert.is_nil(no.computable(nil, {}, nil))
      assert.is_nil(no.computable(nil, {}, 'a'))
      assert.is_nil(no.computable(nil, {a=888}, 'a'))
    end)
    it("value", function()
      assert.equal(777, no.computable(nil, {a=function(...) return 777, 888 end}, 'a'))
      assert.same({777, 888}, {no.computable(nil, {a=function(...) return 777, 888 end}, 'a')})
    end)
  end)
  describe("callable", function()
    it("nil", function()
      assert.is_nil(no.callable())
      assert.is_nil(no.callable(nil))
      assert.is_nil(no.callable(nil, nil))
      assert.is_nil(no.callable(nil, nil, nil))
    end)
    it("wrong", function()
      assert.is_nil(no.callable(7))
      assert.is_nil(no.callable('something'))
      assert.is_nil(no.callable(true))
      assert.is_nil(no.callable(false))
    end)
    describe("ok", function()
      it("x", function()
        local x = table {"x", "y"}
        assert.equal(x, no.callable(x))
        assert.equal(x, no.callable(nil, x))
        assert.equal(x, no.callable(nil, x, cache))
      end)
      it("cache", function()
        local x = table {"x", "y"}
        assert.equal(cache, no.callable(cache))
        assert.equal(cache, no.callable(cache, x))
        assert.equal(cache, no.callable(nil, cache, x))
      end)
      it("string.format", function()
        assert.equal(string.format, no.callable(string.format))
        assert.equal(string.format, no.callable(nil, string.format))
        assert.equal(string.format, no.callable(nil, string.format, cache))
      end)
    end)
  end)
  describe("hasvalue", function()
    it("nil or wrong", function()
      assert.is_false(no.hasvalue())
      assert.is_false(no.hasvalue(nil))
      assert.is_false(no.hasvalue(nil, nil))
      assert.is_false(no.hasvalue(nil, nil, nil))
      assert.is_false(no.hasvalue({}, nil))
      assert.is_false(no.hasvalue(nil, 'some'))
      assert.is_false(no.hasvalue({}, 'some'))
    end)
    it("valid true", function()
      assert.is_true(no.hasvalue({'a'}, 'a'))
      assert.is_true(no.hasvalue({'a', 'b'}, 'a'))
      assert.is_true(no.hasvalue({'a', 'b'}, 'b'))
      assert.is_true(no.hasvalue({a='a'}, 'a'))
      assert.is_true(no.hasvalue({a='a', b='b'}, 'a'))
      assert.is_true(no.hasvalue({a='a', b='b'}, 'b'))
      assert.is_true(no.hasvalue({'a', 'b', a='a'}, 'a'))
    end)
    it("valid false", function()
      assert.is_false(no.hasvalue({'a'}, 'b'))
      assert.is_false(no.hasvalue({'a', 'b'}, 'c'))
      assert.is_false(no.hasvalue({a='a'}, 'b'))
      assert.is_false(no.hasvalue({a='a', b='b'}, 'c'))
      assert.is_false(no.hasvalue({'a', 'b', a='a'}, 'c'))
    end)
  end)
  describe("join", function()
    it("nil", function()
      assert.is_nil(no.join())
      assert.is_nil(no.join(nil))
      assert.is_nil(no.join(nil, nil))
      assert.is_nil(no.join(nil, nil, nil))
    end)
    it("value", function()
      assert.equal('a' .. no.sep .. 'b', no.join('a', 'b'))
      assert.equal('a' .. no.sep .. 'b', no.join('a/', 'b'))
      assert.equal('a' .. no.sep .. 'b', no.join('a', '/b'))
      assert.equal('a' .. no.sep .. 'b', no.join('a/', '/b'))
    end)
    it("with empty", function()
      assert.equal('a' .. no.sep .. '', no.join('a', ''))
      assert.equal('a' .. no.sep .. '', no.join('a/', ''))
      assert.equal('' .. no.sep .. 'b', no.join('', '/b'))
      assert.equal('' .. no.sep .. 'b', no.join('/', '/b'))
    end)
  end)
  describe("save", function()
    it("nil", function()
      assert.is_nil(no.save())
      assert.is_nil(no.save(nil))
      assert.is_nil(no.save(nil, nil))
      assert.is_nil(no.save(nil, nil, nil))
      assert.is_nil(no.save({}, nil, nil))
      assert.is_nil(no.save({}, {}, nil))
      assert.is_nil(no.save(nil, {}, nil))
      assert.is_nil(no.save(nil, {}, {}))
      assert.is_nil(no.save(nil, nil, {}))
    end)
    it("value", function()
      local t = {}
      assert.equal('b', no.save(t, 'a', 'b'))
      assert.same({a='b'}, t)
      assert.equal('a', no.save(t, 'a', 'a'))
      assert.same({a='a'}, t)
      assert.equal(nil, no.save(t, 'a', nil))
      assert.same({a='a'}, t)
      assert.equal('b', no.save(t, 'a', 'b'))
      assert.same({a='b'}, t)
      assert.equal('y', no.save(t, 'x', 'y'))
      assert.same({a='b', x='y'}, t)
      assert.equal('b', no.save(t, 'a', 'b'))
      assert.same({a='b', x='y'}, t)
    end)
  end)
  it("path", function()
    assert.is_nil(cache.file())
    assert.is_nil(cache.file(nil))
    assert.ends('meta/init.lua', cache.file('meta'))
    assert.ends('testdata/loader/init.lua', cache.file('testdata.loader'))
    assert.ends('testdata/loader/init.lua', cache.file('testdata/loader'))
    assert.ends('testdata/loader/init.lua', cache.file('testdata', 'loader'))
    assert.is_nil(cache.file('testdata.loader', 'noinit'))
    assert.is_nil(cache.file('testdata/loader', 'noinit'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata.loader.noinit', 'message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata/loader/noinit', 'message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata.loader.noinit.message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata/loader/noinit/message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata.loader.noinit', 'message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata/loader/noinit', 'message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata.loader.noinit.message'))
    assert.ends('testdata/loader/noinit/message.lua', cache.file('testdata/loader/noinit/message'))
  end)
  describe('root', function()
    it("nil", function()
      assert.is_nil(no.root())
      assert.is_nil(no.root(nil))
      assert.is_nil(no.root(''))
    end)
    it(".lua", function()
      assert.equal('meta', no.root('meta/loader.lua'))
      assert.equal('meta', no.root('meta/loader/init.lua'))
    end)
    it("module", function()
      assert.equal('meta', no.root('meta'))
      assert.equal('meta', no.root('meta/'))
      assert.equal('meta', no.root('meta.'))
      assert.equal('meta', no.root('meta/.'))
      assert.equal('meta', no.root('meta./'))
      assert.equal('meta', no.root('meta/loader'))
      assert.equal('meta', no.root('meta.loader'))
      assert.equal('meta', no.root('meta.some/loader'))
      assert.equal('meta', no.root('meta/some.loader'))
      assert.equal('meta', no.root('meta/some.loader/some'))
      assert.equal('meta', no.root('meta/some.loader/some.any'))
    end)
  end)
  describe('parent', function()
    it("nil", function()
      assert.is_nil(no.parent())
      assert.is_nil(no.parent(nil))
      assert.is_nil(no.parent(''))
      assert.is_nil(no.parent('meta'))
    end)
    it(".lua", function()
      assert.ends('meta', no.parent('meta/loader.lua'))
      assert.ends('meta', no.parent('meta/loader/init.lua'))
    end)
    it("module", function()
      assert.ends('meta', no.parent('meta/loader'))
      assert.ends('meta', no.parent('meta.loader'))
      assert.ends('meta', no.parent('meta/some.loader'))
    end)
  end)
  describe('basename', function()
    it("nil", function()
      assert.is_nil(no.basename())
      assert.is_nil(no.basename(nil))
      assert.is_nil(no.basename(''))
    end)
    it(".lua", function()
      assert.ends('loader', no.basename('meta/loader.lua'))
      assert.ends('loader', no.basename('meta/loader/init.lua'))
    end)
    it("module", function()
      assert.ends('loader', no.basename('meta/loader'))
      assert.ends('loader', no.basename('meta.loader'))
      assert.ends('some.loader', no.basename('meta/some.loader'))
    end)
  end)
  it("dir", function()
    assert.is_nil(cache.dir())
    assert.is_nil(cache.dir(nil))
    assert.is_nil(cache.dir(''))
    assert.ends('meta', cache.dir('meta'))

    assert.ends('testdata/loader', cache.dir('testdata.loader'))
    assert.ends('testdata/loader', cache.dir('testdata/loader'))
    assert.ends('testdata/loader', cache.dir('testdata.loader'))
    assert.ends('testdata/loader', cache.dir('testdata/loader'))
    assert.ends('testdata/loader', cache.dir('testdata.loader'))

    assert.ends('testdata/loader', cache.dir('testdata', 'loader'))
    assert.ends('testdata/loader', cache.dir('testdata.loader'))
    assert.ends('testdata/loader', cache.dir('testdata.loader'))

    assert.ends('testdata/loader/noinit', cache.dir('testdata.loader', 'noinit'))

    assert.is_nil(no.searcher('testdata.loader.noinit'))

    assert.ends('testdata/loader/noinit', no.dir('testdata.loader', 'noinit'))
    assert.ends('testdata/loader/noinit', no.dir('testdata.loader', 'noinit'))
    assert.ends('testdata/loader/noinit', cache.dir('testdata/loader', 'noinit'))

    assert.truthy(cache.module('testdata/loader').load)
    assert.is_nil(no.searcher('testdata'))
    assert.ends('testdata', cache.dir('testdata'))
  end)
  describe('strip', function()
    describe('strip', function()
      it("basedir", function()
        assert.ends('meta', no.strip('meta/init', '%/[^/]*$'))
        assert.ends('meta', no.strip('meta/init.lua', '%/[^/]*$'))
        assert.ends('meta', no.strip('meta/', '%/[^/]*$'))
        assert.ends('meta', no.strip('meta/loader', '%/[^/]*$'))
        assert.ends('meta', no.strip('meta/loader', '[/.][^/.]*$'))
        assert.ends('meta', no.strip('meta.loader', '[/.][^/.]*$'))
      end)
      it(".lua", function()
        assert.ends('meta', no.strip('meta/init.lua', '%/init%.lua$'))
        assert.ends('meta.loader', no.strip('meta.loader/init.lua', '%/?init%.lua$'))
        assert.ends('meta.loader', no.strip('meta.loader/init.lua', '%/?init%.lua$', '.lua$'))
        assert.ends('meta/loader', no.strip('meta/loader.lua', '%/?init%.lua$', '.lua$'))
      end)
      it("nil", function()
        assert.is_nil(no.strip())
        assert.is_nil(no.strip(nil))
        assert.is_nil(no.strip(nil, nil))
        assert.is_nil(no.strip(nil, 'ok'))
        assert.is_nil(no.strip(''))
        assert.is_nil(no.strip('meta', 'meta'))
        assert.is_nil(no.strip('init.lua'))
      end)
      it("default", function()
        assert.ends('meta', no.strip('meta/init.lua'))
        assert.ends('meta.loader', no.strip('meta.loader/init.lua'))
        assert.ends('meta.loader', no.strip('meta.loader/init.lua'))
        assert.ends('meta/loader', no.strip('meta/loader.lua'))
      end)
    end)
  end)
  describe('searcher', function()
    it("nil", function()
      assert.is_nil(no.searcher())
      assert.is_nil(no.searcher(nil))
    end)
    it("or", function()
      assert.ends('meta/init.lua', no.searcher() or no.searcher('meta'))
      assert.ends('meta/init.lua', no.searcher(nil) or no.searcher('meta'))
      assert.ends('meta/init.lua', no.searcher('testdata.noneexistent') or no.searcher('meta'))
    end)
    it("meta", function() assert.ends('meta/init.lua', no.searcher('meta')) end)
    it("testdata.ok", function() assert.ends('testdata/ok/init.lua', no.searcher('testdata.ok')) end)
  end)
  describe('load', function()
    it("testdata.noloader1", function() assert.is_table(no.call(no.load('testdata/noloader/init.lua'))) end)
    it("testdata.noloader", function()
      local l = no.load('testdata.noloader')
      assert.is_function(l)
      assert.is_table(l())
      assert.equal('ok', l().message)
    end)
    it("nil", function()
      assert.is_nil(no.load(nil))
      assert.is_nil(no.load())
    end)
    it("noneexistent", function()
      assert.is_nil(no.load('testdata.noneexistent'))
    end)
  end)
  describe('loaded', function()
    it("testdata.noloader", function()
      _ = no.require('testdata.noloader')
      assert.equal('ok', (cache.loaded('testdata.noloader') or {}).message)
    end)
  end)
  describe('call', function()
    it("true", function()
      assert.no_error(function() return no.call(function() return true, 'error' end) end)
      assert.is_true(no.call(function() return true, 'error' end))
      assert.is_true(assert(no.call(function() return true, 'error' end)))
    end)
    it("false", function()
      assert.has_error(function() return assert(no.call(function() return false, 'error' end)) end)
      assert.is_false(no.call(function() return false, 'error' end))
      assert.equal('error', select(2, no.call(function() return false, 'error' end)))
    end)
    it("nil", function()
      assert.has_error(function() return assert(no.call(function() return nil, 'error' end)) end)
      assert.is_nil(no.call(function() return nil, 'error' end))
    end)
    it("assert+true", function()
      assert.no_error(function() return assert(no.assert(pcall(function() return true, 'error' end))) end)
      assert.is_true(assert(no.assert(pcall(function() return true, 'error' end))))
    end)
    it("other", function()
      assert.no_error(function() return assert(no.assert(pcall(function() return true, 'error' end))) end)
      assert.is_string(assert(no.call(function() return 'test', 'error' end)))
      assert.is_table(no.require("testdata.ok"))
    end)
  end)
  it("ok", function()
    assert.is_nil(no.require('testdata'))
    assert.not_nil(select(2, no.require('testdata')))
    assert.is_table(no.require("testdata.ok"))
  end)
  it("noneexistent", function()
    assert.is_nil(no.require('testdata.noneexistent'))
    assert.not_nil(select(2, no.require('testdata.noneexistent')))
  end)
  it("failed", function()
    assert.is_nil(no.require("testdata.failed"))
    assert.not_nil(select(2, no.require('testdata.failed')))
  end)
  it("or", function()
    assert.truthy(no.require('testdata.noneexistent') or no.require('testdata.ok'))
    assert.truthy(no.require('testdata.ok') or no.require('testdata.noneexistent'))
    assert.truthy(no.require('testdata.noneexistent') or no.require('os'))
    assert.truthy(no.require('os') or no.require('testdata.noneexistent'))
    assert.truthy((no.require('testdata.noneexistent') or no.require('os')).remove)
  end)
  describe('sub', function()
    it("nil", function()
      assert.is_nil(no.sub())
      assert.is_nil(no.sub(nil))
      assert.is_nil(no.sub(''))
    end)
    it("string", function()
      assert.ends('t', no.sub('t'))
      assert.ends('t/some', no.sub('t.some'))
      assert.ends('t/some', no.sub('t/some'))
      assert.ends('t/some', no.sub('t', 'some'))
      assert.ends('t/any/some', no.sub('t.any', 'some'))
      assert.ends('t/any/some', no.sub('t/any', 'some'))
      assert.ends('t/any/some.com', no.sub('t.any', 'some.com'))
      assert.ends('t/any/some.com', no.sub('t/any', 'some.com'))
      assert.ends('testdata/init1/file', no.sub('testdata/init1/file'))
      assert.ends('testdata/init1/file', no.sub('testdata.init1.file'))
    end)
  end)
  describe('unsub', function()
    it("nil", function()
      assert.is_nil(no.unsub())
      assert.is_nil(no.unsub(nil))
      assert.is_nil(no.unsub(''))
    end)
    it("string", function()
      assert.ends('t', no.unsub('t'))
      assert.ends('t.some', no.unsub('t.some'))
      assert.ends('t.some', no.unsub('t/some'))

      assert.ends('t.some', no.unsub('t', 'some'))

      assert.ends('t.any.some', no.unsub('t.any', 'some'))
      assert.ends('t.any.some', no.unsub('t/any', 'some'))

      assert.ends('t/any/some.com', no.unsub('t.any', 'some.com'))
      assert.ends('t/any/some.com', no.unsub('t/any', 'some.com'))
    end)
  end)
  describe('to', function()
    it("to", function()
      assert.ends('t', no.to('.', 't'))
      assert.ends('t', no.to('/', 't'))
      assert.ends('t.some', no.to('.', 't.some'))
      assert.ends('t/some', no.to('/', 't.some'))
      assert.ends('t.some', no.to('.', 't/some'))
      assert.ends('t/some', no.to('/', 't/some'))

      assert.ends('t.some', no.to('.', 't', 'some'))
      assert.ends('t/some', no.to('/', 't', 'some'))

      assert.ends('t.any.some', no.to('.', 't.any', 'some'))
      assert.ends('t/any/some', no.to('/', 't/any', 'some'))
      assert.ends('t/any/some', no.to('/', 't.any', 'some'))
      assert.ends('t.any.some', no.to('.', 't/any', 'some'))

      assert.ends('t/any/some.com', no.to('.', 't.any', 'some.com'))
      assert.ends('t/any/some.com', no.to('.', 't/any', 'some.com'))

      assert.ends('t/any/some.com', no.to('/', 't.any', 'some.com'))
      assert.ends('t/any/some.com', no.to('/', 't/any', 'some.com'))
    end)
  end)
  describe("isfile", function()
    it("cwd", function()
      assert.falsy(no.isfile(''))
      assert.falsy(no.isfile('.'))
    end)
    it("dir", function()
      assert.falsy(no.isfile('testdata'), 'testdata')
      assert.falsy(no.isfile('testdata/ok'), 'testdata/ok')
      assert.falsy(no.isfile('/'), '/')
      assert.falsy(no.isfile('/tmp'), '/tmp')
      assert.falsy(no.isfile('/var'), '/var')
      assert.falsy(no.isfile('testdata/loader/noinit'), 'testdata/loader/noinit')
      assert.falsy(no.isfile('testdata/loader/failed'), 'testdata/loader/failed')
    end)
    it("file", function() assert.truthy(no.isfile('testdata/test')) end)
    it("file.empty", function() assert.truthy(no.isfile('testdata/empty')) end)
    it("noneexistent", function() assert.is_nil(no.isfile('testdata/noneexistent')) end)
    it("dev_zero", function() assert.truthy(no.isfile('/dev/zero')) end)
    it("dev_zero", function() assert.truthy(no.isfile('/dev/null')) end)
  end)
  describe("isdir", function()
    it("cwd", function()
      assert.truthy(no.isdir(''))
      assert.truthy(no.isdir('.'))
    end)
    it("dir", function()
      assert.truthy(no.isdir('testdata'))
      assert.truthy(no.isdir('testdata/ok'))
      assert.truthy(no.isdir('/'))
      assert.truthy(no.isdir('/tmp'))
      assert.truthy(no.isdir('/var'))
      assert.truthy(no.isdir('testdata/loader/noinit'))
      assert.falsy(no.isdir('testdata/loader/failed'))
    end)
    it("value", function()
      assert.ends('testdata', no.isdir('testdata', true))
      assert.equal('testdata/ok', no.isdir('testdata/ok', true))
      assert.equal('/tmp', no.isdir('/tmp', true))
      assert.equal('/var/tmp', no.isdir('/var/tmp', true))
      assert.equal('testdata/loader/noinit', no.isdir('testdata/loader/noinit', true))
      assert.is_nil(no.isdir('testdata/loader/failed', true))
    end)
    it("file", function() assert.falsy(no.isdir('testdata/test')) end)
    it("file.empty", function() assert.falsy(no.isdir('testdata/empty')) end)
    it("noneexistent", function() assert.is_nil(no.isdir('testdata/noneexistent')) end)
    it("dev_zero", function() assert.falsy(no.isdir('/dev/zero')) end)
    it("dev_zero", function() assert.falsy(no.isdir('/dev/null')) end)
  end)
  describe('cache:load', function()
    local load=cache.load
    it("nil", function()
      assert.is_nil(load())
      assert.is_nil(load(nil))
      assert.is_nil(load(''))
    end)
    it("string", function()
      assert.is_nil(load('testdata/loader/noinit'))
    end)
  end)
  describe('mergevalues', function()
    it("nil", function()
      assert.same({}, no.mergevalues())
      assert.same({}, no.mergevalues(nil))
      assert.same({}, no.mergevalues({}))
      assert.same({}, no.mergevalues({}, {}))
    end)
    it("1", function()
      assert.same({'x'}, no.mergevalues({'x'}, {}))
      assert.same({'x'}, no.mergevalues({}, {'x'}))
      assert.same({'x'}, no.mergevalues({'x'}, {'x'}))
      assert.same({'x'}, no.mergevalues({}, {'x'}))
    end)
    it("2", function()
      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {}))
      assert.same({'x','y'}, no.mergevalues({'x'}, {'y'}))
      assert.same({'x','y'}, no.mergevalues({}, {'x', 'y'}))

      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {}))
      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {'x'}))
      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {'y'}))
      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {'x', 'y'}))
      assert.same({'x','y'}, no.mergevalues({'x', 'y'}, {'y', 'x'}))

      assert.same({'x','y'}, no.mergevalues({'x'}, {'x'}, {'y'}))
      assert.same({'x','y'}, no.mergevalues({'x'}, {'y'}, {'y'}))
    end)
  end)
  describe('typename', function()
    local meta = require "meta"
    local typename = cache.typename
    it("nil", function()
      assert.is_nil(typename[nil])
    end)
    it("typename", function()
      assert.equal('meta/no', typename[no])
      assert.equal('meta/cache', typename[cache])
      assert.equal('meta/loader', typename[meta.loader])
      assert.equal('meta/module', typename[meta.module])
    end)
  end)
end)
