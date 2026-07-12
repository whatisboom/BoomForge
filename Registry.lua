local ADDON, ns = ...

BoomForge.plugins = {}

-- Registers a plugin with BoomForge. `plugin` is the plugin's own AceAddon
-- object (or any table); it is stored for lookup via GetPlugin but otherwise
-- untouched -- BoomForge does not wrap or mutate it.
--
-- opts.name (required) -- plugin's addon name, used as the registry key.
-- opts.version (optional) -- for bookkeeping only; no UI surfaces it in v1.
-- opts.apiVersion (optional) -- if given, must match BoomForge.API_VERSION or
--   registration errors loudly (both sides are solo-maintained, so a version
--   skew is a development mistake, not a runtime condition to degrade gracefully).
-- opts.getLevel (optional) -- passed straight through to CreateLogger.
--
-- Returns the registry entry, which carries a `services` table of whatever
-- BoomForge provides the plugin -- today just `services.log`, but the shape
-- is deliberately a growable table (not a single return value) so a future
-- service (e.g. cross-plugin comms) can be added under `services` without
-- another breaking signature change.
function BoomForge:RegisterPlugin(plugin, opts)
	opts = opts or {}
	assert(type(opts.name) == "string", "BoomForge:RegisterPlugin requires opts.name")

	if opts.apiVersion and opts.apiVersion ~= self.API_VERSION then
		error(("BoomForge: %s expects API version %d, but BoomForge is running %d")
			:format(opts.name, opts.apiVersion, self.API_VERSION), 2)
	end

	if self.plugins[opts.name] then
		error(("BoomForge: plugin '%s' is already registered"):format(opts.name), 2)
	end

	local entry = {
		plugin = plugin,
		name = opts.name,
		version = opts.version,
		services = {
			log = self:CreateLogger(opts.name, { getLevel = opts.getLevel }),
		},
	}
	self.plugins[opts.name] = entry

	return entry
end

function BoomForge:GetPlugin(name)
	local entry = self.plugins[name]
	return entry and entry.plugin
end
