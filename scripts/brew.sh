#!/usr/bin/env bash

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add brew to PATH (Linux / Linuxbrew)
if [[ "$(uname)" == "Linux" ]] && [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle --file "$HOME/.config/homebrew/Brewfile" --no-lock
