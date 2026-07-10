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
function BoomForge:CreateLogger(pluginName, opts)
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
