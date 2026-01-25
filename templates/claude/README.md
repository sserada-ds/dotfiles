# Claude Code Templates

This directory contains CLAUDE.md templates for different project types.

## Available Templates

| Template | Use Case | Best For |
|----------|----------|----------|
| `general.md` | General purpose projects | Most projects, starting point |
| `web-app.md` | Web applications | React, Vue, Next.js, etc. |
| `cli-tool.md` | Command-line tools | CLI utilities, scripts |
| `library.md` | Libraries/packages | NPM packages, Python packages |

## How to Use

### 1. Copy Template to Your Project

```bash
# Copy the appropriate template to your project root
cp ~/dotfiles/templates/claude/general.md /path/to/your/project/CLAUDE.md

# Or use a specific template
cp ~/dotfiles/templates/claude/web-app.md /path/to/your/project/CLAUDE.md
```

### 2. Customize the Template

Edit the CLAUDE.md file and fill in:
- Project-specific information
- Tech stack details
- Coding standards
- Known issues
- DO NOTs specific to your project

### 3. Claude Code Auto-Detection

When you start a Claude Code session in a directory, it automatically:
1. Looks for CLAUDE.md in the project root
2. Includes its contents in the context
3. Uses it to understand your project better

## What is CLAUDE.md?

CLAUDE.md is a project-specific instruction file that tells Claude Code about:
- Project structure and conventions
- Coding standards and style
- Common pitfalls to avoid
- Testing requirements
- Deployment procedures

Think of it as a "README for AI assistants."

## Best Practices

### ✅ DO
- Keep CLAUDE.md updated as the project evolves
- Document past mistakes in "Known Issues"
- Be specific about file organization
- Include examples of good patterns
- Commit CLAUDE.md to version control (for team sharing)

### ❌ DON'T
- Don't include sensitive information (API keys, passwords)
- Don't make it too long (Claude has context limits)
- Don't duplicate information from code comments
- Don't forget to update it when architecture changes

## Example Workflow

```bash
# 1. Start new project
mkdir my-web-app && cd my-web-app

# 2. Copy template
cp ~/dotfiles/templates/claude/web-app.md ./CLAUDE.md

# 3. Customize
nvim CLAUDE.md  # Fill in project details

# 4. Initialize git
git init
git add CLAUDE.md
git commit -m "docs: add Claude Code project instructions"

# 5. Start Claude Code
claude
# Claude automatically loads CLAUDE.md and understands your project!
```

## Team Usage

If working in a team:

1. **Commit CLAUDE.md to git** - Everyone benefits from the same context
2. **Update it together** - Add lessons learned, gotchas, conventions
3. **Use .claude/settings.local.json** - For personal settings that shouldn't be shared

## Advanced: Multiple CLAUDE Files

For monorepos or complex projects:

```
my-monorepo/
├── CLAUDE.md                    # Root-level instructions
├── frontend/
│   └── CLAUDE.md               # Frontend-specific instructions
└── backend/
    └── CLAUDE.md               # Backend-specific instructions
```

Claude Code will use the CLAUDE.md in the directory where you start it.

## Related

- See `~/.claude/commands/` for custom Claude Code commands
- See `.claude/settings.json` for global Claude Code settings
- Read the [Claude Code Docs](https://code.claude.com/docs) for more features
