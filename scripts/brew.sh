#!/usr/bin/env bash

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
  which brew
fi

# Add brew to PATH (Linux / Linuxbrew)
if [[ "$(uname)" == "Linux" ]] && [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -s "$HOME/.config/homebrew/Brewfile" ]]; then
  echo "Installing Homebrew packages from Brewfile..."
  brew bundle --file "$HOME/.config/homebrew/Brewfile"
  fortune
else
  echo "No Brewfile found at $HOME/.config/homebrew/Brewfile. Skipping Homebrew package installation."
fi

