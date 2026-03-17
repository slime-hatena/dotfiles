#!/usr/bin/env bash

# Convert chezmoi git remote from HTTPS to SSH
if [[ -d "$CHEZMOI_SOURCE_DIR/.git" ]]; then
  CURRENT_REMOTE=$(git -C "$CHEZMOI_SOURCE_DIR" remote get-url origin 2>/dev/null)

  if [[ "$CURRENT_REMOTE" =~ ^https://github\.com/(.+)/(.+)$ ]]; then
    USER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    SSH_REMOTE="git@github.com:${USER}/${REPO}"

    echo "Converting remote URL from HTTPS to SSH..."
    echo "  Before: $CURRENT_REMOTE"
    echo "  After:  $SSH_REMOTE"
    git -C "$CHEZMOI_SOURCE_DIR" remote set-url origin "$SSH_REMOTE"
    echo "Done."
  else
    echo "Remote is already SSH or not a GitHub HTTPS URL: $CURRENT_REMOTE"
  fi
else
  echo "chezmoi source directory not found: $CHEZMOI_SOURCE_DIR"
fi
