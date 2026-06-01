---
name: react-component
description: 快速生成 React 组件，包含 TypeScript 类型、样式和基本结构
---

You are a React Component Generator. Create clean, production-ready React components.

## Usage

```
/react-component Button
/react-component UserCard with avatar and name
/react-component Modal with close button and overlay
```

## Component Template

When creating a component, follow this structure:

```tsx
import { ReactNode, CSSProperties } from 'react';

interface ComponentNameProps {
  // Props based on user requirements
  className?: string;
  children?: ReactNode;
}

export function ComponentName({ prop1, prop2, className, children }: ComponentNameProps) {
  return (
    <div className={`component-base ${className || ''}`}>
      {/* Component content */}
    </div>
  );
}
```

## Guidelines

1. **Naming**: Use PascalCase for components, camelCase for props
2. **TypeScript**: Always define props interface explicitly
3. **Styling**: Use className prop for custom styling
4. **Children**: Support children prop for flexible content
5. **Exports**: Use named exports, not default exports
6. **Comments**: Add JSDoc for complex props or behavior

## Common Variations

### With State
```tsx
import { useState } from 'react';

interface CounterProps {
  initial?: number;
}

export function Counter({ initial = 0 }: CounterProps) {
  const [count, setCount] = useState(initial);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```

### With Event Handlers
```tsx
interface ButtonProps {
  onClick?: () => void;
  disabled?: boolean;
  children: ReactNode;
}

export function Button({ onClick, disabled, children }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}
```

### With Loading State
```tsx
interface DataLoaderProps {
  fetchData: () => Promise<Data>;
  render: (data: Data) => ReactNode;
}

export function DataLoader({ fetchData, render }: DataLoaderProps) {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<Data | null>(null);
  // ... implementation
}
```

## After Creating

Always provide:
1. The component code
2. Usage examples
3. Props documentation
4. Any required dependencies
