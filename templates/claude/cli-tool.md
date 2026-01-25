# CLAUDE.md - CLI Tool

## Project Overview

**Type:** Command Line Tool

**Purpose:** [What this CLI tool does]

**Tech Stack:**

- Language: [e.g., Python, Go, Rust, Node.js]
- CLI Framework: [e.g., Click, Cobra, clap, Commander]
- Package Manager: [e.g., pip, cargo, npm]

## Development Setup

```bash
# Install dependencies
[installation command]

# Run in development mode
[development command]

# Install locally for testing
[local install command]
```

## Architecture

**Command Structure:**

```
cli-tool
├── main command
├── subcommand1
│   ├── --flag1
│   └── --flag2
└── subcommand2
    └── --option
```

**Code Structure:**

```
src/
├── cli/            # CLI interface and argument parsing
├── commands/       # Command implementations
├── core/           # Core business logic
├── utils/          # Utilities and helpers
└── config/         # Configuration handling
```

## Coding Standards

**Command Design:**

- Follow Unix philosophy (do one thing well)
- Use consistent flag naming (`--verbose`, not `-v` and `--verbose`)
- Provide helpful error messages
- Support `--help` for all commands

**Output Guidelines:**

- Use colors for better readability (success=green, error=red, warning=yellow)
- Progress bars for long operations
- Quiet mode (`--quiet`) for scripting
- JSON output mode (`--json`) for automation

**Error Handling:**

- Exit code 0 for success
- Non-zero exit codes for errors
- Clear error messages with actionable advice

**Formatting:**

```bash
make format          # Format source code
make check-format    # Check formatting
```

## Testing Strategy

```bash
# Unit tests
[test command]

# Integration tests (full CLI invocation)
[integration test command]

# Manual testing
./bin/[tool] [command] --help
```

**Test Coverage:**

- All commands and subcommands
- Flag combinations
- Error cases
- Edge cases (empty input, large files, etc.)

## Configuration

**Config File Locations:**

- Global: `~/.config/[tool]/config.yaml`
- Project: `./.[tool]rc`

**Environment Variables:**

- `[TOOL]_CONFIG` - Custom config path
- `[TOOL]_DEBUG` - Enable debug output

## Known Issues

- **Issue:** [Common problem users face]
  - **Solution:** [How to resolve it]

## DO NOT

- ❌ Don't use hardcoded paths (use platform-specific defaults)
- ❌ Don't assume shell environment (Windows compatibility)
- ❌ Don't print debug info in normal mode (use `--verbose`)
- ❌ Don't modify user files without confirmation

## Distribution

```bash
# Build binary
[build command]

# Create package
[package command]

# Publish
[publish command]
```

**Supported Platforms:**

- [ ] Linux (x86_64, ARM64)
- [ ] macOS (Intel, Apple Silicon)
- [ ] Windows (x86_64)

## Documentation

- README.md - Installation and quick start
- USAGE.md - Detailed usage examples
- man page - Traditional Unix documentation
