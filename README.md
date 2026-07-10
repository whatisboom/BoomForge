# BoomForge

A shared plugin framework for whatisboom's World of Warcraft addons (EnchantCheck, DEFunnel, VaultTracker, and future ones).

**BoomForge does nothing on its own.** It has no UI, no minimap icon, no Settings panel. Installing it alone is a no-op. Install a plugin addon that requires it — the plugin's own README will tell you if it needs BoomForge.

## Why this exists

Several small, independent addons were each vendoring their own copy of the Ace3 library stack and reinventing the same debug/logging boilerplate. BoomForge hosts one shared copy of those libraries and a small plugin-registration API, so plugin addons can stay small and focused while avoiding that duplication.

## For plugin authors

- Add `## RequiredDeps: BoomForge` to your addon's `.toc` and drop your own vendored `Libs/`.
- Register on load:
  ```lua
  BoomForge:RegisterPlugin(self, { name = "YourAddonName", version = "1.0.0" })
  ```
- Get a namespaced logger instead of rolling your own debug/print helper:
  ```lua
  local log = BoomForge:CreateLogger("YourAddonName", { getLevel = function() return self.db.profile.debugLevel end })
  log:Warning("something happened: %s", details)
  ```

See `CHANGELOG.md` for what's implemented so far.

## License

MIT — see `LICENSE`.
