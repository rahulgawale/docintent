# Contributing to DocIntent

Thanks for your interest in contributing to DocIntent.

DocIntent is intentionally **small, opinionated, and constrained**. Please read this before opening a PR.

## Project scope

DocIntent is:
- a document intent engine
- focused on deterministic PDF generation
- built entirely in Apex

DocIntent is **not**:
- a UI builder
- a template engine
- an admin tool
- a replacement for Conga feature parity

## What we welcome

- bug fixes
- performance improvements
- clearer error handling
- better tests
- documentation improvements

## What we do not accept

- new rendering targets (Word, Excel, etc.) in core
- template DSLs
- implicit loops or bindings
- convenience shortcuts that weaken guarantees

## Code guidelines

- Keep public API surface minimal
- Prefer explicit over clever
- Fail fast and loudly
- Every structural rule must be enforced by code

## Tests

All non-trivial changes must include Apex tests.
Tests should assert:
- valid transitions
- invalid transitions
- deterministic output behavior

## Philosophy

DocIntent favors:
- boring correctness
- explicit intent
- long-term maintainability

If a change makes the engine harder to reason about, it does not belong here.
