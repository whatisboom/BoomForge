# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-07-12

### Added
- Initial scaffold: shared Ace3/LibDataBroker/LibDBIcon/LibSharedMedia library hosting via `embeds.xml`.
- `BoomForge:RegisterPlugin(plugin, opts)` — loosely-coupled plugin registry (bookkeeping + API-version check), returning an entry with a growable `services` table (currently `services.log`, a namespaced debug/print helper).
- No user-facing UI in v1 (no Settings category, no minimap icon) — pure Lua services layer.

### Changed
- The shared logger is only reachable via `RegisterPlugin` (`entry.services.log`) — there is no standalone public way to get one without registering as a plugin. BoomForge is a base for a committed plugin ecosystem, not a grab-bag of free-standing utilities.

[Unreleased]: https://github.com/whatisboom/BoomForge/compare/v0.2.0-beta...HEAD
[0.2.0]: https://github.com/whatisboom/BoomForge/releases/tag/v0.2.0-beta
