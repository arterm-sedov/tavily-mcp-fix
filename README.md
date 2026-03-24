# Tavily MCP Fix

A skill for fixing "Client Not Registered" OAuth authentication errors with Tavily MCP.

## Why This Skill Exists

Tavily MCP uses OAuth with PKCE (Proof Key for Code Exchange). The client generates a `client_id` that must be registered with Tavily's auth server. When credentials expire, Tavily resets their registry, or cached data gets corrupted—you get the dreaded "Client Not Registered" error.

The fix is simple: clear caches and re-authenticate. But the steps are tedious and easy to forget. This skill automates the process and provides clear guidance when you encounter this error.

## Quick Fix

| Situation | Command |
|-----------|---------|
| Automated fix | `~/.agents/skills/tavily-mcp-fix/scripts/fix-tavily-mcp-auth.sh` |
| Manual fix | `rm -rf ~/.mcp-auth/mcp-remote-*/ && npx mcp-remote https://mcp.tavily.com/mcp` |

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

## About

Fix Tavily MCP "Client Not Registered" OAuth authentication errors

## License

MIT