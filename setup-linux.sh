#!/bin/bash

set -e

echo "🎨 Silhouette - Oh My Posh Setup for Linux/WSL/Raspberry Pi"
echo "============================================================="
echo ""

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$SCRIPT_DIR/silhouette.omp.json"

# Check if theme file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "❌ Error: Theme file not found at $THEME_FILE"
    exit 1
fi

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        OMP_ARCH="amd64"
        ;;
    aarch64|arm64)
        OMP_ARCH="arm64"
        ;;
    armv7l)
        OMP_ARCH="arm"
        ;;
    *)
        echo "⚠️  Warning: Unsupported architecture: $ARCH"
        echo "   Defaulting to amd64, but this may not work."
        OMP_ARCH="amd64"
        ;;
esac

# Install oh-my-posh if not already installed
if ! command -v oh-my-posh &> /dev/null; then
    echo "📦 Installing oh-my-posh..."

    # Create bin directory if it doesn't exist
    mkdir -p "$HOME/.local/bin"

    # Download and install oh-my-posh
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"

    # Make sure it's in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    echo "✅ Oh-my-posh installed successfully!"
else
    echo "✅ Oh-my-posh is already installed"
fi

# Create oh-my-posh config directory
mkdir -p "$HOME/.config/ohmyposh"

# Copy theme file
echo "📋 Copying theme file..."
cp "$THEME_FILE" "$HOME/.config/ohmyposh/silhouette.omp.json"
echo "✅ Theme file copied to ~/.config/ohmyposh/silhouette.omp.json"

# Setup for bash
if [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    echo ""
    echo "🐚 Setting up bash..."

    BASHRC="$HOME/.bashrc"
    OMP_INIT='eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/silhouette.omp.json)"'

    if ! grep -q "oh-my-posh init bash" "$BASHRC" 2>/dev/null; then
        echo "" >> "$BASHRC"
        echo "# Oh My Posh initialization (added by Silhouette)" >> "$BASHRC"
        echo "$OMP_INIT" >> "$BASHRC"
        echo "✅ Added oh-my-posh to ~/.bashrc"
    else
        echo "ℹ️  Oh-my-posh already configured in ~/.bashrc"
    fi
fi

# Setup for zsh
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    echo ""
    echo "🐚 Setting up zsh..."

    ZSHRC="$HOME/.zshrc"
    OMP_INIT='eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/silhouette.omp.json)"'

    if ! grep -q "oh-my-posh init zsh" "$ZSHRC" 2>/dev/null; then
        echo "" >> "$ZSHRC"
        echo "# Oh My Posh initialization (added by Silhouette)" >> "$ZSHRC"
        echo "$OMP_INIT" >> "$ZSHRC"
        echo "✅ Added oh-my-posh to ~/.zshrc"
    else
        echo "ℹ️  Oh-my-posh already configured in ~/.zshrc"
    fi
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Install a Nerd Font for proper icon display:"
echo "      https://www.nerdfonts.com/font-downloads"
echo "      Recommended: MesloLGM Nerd Font"
echo ""
echo "   2. Configure your terminal to use the Nerd Font"
echo ""
echo "   3. Restart your shell or run:"
echo "      source ~/.bashrc    (for bash)"
echo "      source ~/.zshrc     (for zsh)"
echo ""
