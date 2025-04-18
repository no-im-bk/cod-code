#!/bin/bash
set -e
# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "🛑 Error: Claude Code is not installed. Please install Claude Code first."
    echo "Visit https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview for installation instructions."
    exit 1
fi
# Get the absolute path to the cod-code directory
COD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Make cod-code.py executable
chmod +x "$COD_DIR/cod"
# Create ~/.local/bin directory if it doesn't exist
mkdir -p ~/.local/bin
# Move cod to ~/.local/bin
if [ -w ~/.local/bin ]; then
    cp $COD_DIR/cod ~/.local/bin
    echo "📋 moved 'cod' to ~/.local/bin"
else
    echo "🛑 Cannot write to ~/.local/bin. Using sudo:"
    sudo cp $COD_DIR/cod ~/.local/bin
    echo "📋 moved 'cod' to ~/.local/bin using sudo"
fi
# Check if ~/.local/bin is in PATH and add it if needed
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "📍 Adding ~/.local/bin to your PATH"
    
    # Determine which shell config file to use
    SHELL_CONFIG=""
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_CONFIG="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        fi
    elif [ -f "$HOME/.config/fish/config.fish" ]; then
        SHELL_CONFIG="$HOME/.config/fish/config.fish"
    fi
    
    # Add to the appropriate config file
    if [ -n "$SHELL_CONFIG" ]; then
        if [ "$SHELL_CONFIG" = "$HOME/.config/fish/config.fish" ]; then
            echo 'set -gx PATH $HOME/.local/bin $PATH' >> "$SHELL_CONFIG"
        else
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
        fi
        echo "✅ Added ~/.local/bin to PATH in $SHELL_CONFIG"
        echo "⚠️ Please restart your terminal or run 'source $SHELL_CONFIG' for changes to take effect"
    else
        echo "⚠️ Could not determine shell config file. Please manually add ~/.local/bin to your PATH"
    fi
fi
# Create ~/.claude directory if it doesn't exist
mkdir -p ~/.claude
# Add fish pun instruction to CLAUDE.md
if [ -f ~/.claude/CLAUDE.md ]; then
    # Check if the line already exists to avoid duplicates
    if ! grep -q "Your name is Cod Code and you make fish puns in your responses." ~/.claude/CLAUDE.md; then
        echo "Your name is Cod Code and you make fish puns in your responses." >> ~/.claude/CLAUDE.md
        echo "🐟 Added fish pun instruction to ~/.claude/CLAUDE.md"
    else
        echo "🐟 Fish pun instruction already exists in ~/.claude/CLAUDE.md"
    fi
else
    echo "Your name is Cod Code and you make fish puns in your responses." > ~/.claude/CLAUDE.md
    echo "🐟 Created ~/.claude/CLAUDE.md with fish pun instruction"
fi
echo "🎣 Installation complete! You can now use 'cod' to run Cod Code."