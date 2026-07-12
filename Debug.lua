local ADDON, ns = ...

BoomForge.DEBUG_LEVELS = {
	OFF = 0,
	WARNING = 1,
	INFO = 2,
	NOTICE = 3,
}

local function defaultLevel()
	return BoomForge.DEBUG_LEVELS.WARNING
end

-- Returns a namespaced logger for `pluginName`. `opts.getLevel`, if provided, is
-- called on every log to read the plugin's current debug level (e.g. from its
-- own AceDB profile) -- BoomForge never owns plugin settings state itself.
--
-- Internal/unsupported -- not part of the public API. Only Registry.lua calls
-- this, so that the only sanctioned way to get a logger is by actually
-- registering as a plugin (RegisterPlugin -> entry.services.log), not by
-- reaching into BoomForge for logging without committing to the ecosystem.
-- Nothing stops another addon from calling this directly (Lua has no real
-- access control on a shared global table) -- this is a documented convention
-- fence, not an enforced one.
function BoomForge:_CreateLogger(pluginName, opts)
	opts = opts or {}
	local getLevel = opts.getLevel or defaultLevel
	local prefix = ("|cff33ff99[%s]|r "):format(pluginName)

	local logger = {}

	function logger:Log(level, msg, ...)
		if level <= getLevel() then
			print(prefix .. msg:format(...))
		end
	end

	function logger:Warning(msg, ...) self:Log(BoomForge.DEBUG_LEVELS.WARNING, msg, ...) end
	function logger:Info(msg, ...) self:Log(BoomForge.DEBUG_LEVELS.INFO, msg, ...) end
	function logger:Notice(msg, ...) self:Log(BoomForge.DEBUG_LEVELS.NOTICE, msg, ...) end

	return logger
end
