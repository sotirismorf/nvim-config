#!/usr/bin/env bash
# Regenerate the Greek spell file (spell/el.utf-8.spl) for Neovim.
#
# Why this exists: the el.utf-8.spl shipped with vim/nvim was built in ~2005
# with an old vim whose mkspell mishandled the final sigma (ς), so "τέλος" was
# flagged wrong and "τέλοσ" accepted. The vim bug was fixed long ago but the
# distributed spell file was never regenerated. This script rebuilds it from the
# current LibreOffice Greek Hunspell source using the current nvim's mkspell.
#
# Usage:  ./scripts/regen-greek-spell.sh
# Result: overwrites spell/el.utf-8.spl in this repo.

set -euo pipefail

# Resolve repo root from this script's location.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEST="$REPO_DIR/spell/el.utf-8.spl"

BASE="https://raw.githubusercontent.com/LibreOffice/dictionaries/master/el_GR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading Greek Hunspell source from LibreOffice..."
curl -fsSL -o "$TMP/el_GR.aff" "$BASE/el_GR.aff"
curl -fsSL -o "$TMP/el_GR.dic" "$BASE/el_GR.dic"

echo "Building spell file with nvim mkspell (this takes a few seconds)..."
nvim --headless -u NONE -i NONE \
  -c 'set encoding=utf-8' \
  -c "mkspell! $TMP/el $TMP/el_GR" \
  -c 'qa!'

mkdir -p "$REPO_DIR/spell"
cp "$TMP/el.utf-8.spl" "$DEST"

echo "Done -> $DEST"

# Quick sanity check: τέλος must pass, τέλοσ must fail.
echo "Verifying final-sigma handling..."
# Note: nvim --headless prints :echo output to stderr, so capture 2>&1.
ok=$(nvim --headless -u NONE -i NONE \
  -c "set runtimepath^=$REPO_DIR" -c 'set spell spelllang=el' \
  -c "echon spellbadword('τέλος')[0]" -c 'qa!' 2>&1)
bad=$(nvim --headless -u NONE -i NONE \
  -c "set runtimepath^=$REPO_DIR" -c 'set spell spelllang=el' \
  -c "echon spellbadword('τέλοσ')[0]" -c 'qa!' 2>&1)
if [ -z "$ok" ] && [ -n "$bad" ]; then
  echo "OK: 'τέλος' accepted, 'τέλοσ' rejected."
else
  echo "WARNING: sanity check failed (ok='$ok' bad='$bad')." >&2
  exit 1
fi
