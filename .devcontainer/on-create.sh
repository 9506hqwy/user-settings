#!/bin/bash
set -euo pipefail

# Install dependencies
sudo apt-get update
sudo apt-get install -y zstd

# Configuration PATH
mkdir -p ~/.local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc

# Install bat
BAT_VERSION=0.25.0
curl -fsSL -o - "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-i686-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "bat-v${BAT_VERSION}-i686-unknown-linux-gnu/bat" > ~/.local/bin/bat
chmod +x ~/.local/bin/bat

# Install delta
DELTA_VERSION=0.18.2
curl -fsSL -o - "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta" > ~/.local/bin/delta
chmod +x ~/.local/bin/delta

# Install edit
EDIT_VERSION=1.2.0
curl -fsSL -o - "https://github.com/microsoft/edit/releases/download/v${EDIT_VERSION}/edit-${EDIT_VERSION}-x86_64-linux-gnu.tar.zst" | \
    tar --zstd -xf - -O "edit" > ~/.local/bin/edit
chmod +x ~/.local/bin/edit
