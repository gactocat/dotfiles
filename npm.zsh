#!/usr/bin/env zsh

set -e

if ! command -v npm > /dev/null 2>&1; then
    echo "Error: npm not found. Install node first (e.g. mise use --global node@lts)."
    exit 1
fi

packages=(
    "@esaio/esa-cli"
)

for package in "${packages[@]}"; do
    npm install --ignore-scripts -g "$package"
done
