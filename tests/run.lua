-- Standalone test runner. Run: lua tests/run.lua
-- Tests BoomForge's pure-Lua modules (Debug.lua, Registry.lua) outside the WoW
-- client, the same way VaultTracker/tests/run.lua tests its pure-logic modules.
local passed, failed = 0, 0

local function eq(actual, expected, msg)
  if actual == expected then passed = passed + 1
  else failed = failed + 1
    print(("FAIL: %s\n  expected %s, got %s"):format(msg, tostring(expected), tostring(actual)))
  end
end

local function ok(cond, msg)
  if cond then passed = passed + 1
  else failed = failed + 1
    print(("FAIL: %s"):format(msg))
  end
end

-- Asserts `fn()` raises an error, and (optionally) that the error message
-- contains `pattern`.
local function errors(fn, pattern, msg)
  local success, err = pcall(fn)
  if success then
    failed = failed + 1
    print(("FAIL: %s\n  expected an error, but none was raised"):format(msg))
    return
  end
  if pattern and not tostring(err):find(pattern, 1, true) then
    failed = failed + 1
    print(("FAIL: %s\n  error %q did not contain %q"):format(msg, tostring(err), pattern))
    return
  end
  passed = passed + 1
end

-- Minimal LibStub shim: Core.lua only needs AceAddon-3.0:NewAddon(name) to
-- return a plain table -- BoomForge registers no mixins on itself.
_G.LibStub = function(name)
  if name == "AceAddon-3.0" then
    return { NewAddon = function(_, addonName) return {} end }
  end
  error("test shim: unexpected LibStub request for " .. tostring(name))
end

-- Load a WoW addon file the same way WoW does: chunk(addonName, ns).
local function loadModule(path)
  local chunk = assert(loadfile(path))
  chunk("BoomForge", {})
end

loadModule("Core.lua")
loadModule("Debug.lua")
loadModule("Registry.lua")

-- ---- Debug.lua ----
do
  local lines = {}
  local realPrint = print
  _G.print = function(s) table.insert(lines, s) end

  local level = BoomForge.DEBUG_LEVELS.WARNING
  local log = BoomForge:CreateLogger("TestPlugin", { getLevel = function() return level end })

  log:Warning("warning shown")
  log:Info("info hidden at WARNING level")
  eq(#lines, 1, "only Warning-level message printed at WARNING level")
  ok(lines[1]:find("TestPlugin", 1, true) ~= nil, "logged message is namespaced with plugin name")
  ok(lines[1]:find("warning shown", 1, true) ~= nil, "logged message contains the original text")

  lines = {}
  level = BoomForge.DEBUG_LEVELS.NOTICE
  log:Warning("w"); log:Info("i"); log:Notice("n")
  eq(#lines, 3, "all levels print once getLevel raised to NOTICE")

  lines = {}
  level = BoomForge.DEBUG_LEVELS.OFF
  log:Warning("w")
  eq(#lines, 0, "nothing prints at OFF level")

  lines = {}
  level = BoomForge.DEBUG_LEVELS.INFO
  log:Info("formatted %s %d", "value", 5)
  eq(lines[1]:find("formatted value 5", 1, true) ~= nil, true, "format args are applied")

  _G.print = realPrint

  local log2 = BoomForge:CreateLogger("NoOpts")
  ok(log2 ~= nil, "CreateLogger works with no opts table (defaults to WARNING level)")
end

-- ---- Registry.lua ----
do
  BoomForge.plugins = {} -- reset between test blocks

  errors(function() BoomForge:RegisterPlugin({}, {}) end,
    "opts.name", "RegisterPlugin requires opts.name")

  local pluginObj = { some = "addon table" }
  local entry = BoomForge:RegisterPlugin(pluginObj, { name = "Alpha", version = "1.0.0" })
  eq(entry.name, "Alpha", "RegisterPlugin returns entry with name")
  eq(entry.version, "1.0.0", "RegisterPlugin returns entry with version")
  eq(entry.plugin, pluginObj, "RegisterPlugin stores the plugin object unmodified")

  eq(BoomForge:GetPlugin("Alpha"), pluginObj, "GetPlugin returns the registered plugin object")
  eq(BoomForge:GetPlugin("NeverRegistered"), nil, "GetPlugin returns nil for unknown name")

  errors(function() BoomForge:RegisterPlugin({}, { name = "Alpha" }) end,
    "already registered", "duplicate RegisterPlugin for the same name errors")

  errors(function() BoomForge:RegisterPlugin({}, { name = "Beta", apiVersion = BoomForge.API_VERSION + 1 }) end,
    "API version", "RegisterPlugin errors on API version mismatch")

  local ok1 = BoomForge:RegisterPlugin({}, { name = "Gamma", apiVersion = BoomForge.API_VERSION })
  ok(ok1 ~= nil, "RegisterPlugin succeeds when apiVersion matches")
end

print(("\n%d passed, %d failed"):format(passed, failed))
if failed > 0 then os.exit(1) end
