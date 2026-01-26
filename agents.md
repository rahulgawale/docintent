# AGENTS.md

This repository contains **DocIntent Core**, a low-level Apex document intent engine.

Automated tools, AI agents, and Copilot-assisted contributions are permitted **only** if they respect the architectural and philosophical constraints of the project.

---

## Scope boundaries

DocIntent Core is strictly limited to:

- document structure
- stack-based validation
- rendering orchestration
- PDF output via Salesforce native APIs

Agents must not introduce abstractions outside this scope.

---

## Non-negotiable rules for automated contributions

AI-generated or assisted changes must not:

- introduce implicit behavior or hidden state
- weaken determinism or explicit structure
- bypass stack-based validation
- soften, suppress, or auto-recover from errors
- add convenience APIs that obscure intent
- expand the public API surface without discussion
- **break the fluent DSL structure or introduce mutable state**
- **modify objects after creation in ways that violate immutability**
- **add methods that require state mutation to function correctly**

Violations may result in immediate rejection.

---

## Critical: DSL integrity and immutability

**The fluent DSL and deterministic rendering are non-negotiable.**

AI tools must **never**:

- Break method chaining patterns
- Introduce setter methods that mutate state after construction
- Add stateful objects that change behavior based on call order
- Create APIs that require re-initialization or reset
- Allow document modification after `toPdf()` or `toHtml()` is called
- Introduce caching that changes semantics
- Add "builder reset" or "clear" methods

**All fluent methods must:**

- Return `this` or the builder instance
- Preserve immutability of completed structures
- Maintain explicit, predictable call ordering
- Fail immediately on invalid state transitions

**Mutable state is forbidden** except:

- Internal rendering buffers during streaming output
- Stack state used strictly for validation
- Temporary variables within method scope

Any introduction of user-facing mutable state will be rejected without discussion.

---

## Copilot / AI PR requirements

All PRs that use AI assistance must:

- Explicitly state **“AI-assisted”** in the PR description
- Clearly explain the **design intent** of the change
- Avoid over-abstraction or speculative generalization
- Preserve existing public APIs and error semantics
- Include Apex tests where behavior changes

AI assistance does not reduce the standard of review.

---

## Forbidden AI actions

AI tools may **not**:

- introduce new public APIs
- refactor core architecture
- change error semantics or validation rules

Such changes require prior discussion and human authorship.

---

## Review & enforcement

All contributions, human or automated, are reviewed under the same standards.

Maintainers may reject changes without extended discussion if:

- determinism is weakened
- implicit behavior is introduced
- scope creep is detected

Correctness and clarity take precedence over convenience.
