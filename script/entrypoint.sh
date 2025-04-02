#!/bin/bash
# entrypoint.sh

# Seed Neovim configuration if the mounted /root/.config/nvim is empty.
if [ ! -d "/root/.config/nvim" ] || [ -z "$(ls -A /root/.config/nvim 2>/dev/null)" ]; then
    echo "Seeding default Neovim configuration data..."
    mkdir -p /root/.config/nvim
    cp -r /root/.default.config/nvim/* /root/.config/nvim/
fi

# Seed Neovim local share data if the mounted /root/.local/share/nvim is empty.
if [ ! -d "/root/.local/share/nvim" ] || [ -z "$(ls -A /root/.local/share/nvim 2>/dev/null)" ]; then
    echo "Seeding Neovim local data..."
    mkdir -p /root/.local/share/nvim
    cp -r /root/.default.local/share/nvim/* /root/.local/share/nvim/
fi

# Seed Neovim cache if the mounted /root/.cache/nvim is empty.
if [ ! -d "/root/.cache/nvim" ] || [ -z "$(ls -A /root/.cache/nvim 2>/dev/null)" ]; then
    echo "Seeding Neovim cache data..."
    mkdir -p /root/.cache/nvim
    cp -r /root/.default.cache/* /root/.cache/nvim/ || true
fi

# Seed Neovim state if the mounted /root/.local/state/nvim is empty.
if [ ! -d "/root/.local/state/nvim" ] || [ -z "$(ls -A /root/.local/state/nvim 2>/dev/null)" ]; then
    echo "Seeding Neovim state data..."
    mkdir -p /root/.local/state/nvim
    cp -r /root/.default.local/state/nvim/* /root/.local/state/nvim/ || true
fi

# If an argument is provided (a mounted project directory), configure it as a safe git directory.
if [ -n "$1" ]; then
    folder_name=$(basename "$1")
    echo "Adding /root/projects/${folder_name} as a safe git directory."
    git config --global --add safe.directory "/root/projects/${folder_name}"
fi

# Disable dubious ownership check globally.
git config --global --add safe.directory "*"

# Load API keys from the secrets file
if [ -f /sh/load_api_keys.sh ]; then
    echo "Running /sh/load_api_keys.sh to load environment variables..."
    source /sh/load_api_keys.sh
else
    echo "Warning: /sh/load_api_keys.sh not found. Skipping API key loading."
fi

# Initialize NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    echo "nvm initialized."
else
    echo "nvm initialization script not found at $NVM_DIR/nvm.sh. Skipping Node.js setup."
fi

# Ensure Node.js version and mcp-hub are installed
NODE_VERSION="v22.14.0"
MCP_VERSION="1.8.0"

# Install Node.js version if not already installed
if command -v nvm > /dev/null 2>&1; then
    if ! nvm ls "$NODE_VERSION" > /dev/null 2>&1; then
        echo "Installing Node.js $NODE_VERSION via nvm..."
        nvm install "$NODE_VERSION"
    else
        echo "Node.js $NODE_VERSION is already installed."
    fi
else
    echo "nvm not available after initialization attempt."
fi

# Use the desired Node.js version explicitly before npm install
if command -v nvm > /dev/null 2>&1; then
    nvm use "$NODE_VERSION"
fi

# Check if npm is available now before installing mcp-hub
if command -v npm > /dev/null 2>&1; then
    if ! npm list -g mcp-hub@"$MCP_VERSION" > /dev/null 2>&1; then
        echo "Installing mcp-hub@$MCP_VERSION globally..."
        npm install -g mcp-hub@"$MCP_VERSION"
    else
        echo "mcp-hub@$MCP_VERSION is already installed."
    fi
else
    echo "npm not found. Skipping mcp-hub installation."
fi

# Define the desired version of @anthropic-ai/claude-code
CLAUDE_CODE_VERSION="latest"

# Check if @anthropic-ai/claude-code is installed globally
if ! npm list -g @anthropic-ai/claude-code@"$CLAUDE_CODE_VERSION" > /dev/null 2>&1; then
    echo "Installing @anthropic-ai/claude-code@$CLAUDE_CODE_VERSION globally..."
    npm install -g @anthropic-ai/claude-code@"$CLAUDE_CODE_VERSION"
else
    echo "@anthropic-ai/claude-code@$CLAUDE_CODE_VERSION is already installed."
fi

# Add MCP servers
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem / /
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
claude mcp add brave-search -- npx -y @modelcontextprotocol/server-brave-search
claude mcp add puppeteer -- npx -y @modelcontextprotocol/server-puppeteer

# Launch zsh.
exec zsh

