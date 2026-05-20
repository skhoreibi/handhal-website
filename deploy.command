#!/bin/bash
# Final cleanup: untracks the .new_index.html staging file, adds UAE MAP.jpg image,
# amends the previous commit so history stays clean. Then leaves the push to
# GitHub Desktop (which has working OAuth).

set +e
REPO_DIR="/Users/macstudio/Documents/Claude/Projects/Wisewell Handhal"
LOG="$REPO_DIR/deploy.log"

cd "$REPO_DIR" || { echo "Cannot cd to $REPO_DIR"; exit 1; }

{
  echo "==== $(date) ===="
  echo ""
  echo "=== Cleaning .git lock files ==="
  find .git -name "*.lock" -type f -print -delete 2>/dev/null
  echo ""
  echo "=== Removing stray .new_index.html (staging artifact) ==="
  rm -f .new_index.html
  echo ""
  echo "=== Ensuring UAE MAP.jpg is present ==="
  if [ ! -f "UAE MAP.jpg" ]; then
    BLOB_SHA="f1276cca251bd1cde8b579caad0110a3b2cbb7ac"
    git show "$BLOB_SHA" > "UAE MAP.jpg" 2>&1 && echo "Restored UAE MAP.jpg from git object $BLOB_SHA"
  else
    echo "UAE MAP.jpg already present ($(wc -c < 'UAE MAP.jpg') bytes)"
  fi
  echo ""
  echo "=== Staging ==="
  git rm --cached .new_index.html 2>/dev/null
  git add "UAE MAP.jpg"
  git add -A
  git status --short
  echo ""
  echo "=== Amending previous commit with the corrected file set ==="
  git -c user.email="skhoreibi@gmail.com" -c user.name="Sami Khoreibi" \
      commit --amend --no-edit 2>&1
  echo ""
  echo "=== HEAD state ==="
  git log --oneline -3
  echo ""
  echo "=== Files in HEAD commit ==="
  git show --stat HEAD | head -30
  echo ""
  echo "✅ Local main is 1 clean commit ahead of origin/main."
  echo "👉  Open GitHub Desktop and click 'Push origin' to deploy."
} 2>&1 | tee "$LOG"

echo ""
echo "Closing in 8 seconds..."
sleep 8
