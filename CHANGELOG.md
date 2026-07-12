# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial scaffold: shared Ace3/LibDataBroker/LibDBIcon/LibSharedMedia library hosting via `embeds.xml`.
- `BoomForge:RegisterPlugin(plugin, opts)` — loosely-coupled plugin registry (bookkeeping + API-version check), returning an entry with a growable `services` table.
- `BoomForge:CreateLogger(pluginName, opts)` — shared namespaced debug/print helper, also available via `entry.services.log` from `RegisterPlugin`.
- No user-facing UI in v1 (no Settings category, no minimap icon) — pure Lua services layer.

### Changed
- `RegisterPlugin` now creates and attaches a logger internally (`entry.services.log`) instead of requiring a separate `CreateLogger` call — ties registration and logging together so the plugin name can't drift between the two, and leaves `services` open for future capabilities (e.g. cross-plugin comms) without another signature change.

[Unreleased]: https://github.com/whatisboom/BoomForge/commits/main
