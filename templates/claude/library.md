# CLAUDE.md - Library/Package

## Project Overview

**Type:** Library/Package

**Purpose:** [What this library does]

**Tech Stack:**

- Language: [e.g., Python, TypeScript, Rust]
- Build Tool: [e.g., setuptools, tsup, cargo]
- Documentation: [e.g., Sphinx, TypeDoc, rustdoc]

## Development Setup

```bash
# Install dependencies
[installation command]

# Run tests
[test command]

# Build
[build command]

# Generate documentation
[docs command]
```

## Architecture

**Module Structure:**

```
library/
├── src/
│   ├── core/       # Core functionality
│   ├── utils/      # Utilities
│   └── types/      # Type definitions
├── tests/          # Test suite
├── docs/           # Documentation
└── examples/       # Usage examples
```

**Public API:**

- `function1(args)` - [Description]
- `Class1` - [Description]
- `constant1` - [Description]

## Coding Standards

**API Design Principles:**

- **Consistency:** Similar operations should work similarly
- **Simplicity:** Simple tasks should be simple
- **Flexibility:** Complex tasks should be possible
- **Type Safety:** Strong typing for better DX

**Naming Conventions:**

- Public API: Clear, descriptive names
- Internal functions: Prefix with `_` (Python) or keep private
- Constants: `UPPER_SNAKE_CASE`
- Classes: `PascalCase`
- Functions: `snake_case` (Python) or `camelCase` (JS/TS)

**Documentation:**

- Docstrings/JSDoc for all public functions
- Type annotations everywhere
- Usage examples in docstrings
- README examples for common use cases

**Formatting:**

```bash
make format          # Auto-format
make check-format    # Check only
```

## Testing Strategy

**Test Coverage Requirements:**

- Minimum 90% code coverage
- All public API functions tested
- Edge cases and error conditions
- Performance benchmarks for critical paths

```bash
# Run tests
[test command]

# Run tests with coverage
[coverage command]

# Run benchmarks
[benchmark command]
```

**Test Organization:**

- Unit tests: `tests/unit/`
- Integration tests: `tests/integration/`
- Property-based tests: For complex logic

## Versioning

**Semantic Versioning:**

- MAJOR: Breaking API changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

**Deprecation Policy:**

1. Mark as deprecated with warning
2. Keep for at least 2 minor versions
3. Remove in next major version

## Known Issues

- **Issue:** [Known limitation or gotcha]
  - **Workaround:** [How users can work around it]

## DO NOT

- ❌ Don't break backward compatibility in minor versions
- ❌ Don't expose internal implementation details
- ❌ Don't add dependencies without careful consideration
- ❌ Don't skip documentation for public APIs

## Performance Considerations

- Benchmark critical paths
- Lazy load heavy dependencies
- Avoid unnecessary allocations
- Document time complexity

## Publishing

```bash
# Build distribution
[build command]

# Run pre-publish checks
[check command]

# Publish
[publish command]
```

**Release Checklist:**

- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped
- [ ] Git tag created

## Documentation

**Required Documentation:**

- **README.md** - Quick start and overview
- **API.md** - Complete API reference
- **CHANGELOG.md** - Version history
- **CONTRIBUTING.md** - Contribution guidelines
- **Examples/** - Usage examples

**Documentation Website:**

- [Link to hosted documentation]

## Dependencies

**Philosophy:**

- Minimize dependencies
- Pin major versions
- Audit security regularly
- Document why each dependency is needed
