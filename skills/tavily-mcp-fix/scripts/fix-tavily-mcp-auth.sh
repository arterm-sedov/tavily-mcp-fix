#!/usr/bin/env bash
#
# Tavily MCP Auth Fix Script
# Fixes "Client Not Registered" errors by clearing caches and re-authenticating
#

set -e

echo "Tavily MCP Authentication Fix"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check current status
echo -e "${YELLOW}Step 1: Checking current authentication status...${NC}"
if [ -d "$HOME/.mcp-auth" ]; then
    echo "Found cached credentials in ~/.mcp-auth/"
    if [ -f "$HOME/.mcp-auth/mcp-remote-"*"/*_client_info.json" 2>/dev/null ]; then
        OLD_CLIENT=$(grep -o '"client_id": "[^"]*"' "$HOME/.mcp-auth/mcp-remote-"*"/*_client_info.json" 2>/dev/null | head -1 | cut -d'"' -f4)
        echo "Old client_id: $OLD_CLIENT"
    fi
else
    echo "No cached credentials found"
fi
echo ""

# Step 2: Clear caches
echo -e "${YELLOW}Step 2: Clearing cached credentials...${NC}"

# Clear MCP auth cache
if [ -d "$HOME/.mcp-auth" ]; then
    rm -rf "$HOME/.mcp-auth/mcp-remote-*/"
    echo "Cleared ~/.mcp-auth/mcp-remote-*/"
fi

# Clear Cursor caches (if they exist)
if [ -d "$HOME/.cursor/plugins/tavily-cursor-plugin" ]; then
    rm -rf "$HOME/.cursor/plugins/tavily-cursor-plugin/"
    echo "Cleared ~/.cursor/plugins/tavily-cursor-plugin/"
fi

if [ -d "$HOME/.cursor/plugins/cache/cursor-public/tavily" ]; then
    rm -rf "$HOME/.cursor/plugins/cache/cursor-public/tavily/"
    echo "Cleared ~/.cursor/plugins/cache/cursor-public/tavily/"
fi

# Clear any project-specific caches
find "$HOME/.cursor/projects" -name "*tavily*" -type d -exec rm -rf {} + 2>/dev/null || true
echo "Cleared project-specific Tavily caches"
echo ""

# Step 3: Check mcp-remote
echo -e "${YELLOW}Step 3: Checking mcp-remote installation...${NC}"
if ! command -v mcp-remote &> /dev/null; then
    echo "mcp-remote not found. Installing..."
    npm install -g mcp-remote
    echo "Installed mcp-remote"
else
    echo "mcp-remote is installed"
fi
echo ""

# Step 4: Test re-authentication
echo -e "${YELLOW}Step 4: Testing Tavily authentication...${NC}"
echo "Opening browser for OAuth authorization..."
echo ""

# Run mcp-remote with timeout to capture the initial flow
timeout 15 npx mcp-remote https://mcp.tavily.com/mcp 2>&1 || true

echo ""

# Step 5: Verify
echo -e "${YELLOW}Step 5: Verifying authentication...${NC}"

if [ -d "$HOME/.mcp-auth/mcp-remote-"*"" ]; then
    echo "New credentials directory created"
    
    if [ -f "$HOME/.mcp-auth/mcp-remote-"*"/*_client_info.json" ]; then
        NEW_CLIENT=$(grep -o '"client_id": "[^"]*"' "$HOME/.mcp-auth/mcp-remote-"*"/*_client_info.json" 2>/dev/null | head -1 | cut -d'"' -f4)
        echo "New client_id: $NEW_CLIENT"
    fi
    
    if [ -f "$HOME/.mcp-auth/mcp-remote-"*"/*_tokens.json" ]; then
        echo "Access tokens saved"
    fi
else
    echo -e "${RED}No new credentials found. Please complete the OAuth flow in your browser.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Tavily MCP Auth Fix Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "You can now use Tavily MCP tools."
echo ""
echo "To test: tvly search 'test query' --json"