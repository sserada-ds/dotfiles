# CLAUDE.md - Web Application

## Project Overview

**Type:** Web Application

**Purpose:** [Description of the app]

**Tech Stack:**

- Frontend: [e.g., React, Vue, Svelte]
- Backend: [e.g., Node.js, Python, Go]
- Database: [e.g., PostgreSQL, MongoDB]
- Styling: [e.g., Tailwind CSS, styled-components]
- State Management: [e.g., Redux, Zustand, Context API]

## Development Setup

```bash
# Install dependencies
npm install  # or yarn install

# Run development server
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

## Architecture

**Frontend Structure:**

```
src/
├── components/     # Reusable UI components
├── pages/          # Page components (routing)
├── hooks/          # Custom React hooks
├── utils/          # Utility functions
├── api/            # API client code
├── store/          # State management
└── styles/         # Global styles
```

**API Endpoints:**

- `GET /api/[resource]` - [Description]
- `POST /api/[resource]` - [Description]

## Coding Standards

**Component Guidelines:**

- Use functional components with hooks
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use TypeScript for type safety

**Naming Conventions:**

- Components: PascalCase (e.g., `UserProfile.tsx`)
- Files: kebab-case for utilities (e.g., `format-date.ts`)
- CSS classes: Follow [BEM / Tailwind / styled-components] conventions

**State Management:**

- [Guidelines for when to use local vs global state]
- [Patterns for async data fetching]

**Formatting:**

```bash
make format          # Prettier, ESLint
make check-format    # Check only
```

## Testing Strategy

- **Unit Tests:** Individual functions and components
- **Integration Tests:** API interactions
- **E2E Tests:** Critical user flows

```bash
npm test              # Run all tests
npm test -- --watch   # Watch mode
```

## Known Issues

- **Issue:** [Common pitfall in this codebase]
  - **Solution:** [How to avoid it]

## DO NOT

- ❌ Don't commit `node_modules/` or build artifacts
- ❌ Don't use inline styles (use [styling solution])
- ❌ Don't fetch data in component render (use hooks/effects)
- ❌ Don't modify [protected files]

## Performance Considerations

- Lazy load routes and heavy components
- Memoize expensive computations
- Optimize images (use next/image or similar)
- Monitor bundle size

## Deployment

```bash
# Build
npm run build

# Preview production build
npm run preview

# Deploy
[deployment command]
```

**Environment Variables:**

- `VITE_API_URL` - Backend API URL
- [Other environment variables]
