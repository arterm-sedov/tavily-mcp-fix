# Tavily MCP Fix Skill

A skill for fixing "Client Not Registered" OAuth authentication errors with Tavily MCP.

## Problem

When using Tavily MCP tools, you may encounter:

```
Client Not Registered
The client ID d27dc5f1-ed03-427e-b7a2-598575e657cb was not found in the server's client registry.
```

This happens when:
- Client credentials expire
- Tavily resets their client registry
- Cached credentials become corrupted

## Solution

This skill clears all cached OAuth credentials and triggers a fresh authentication flow with Tavily's servers.

## Quick Fix

Run the automated fix script:

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

## Installation

### For Claude Code / Gemini CLI

Add to your skills directory:

```bash
# Clone or copy to your skills folder
cp -r . ~/.agents/skills/tavily-mcp-fix/
```

### For OpenCode

Add to your skills configuration:

```yaml
skills:
  - path: D:\Repo\tavily-mcp-fix
```

## Prerequisites

- Tavily CLI installed (`tvly --version`)
- Node.js/npm available (for `mcp-remote`)
- Browser access for OAuth flow

## Files

- `SKILL.md` - The skill instructions loaded by the agent
- `scripts/fix-tavily-mcp-auth.sh` - Automated fix script
- `README.md` - This file

## References

- [Tavily MCP Documentation](https://docs.tavily.com/documentation/mcp)
- [OAuth 2.0 Dynamic Client Registration (RFC 7591)](https://datatracker.ietf.org/doc/html/rfc7591)
- [MCP Remote CLI](https://github.com/modelcontextprotocol/mcp-cli)

## License

MIT