#!/usr/bin/env bash
# Set up the powerline bash prompt (https://github.com/boudreau/powerline) on this host,
# the same way it is set up on makalu-new:
#   - powerline-status + powerline-gitstatus in a Python 3 venv at ~/.venvs/powerline
#   - config cloned to ~/.config/powerline
#   - Python 3 compatible loader block in ~/.bashrc
# Safe to re-run.
set -euo pipefail

VENV="$HOME/.venvs/powerline"
CONF="$HOME/.config/powerline"
RC="$HOME/.bashrc"
LOOKUP="powerline_path=\$(python3 -c 'import os, powerline; print(os.path.dirname(powerline.__file__))' 2>/dev/null)"

command -v python3 >/dev/null || { echo "python3 not found; install it first" >&2; exit 1; }
if command -v git >/dev/null; then
  HAVE_GIT=1
else
  HAVE_GIT=0
  command -v curl >/dev/null || { echo "need git or curl to download the config; install one first" >&2; exit 1; }
  echo "note: git not found; downloading the config as a tarball (the git status segment needs git to show)" >&2
fi

echo "== Python venv: $VENV"
if [ ! -x "$VENV/bin/python" ]; then
  python3 -m venv "$VENV"
fi
"$VENV/bin/python" -m pip install -q --upgrade pip
"$VENV/bin/python" -m pip install -q --upgrade powerline-status powerline-gitstatus

echo "== Config: $CONF"
if [ -d "$CONF/.git" ] && [ "$HAVE_GIT" = 1 ]; then
  git -C "$CONF" pull -q --ff-only || echo "warning: could not update $CONF, keeping it as is" >&2
elif [ -e "$CONF" ]; then
  echo "warning: $CONF already exists and can't be updated with git; leaving it alone" >&2
elif [ "$HAVE_GIT" = 1 ]; then
  mkdir -p "$(dirname "$CONF")"
  git clone -q https://github.com/boudreau/powerline.git "$CONF"
else
  mkdir -p "$CONF"
  curl -fsSL https://github.com/boudreau/powerline/archive/refs/heads/master.tar.gz \
    | tar -xz -C "$CONF" --strip-components=1
fi

echo "== Shell startup: $RC"
touch "$RC"
cp "$RC" "$RC.bak-$(date +%Y%m%d%H%M%S)"

# Replace the old Python 2 lookup line (from the original README) if present.
sed -i "s|^powerline_path=.*|$LOOKUP|" "$RC"

if grep -q 'bindings/bash/powerline.sh' "$RC"; then
  # Loader block already there; make sure the venv is on PATH before it runs.
  if ! grep -q '\.venvs/powerline/bin' "$RC"; then
    sed -i '/^powerline_path=/i export PATH="$HOME/.venvs/powerline/bin:$PATH"' "$RC"
  fi
else
  cat >> "$RC" <<EOF

# Powerline prompt (https://github.com/boudreau/powerline)
export PATH="\$HOME/.venvs/powerline/bin:\$PATH"
$LOOKUP
if [[ "\$powerline_path" != "" ]]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source \${powerline_path}/bindings/bash/powerline.sh
fi
EOF
fi

# Stop any daemon left over from an older (e.g. Python 2) install so the new one starts.
"$VENV/bin/powerline-daemon" --kill >/dev/null 2>&1 || true

echo "== Test render"
"$VENV/bin/python" "$VENV/bin/powerline-render" shell left --last-exit-code=0 --jobnum=0 | sed 's/\x1b\[[0-9;]*m//g'
echo
echo "Done. Open a new shell (or run: source ~/.bashrc) to get the prompt."
