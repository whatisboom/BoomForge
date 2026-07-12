#!/usr/bin/env bash
# Deploy the working tree into the live WoW AddOns folder for in-game testing.
#
# Syncs code/toc only. Dev and tooling files are excluded, and Libs/ is left
# untouched in the live folder (seeded once, then preserved) so a code deploy
# can never wipe the vendored libraries. Run, then /reload in game.
set -euo pipefail

SRC="$HOME/projects/BoomForge/"
DEST="/Applications/World of Warcraft/_retail_/Interface/AddOns/BoomForge/"

if [ ! -d "${DEST}Libs" ] || [ ! -f "${DEST}Libs/LibStub/LibStub.lua" ]; then
  echo "Libs/ missing or incomplete in live folder. Seed it first, e.g.:" >&2
  echo "  rsync -a \"$SRC\"Libs/ \"$DEST\"Libs/" >&2
  exit 1
fi

rsync -a --delete \
  --exclude='.git/' \
  --exclude='.github/' \
  --exclude='.gitignore' \
  --exclude='.pkgmeta' \
  --exclude='.DS_Store' \
  --exclude='tests/' \
  --exclude='CLAUDE.md' \
  --exclude='deploy.sh' \
  --exclude='Libs/' \
  "$SRC" "$DEST"

echo "Deployed to live AddOns folder. /reload in game."
