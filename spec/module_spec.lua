describe('module', function()
  local module
  setup(function()
    require "compat53"
    require "testdata.asserts"
    module = require "meta.module"
  end)
  it("self", function()
    assert.is_table(module('meta.loader'))
  end)
  it("meta", function()
    assert.is_table(module)
    local m = module('meta')
    assert.is_table(m)
    assert.equal('meta', m.origin)
    assert.equal('meta', m.name)
    assert.ends('meta/init.lua', m.file)
    assert.ends('meta', m.dir)
  end)
  it("meta.loader", function()
    local m = module('meta.loader')
    assert.is_table(m)
    assert.equal('meta/loader', m.name)
    assert.ends('meta/loader.lua', m.file)
    assert.ends('meta/loader.lua', m.path)
  end)
  it("testdata.loader.noinit", function()
    local m = module('testdata.loader.noinit')
    assert.is_table(m)
    assert.equal('testdata/loader/noinit', m.name)
    assert.is_nil(m.file)
    assert.ends('testdata/loader/noinit', m.path)
  end)
  it("module.noneexistent", function()
    assert.equal('testdata/noneexistent', module('testdata/noneexistent').name)
    assert.equal('testdata/noneexistent', module(module('testdata/noneexistent')).name)
    assert.is_nil(module('testdata/noneexistent').path)
  end)
  it("path", function()
    assert.ends('meta/init.lua', module('meta').path)
    assert.ends('meta/loader.lua', module('meta.loader').path)
    assert.ends('testdata/init1/file.lua', module('testdata/init1/file').path)
    assert.ends('testdata/init1/dirinit/init.lua', module('testdata/init1/dirinit').path)
    assert.ends('testdata/init1/filedir.lua', module('testdata/init1/filedir').path)
    assert.ends('testdata/init1/all.lua', module('testdata/init1/all').path)

    assert.ends('testdata/init1/dir', module('testdata/init1/dir').path)
    assert.ends('testdata/init1/init.lua', module('testdata/init1').path)

    assert.ends('init2/init.lua', module('testdata.init2').path)
    assert.ends('init2/dir', module('testdata.init2.dir').path)
    assert.ends('init2/dirinit/init.lua', module('testdata.init2.dirinit').path)
  end)

  it("key", function()
    assert.equal('meta', module('meta').origin)
    assert.equal('testdata/init1/file', module('testdata/init1/file').name)
  end)
  it(".name", function()
    assert.equal('meta', module('meta').name)
    assert.equal('meta/loader', module('meta.loader').name)
    assert.equal('testdata/init1/file', module('testdata.init1.file').name)
    assert.equal('testdata/init1/dir', module('testdata.init1.dir').name)
    assert.equal('testdata/init1/dirinit', module('testdata.init1.dirinit').name)
    assert.equal('testdata/init1/filedir', module('testdata.init1.filedir').name)
    assert.equal('testdata/init1/all', module('testdata.init1.all').name)

    assert.equal('init2', module('init2').name)
    assert.equal('init2/file', module('init2.file').name)
    assert.equal('init2/dir', module('init2.dir').name)
    assert.equal('init2/dirinit', module('init2.dirinit').name)
    assert.equal('init2/filedir', module('init2.filedir').name)
    assert.equal('init2/all', module('init2.all').name)
  end)
  it(".file", function()
    assert.ends('meta/init.lua', module('meta').file)
    assert.ends('meta/loader.lua', module('meta.loader').file)
    assert.ends('testdata/init1/file.lua', module('testdata/init1/file').file)
    assert.equal(nil, module('testdata/init1/dir').file)
    assert.ends('testdata/init1/dirinit/init.lua', module('testdata/init1/dirinit').file)
    assert.ends('testdata/init1/filedir.lua', module('testdata/init1/filedir').file)
    assert.ends('testdata/init1/all.lua', module('testdata/init1/all').file)

    assert.ends('init2/init.lua', module('testdata.init2').file)
    assert.ends('init2/file.lua', module('testdata.init2.file').file)
    assert.is_nil(module('init2.dir').file)
    assert.ends('init2/dirinit/init.lua', module('testdata.init2.dirinit').file)
    assert.ends('init2/filedir.lua', module('testdata.init2.filedir').file)
    assert.ends('init2/all.lua', module('testdata.init2.all').file)
  end)
  it(".path", function()
    assert.ends('meta/init.lua', module('meta').path)
    assert.ends('meta/loader.lua', module('meta.loader').path)
    assert.ends('testdata/init1/file.lua', module('testdata/init1/file').path)
    assert.ends('testdata/init1/dirinit/init.lua', module('testdata/init1/dirinit').path)
    assert.ends('testdata/init1/filedir.lua', module('testdata/init1/filedir').path)
    assert.ends('testdata/init1/all.lua', module('testdata/init1/all').path)

    assert.ends('testdata/init1/dir', module('testdata/init1/dir').path)
    assert.ends('testdata/init1/init.lua', module('testdata/init1').path)

    assert.ends('init2/init.lua', module('testdata.init2').path)
    assert.is_nil(module('testdata.init2.path').path)
    assert.ends('init2/dir', module('testdata.init2.dir').path)
    assert.ends('init2/dirinit/init.lua', module('testdata.init2.dirinit').path)
    assert.ends('init2/filedir.lua', module('testdata.init2.filedir').path)
    assert.ends('init2/all.lua', module('testdata.init2.all').path)
  end)
  it(".dir", function()
    assert.ends('meta', module('meta').dir)
    assert.is_nil(module('meta.loader').dir)
    assert.is_nil(module('testdata/init1/file').dir)
    assert.ends('testdata/init1/dir', module('testdata/init1/dir').dir)
    assert.ends('testdata/init1/dirinit', module('testdata/init1/dirinit').dir)
    assert.ends('testdata/init1/filedir', module('testdata/init1/filedir').dir)
    assert.ends('testdata/init1/all', module('testdata/init1/all').dir)

    assert.ends('init2', module('testdata.init2').dir)
    assert.ends('init2/dir', module('testdata.init2.dir').dir)
    assert.ends('init2/dir', module('testdata.init2/dir').dir)
    assert.ends('init2/dirinit', (module('testdata.init2.dirinit') or {}).dir)
    assert.ends('init2/filedir', module('testdata.init2.filedir').dir)
    assert.ends('init2/all', module('testdata.init2.all').dir)
  end)
  it(".basename", function()
    assert.equal('meta', module('meta').basename)
    assert.equal('loader', module('meta.loader').basename)
    assert.equal('file', module('testdata/init1/file').basename)
    assert.equal('dir', module('testdata/init1/dir').basename)
    assert.equal('dirinit', module('testdata/init1/dirinit').basename)
    assert.equal('filedir', module('testdata/init1/filedir').basename)
    assert.equal('all', module('testdata/init1/all').basename)

    assert.equal('init2', module('testdata.init2').basename)
    assert.equal('file', module('testdata.init2.file').basename)
    assert.equal('dir', module('testdata.init2.dir').basename)
    assert.equal('dirinit', module('testdata.init2.dirinit').basename)
    assert.equal('filedir', module('testdata.init2.filedir').basename)
    assert.equal('all', module('testdata.init2.all').basename)
  end)
  it(".isroot", function()
    assert.is_true(module('meta').isroot)
    assert.is_false(module('meta.loader').isroot)
    assert.is_false(module('testdata/init1/file').isroot)
    assert.is_false(module('testdata/init1/dir').isroot)
    assert.is_false(module('testdata/init1/dirinit').isroot)
    assert.is_false(module('testdata/init1/filedir').isroot)
    assert.is_false(module('testdata/init1/all').isroot)

    assert.is_true(module('init2').isroot)
    assert.is_false(module('init2.file').isroot)
    assert.is_false(module('init2.dir').isroot)
    assert.is_false(module('init2.dirinit').isroot)
    assert.is_false(module('init2.filedir').isroot)
    assert.is_false(module('init2.all').isroot)
  end)
  it(".files", function()
    assert.is_table(module('meta').files)
  end)
  it(".dirs", function()
    assert.is_table(module('testdata.ok').dirs)
  end)
  it(".parent", function()
    assert.same(module('meta'), module('meta.loader').parent)
    assert.equal(module('meta'), module('meta.loader').parent)
  end)
  it(".sub()", function()
    assert.same(module('meta/loader').name, module('meta'):sub('loader').name)
    assert.equal(module('meta/loader').name, module('meta'):sub('loader').name)
    assert.equal(module('meta/loader'), module('meta'):sub('loader'))
    assert.equal(module('testdata/loader/noneexistent'), module('testdata/loader'):sub('noneexistent'))
  end)
  it(".load ok and test cache", function()
    local m = module('testdata.loader.ok.message')
    assert.truthy(m.exists)
    assert.is_table(m.load)
    assert.is_nil(m.error)
    assert.equal('ok', m.load.data)
    assert.truthy(m.loaded)
  end)
  it(".load failed", function()
    local m = module('testdata.loader.failed')
    assert.truthy(m.exists)
    assert.is_nil(m.load)
  end)
  it("loader", function()
    local mod = module('testdata/init1')
    assert.is_table(mod.loader)
    assert.is_true(mod.recursive.torecursive)
    assert.same({'file', 'all', 'filedir'}, mod.files)
    assert.same({'all','dirinit','dir','filedir'}, mod.dirs)
    assert.same({'file','all','dirinit','dir','filedir'}, {table.unpack(mod.files), table.unpack(mod.dirs)})
    assert.same({'file','all','dirinit','dir','filedir'}, mod.submodules)

    mod = module('testdata.init3')
    assert.is_table(mod)
    assert.is_table(mod.loader)
    assert.is_table(mod.recursive.preload)
    assert.is_true(mod.torecursive)

    _ = mod.loader.a
    assert.equal(mod.loader, mod.loader)
    assert.equal(mod.loader, mod.recursive.loader)
  end)
end)
