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

It does not include:
- UI components
- template or macro languages
- admin tooling
- data fetching or business logic

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

Violations may result in immediate rejection.

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