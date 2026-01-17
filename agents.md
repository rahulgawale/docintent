# Agents & Automated Contributions

This repository contains **DocIntent Core**, a low-level Apex engine for document rendering.

Automated tools, AI agents, and scripted contributions are welcome **only if** they respect the architectural constraints of the project.

## Non-negotiable rules

- This project is **Apex-only**
- No LWC, Aura, JavaScript, or frontend tooling
- No templates, DSLs, or macro languages
- No implicit data binding or magic context
- No UI or admin-facing abstractions

## Architectural intent

DocIntent is built around:
- streaming rendering
- explicit structure
- stack-based validation
- deterministic output

Any contribution that adds:
- hidden state
- implicit behavior
- convenience abstractions that obscure control

will be rejected.

## How to contribute with agents

AI-generated contributions must:
- follow existing naming conventions
- respect package boundaries
- include Apex tests
- explain *why* a change exists, not just *what* it does

Correctness and clarity matter more than cleverness.
