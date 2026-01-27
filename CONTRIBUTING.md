# Contributing to DocIntent

Thank you for your interest in contributing to DocIntent.

DocIntent is a **low-level document intent engine** for Salesforce. It is intentionally constrained, opinionated, and strict by design.

Please read this document fully before opening an issue or pull request.

---

## Project scope

DocIntent focuses on one thing:

> Deterministic document generation in Apex using explicit structure and streaming rendering.

Contributions that move the project outside this scope will not be accepted.

---

## Core design principles

All contributions must preserve the following principles:

- Explicit structure over implicit behavior
- Deterministic output over convenience
- Business logic lives in Apex, not templates
- Streaming rendering, not DOM or tree building
- Fail fast and loudly on invalid usage
- **Fluent DSL integrity must be maintained at all costs**
- **Mutable state is strictly forbidden in public APIs**

**DocIntent will reject contributions even if they are useful when they weaken determinism or explicit structure.**

These constraints are intentional and non-negotiable.

---

## Critical: DSL structure and immutability

**The fluent DSL is the foundation of DocIntent. Breaking it is grounds for immediate rejection.**

### DSL rules

1. **All fluent methods must return `this` or the builder instance**
   - Method chaining must never break
   - Example: `doc.section().heading('X').paragraph('Y').endSection()`

2. **No setter methods that mutate completed structures**
   - Once a section/table/row is closed, it cannot be modified
   - No `updateHeading()`, `replaceCell()`, or similar mutation APIs

3. **No stateful builders that change behavior based on call order**
   - Each method call must be deterministic
   - No hidden modes or flags that alter subsequent behavior

4. **Document structure is write-once**
   - After calling `toPdf()` or `toHtml()`, the document is frozen
   - No "rebuild" or "regenerate" methods

5. **All validation happens immediately**
   - Invalid structure throws immediately
   - No deferred validation or "lazy" error checking

### Immutability rules

**Mutable state is forbidden** in public APIs and user-facing classes.

**Allowed mutable state** (internal only):

- Rendering buffers during streaming output
- Stack state for structure validation
- Temporary variables within method scope

**Forbidden mutable state**:

- Public setters on document/section/table objects
- State that changes rendering behavior after construction
- Caches that affect output determinism
- Configuration that can be modified mid-rendering

**Example of forbidden pattern:**

```apex
// FORBIDDEN: mutable state after construction
DocIntentDocument doc = DocIntentDocument.create();
doc.section().heading('Title').endSection();
doc.setGlobalFontSize('14px'); // NO - mutates after creation
doc.toPdf();
```

**Example of allowed pattern:**

```apex
// ALLOWED: configuration before any rendering
DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new MyStyles());
doc.section().heading('Title').endSection();
doc.toPdf();
```

### Violations that will be rejected

- Adding `set*()` methods to public APIs
- Introducing "edit mode" or "draft mode" concepts
- Creating mutable configuration objects
- Adding methods that require calling them in a specific sequence beyond the DSL structure
- Breaking method chaining in any way
- Adding state that changes rendering semantics
- **Exposing internal registries or state mutation methods (e.g., `registerStyle`, `registerSpacing`)**

**Why registry methods were removed:**

Earlier versions exposed `doc.registerStyle()` and `doc.registerSpacing()` methods. These violated encapsulation by:

- Allowing mutation after document structure had begun
- Introducing ordering dependencies (when to register vs when to render)
- Exposing internal `RenderState` mechanisms
- Contradicting the base styles provider model

The correct pattern is to use `DocIntentBaseStyles` implementations passed via `withBaseStyles()` before any rendering begins.

**If in doubt, ask first. DSL and immutability violations are non-negotiable.**

---

## Folder structure guidelines

DocIntent follows a strict package and folder structure. Contributions must respect these boundaries.

### `api/`

Public, documented entry points and fluent builder APIs.

- Contains only the supported public surface
- Classes here may be `public`
- No implementation details
- No direct rendering logic

Examples:

- `DocIntentDocument`
- `DocIntentSection`

---

### `model/`

Domain and structural concepts.

- Enums and value objects
- Describes _what exists_, not _how it is rendered_
- No behavior-heavy logic

Examples:

- `DocIntentNodeType`
- Style or layout value objects

---

### `internal/`

Implementation details and engine internals.

- Stack management
- Validation logic
- Orchestration helpers
- Rendering coordination

Rules:

- Not part of the public API
- May change without notice
- Must not be referenced by consumers

Examples:

- `RenderStack`
- Transition validators
- Internal state holders

---

### `render/` and `pdf/`

Output-specific rendering logic.

- HTML generation
- PDF orchestration
- Format-specific behavior

No domain rules should live here.

---

### General rules

- Do not introduce new top-level folders without discussion
- Do not create generic buckets like `util`, `common`, or `helpers`
- Folder placement communicates intent; treat it as part of the API design

---

## Formatting rules (Apex)

- Indentation: **2 spaces**
- Maximum line length: **80 characters**
- Braces: opening brace on the **same line**
  ```apex
  if (condition) {
      // code
  }
  ```
- One blank line between methods: required
- Blank lines within methods: discretionary
- Trailing whitespace: not allowed
- PRs that ignore formatting rules may be rejected without review.

## Comments & documentation

- Prefer minimal comments
- Code should speak for itself
- Comments are expected only to explain why, not what
- Descriptive comments are allowed when intent is not obvious
- Javadoc-style comments are required for public API classes and methods

## Naming conventions

### Classes

- All public API classes must be prefixed with DocIntent
- Internal classes (inside internal) must use plain, meaningful names
- No generic names such as Utils, Helper, or Manager

### Methods

- Public fluent builder APIs may use nouns:
  `section()`, `table()`, `row()`, `cell()`
- Imperative or internal methods must be verb-first:
- `renderSection`, `openTable`, `validateTransition`

### Variables

- `camelCase` only
- Single-letter variables are discouraged except in very small scopes

### Constants

- `ALL_CAPS`
- Defined in the same class or a dedicated constants class
- Never global

### Access modifiers & packaging

- public is allowed only for the documented API surface
- All other members should be private unless strictly required
- protected usage is discouraged and must be justified
- The global keyword is completely forbidden
- Internal packages may be accessed only by the API layer

### Error handling

- Custom exceptions are preferred
- All exceptions must extend RenderException
- Errors must be thrown immediately when invalid structure is detected
- No silent recovery, lenient modes, or “best effort” behavior

### Tests

- Test class naming: `<ClassName>Test`
- Minimum coverage: 90%
- Behavior tests are mandatory; coverage alone is insufficient
- Every new public API must include negative tests
- Tests should assert:
- structural correctness
- invalid transitions
- deterministic ordering

### Pull request hygiene

- One concern per pull request (strictly enforced)
- Small, focused commits are preferred
- Refactors are allowed only if:
- behavior is unchanged
- tests prove equivalence

Large or mixed-scope PRs may be rejected without partial review.

## Philosophy

DocIntent values:

- clarity over cleverness
- correctness over flexibility
- long-term maintainability over short-term convenience

Not every good idea belongs in this repository.
