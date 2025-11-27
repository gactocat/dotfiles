#!/usr/bin/env zsh

set -e

if [ "$(uname)" != "Darwin" ]; then
    echo "Not in darwin. Nothing to do."
    exit 0
fi

# Install homebrew: https://brew.sh/
if ! command -v brew > /dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
BREW_DIR="${SCRIPT_DIR}/brew"

brew bundle --file="${BREW_DIR}/Brewfile.core"
brew bundle --file="${BREW_DIR}/Brewfile.dev"
brew bundle --file="${BREW_DIR}/Brewfile.apps"

