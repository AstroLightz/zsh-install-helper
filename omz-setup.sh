#!/bin/sh

# Check if dependencies are installed
MISSING_DEPS=""

for cmd in zsh git curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING_DEPS="$MISSING_DEPS $cmd"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    echo "The following dependencies are missing:"

    for dep in $MISSING_DEPS; do
        echo "  - $dep"
    done

    echo "Please install them before running this script."
    exit 1

else
    echo "All dependencies are installed."
fi

echo "[1/2] Installing Oh My Zsh..."

# Install Oh My Zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."

    else
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set Zsh as default shell if not already set
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s /usr/bin/zsh
fi

# Setup Zsh plugins if not already set
echo "Setting up Zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

echo "[2/2] Installing Zsh plugins..."

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

else
    echo "zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

else
    echo "zsh-syntax-highlighting is already installed."
fi

# Install zsh-history-substring-search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    echo "Installing zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search

else
    echo "zsh-history-substring-search is already installed."
fi

# Backup existing .zshrc file
cp ~/.zshrc ~/.zshrc.bakup

# Update plugins in .zshrc
    PLUGINS_LINE="plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)"

# Check if plugins line exists
if grep -q "^plugins=" ~/.zshrc; then
    OS_TYPE="$(uname)"

    # Replace the plugins line
    if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS uses BSD sed
        sed -i '' "s/^plugins=.*/$PLUGINS_LINE/" ~/.zshrc

    else
        # GNU sed
        sed -i "s/^plugins=.*/$PLUGINS_LINE/" ~/.zshrc
    fi

else
    # Add plugins line to .zshrc
    echo "$PLUGINS_LINE" >> ~/.zshrc
fi

echo "Installation complete. Please restart your terminal."