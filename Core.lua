local ADDON, ns = ...

BoomForge = LibStub("AceAddon-3.0"):NewAddon("BoomForge")

-- Bump when Registry.lua/Debug.lua's public API changes in a way that could
-- break a plugin built against an older BoomForge. Plugins may pass
-- opts.apiVersion to RegisterPlugin to assert compatibility.
BoomForge.API_VERSION = 1

function BoomForge:OnInitialize()
end
