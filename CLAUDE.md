# Git Commit Style Guide

## Commit Message Format

### Rules

- **DON'T** prefix with type: `docs:`, `feat:`, `fix:`, `refactor:`, `test:`, `chore:`, etc.
- **DON'T** capitalize the first word after the colon
- **DON'T** add much body text unless relevant
- **DON'T** add footers like "Generated with Claude Code" or "Co-Authored-By"

### Examples

✅ **Good:**
```
add testing best practices to avoid redundant tests
add WhereTypeNotIn extension for EF Core discriminator filtering
handle null reference in customer enrollment
```

❌ **Bad:**
```
docs: Add testing best practices to avoid redundant tests

feat: Add some feature

🤖 Generated with [Claude Code](https://claude.com/claude-code)
Co-Authored-By: Claude <noreply@anthropic.com>
```
