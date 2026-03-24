---
name: tavily-mcp-fix
description: Fix Tavily MCP "Client Not Registered" OAuth authentication errors. Use this skill when encountering OAuth failures, invalid client_id errors, or Tavily MCP tools failing to authenticate. Clears cached credentials and triggers fresh OAuth authentication flow.
---

# Fix Tavily MCP Authentication

## When to Use

Use this skill when you encounter:
- "Client Not Registered" error on `mcp.tavily.com/authorize`
- Invalid client_id in OAuth flow
- Tavily MCP tools failing to authenticate
- Cached credentials expired or invalidated

## Quick Fix

Run the automated fix:

```bash
~/.agents/skills/tavily-mcp-fix/scripts/fix-tavily-mcp-auth.sh
```

Or run manually:

```bash
# Clear all Tavily MCP caches
rm -rf ~/.mcp-auth/mcp-remote-*/
rm -rf ~/.cursor/plugins/tavily-cursor-plugin/;
rm -rf ~/.cursor/plugins/cache/cursor-public/tavily/;

# Trigger re-authentication
npx mcp-remote https://mcp.tavily.com/mcp
```

## Manual Steps

### Step 1: Diagnose

Check for invalid cached credentials:

```bash
cat ~/.mcp-auth/mcp-remote-*/"*_client_info.json" 2>/dev/null | grep client_id
```

### Step 2: Clear Cache

```bash
rm -rf ~/.mcp-auth/mcp-remote-*/
rm -rf ~/.cursor/plugins/tavily-cursor-plugin/
rm -rf ~/.cursor/plugins/cache/cursor-public/tavily/
find ~/.cursor/projects -name "*tavily*" -type d -exec rm -rf {} + 2>/dev/null
```

### Step 3: Install mcp-remote (if needed)

```bash
npm install -g mcp-remote
```

### Step 4: Trigger Re-authentication

```bash
npx mcp-remote https://mcp.tavily.com/mcp
```

### Step 5: Verify

```bash
ls -la ~/.mcp-auth/mcp-remote-*/
cat ~/.mcp-auth/mcp-remote-*/"*_client_info.json" | grep client_id
tvly search "test" --json
```

## Root Cause

Tavily MCP uses OAuth with PKCE. The client generates a `client_id` that must be registered with Tavily's auth server. The "Client Not Registered" error occurs when:

1. Client credentials expire
2. Tavily resets their client registry
3. Cached credentials become corrupted

## Verification Checklist

- [ ] New `client_info.json` created in `~/.mcp-auth/mcp-remote-*/`
- [ ] New `client_id` differs from old invalid one
- [ ] `tokens.json` exists with access/refresh tokens
- [ ] Tavily CLI works: `tvly search "test" --json`

## Common Issues

### Browser doesn't open automatically

Manually open the URL shown in terminal.

### Port 16735 already in use

Kill the process using that port or wait for the lockfile to expire.

### Still getting "Client Not Registered"

```bash
rm -rf ~/.mcp-auth/
find ~ -name "mcp*.json" -delete 2>/dev/null
# Restart your IDE completely
```

## References

- Tavily MCP Docs: https://docs.tavily.com/documentation/mcp
- OAuth 2.0 Dynamic Client Registration: https://datatracker.ietf.org/doc/html/rfc7591
- MCP Remote: https://github.com/modelcontextprotocol/mcp-cli