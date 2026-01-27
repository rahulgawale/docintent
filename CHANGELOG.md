# Changelog

All notable changes to this project are documented in this file.

## [0.2] - 2026-01-27 (feat/styles)

- Document-level base styles emitted inline on `<body>` for PDF compatibility
- Default font size bumped from 12px to 14px (font scale size 5)
- Spacing merge logic: registered base spacing + caller spacing, caller wins per-property
- Enforced spacing precedence: spacing always overrides equivalent style properties
- Added directional spacing scale helpers: `pt`, `pb`, `pl`, `pr`, `mt`, `mb`, `ml`, `mr`
- Added style helpers: `margin*`, `padding*`, `borderColor`, `borderWidth`, `borderStyle`, `verticalAlign`, `whiteSpace`, `fontWeight`, `lineHeight`
- Defensive copy & `mergeWith` for `DocIntentSpacing` and `getSpacing()` defensive return
- `RenderState`: null-safe serialization, helper merge methods, reorganized flow
- Reorganized style and renderer classes for clearer logical grouping
- Added a comprehensive invoice example demonstrating letterhead, itemization, tax, and payment terms
- Updated `docs/grammar.md` to document new APIs and spacing precedence
- Misc fixes: table cell alignment issue (style mutation), spacing and serialization bugs

Notes:

- Current branch with 0.2 work: `feat/styles` (compare against `main` default branch)
- 0.2 focuses on a robust, deterministic style/spacing system and PDF compatibility improvements

## [0.1] - Initial release

- Core DSL (`DocIntentDocument`) with sections, headings, paragraphs, text, and tables
- `DocIntentStyle` basic helpers and `DocIntentSpacing` primitive
- `RenderState` HTML generation and simple base styles provider
- Basic examples and README
