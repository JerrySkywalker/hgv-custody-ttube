# Project Memory

## Repository Goal

`hgv-custody-tpipe` is the clean MATLAB engineering reconstruction of the dissertation codebase for HGV custody inversion and scheduling. Its purpose is to turn the legacy exploratory MATLAB work into a layered, testable, resumable research pipeline that can later support STK validation and C++/MEX export.

## Legacy Project Position

The old project at `C:\Dev\src\hgv-custody-inversion-scheduling` is a read-only legacy baseline. It is useful for understanding algorithms, experiment intent, naming history, expected outputs, and paper figure lineage. It must not be edited from this repository or from Codex sessions working on this repository.

## New Project Position

The new repository is the engineering home for the refactor. It should hold:

- stable architecture documents under `docs/`;
- codegen-friendly MATLAB core modules under `src/+tpipe/+core`;
- pipeline, cache, backend, visualization, experiment, STK, and export layers with clear boundaries;
- small smoke tests and baseline cases before larger experiments are reintroduced.

## Why Create A New Repository

The old project evolved as a dissertation exploration workspace. It contains valuable working knowledge, but the stage scripts, plotting, caches, runners, and experimental branches are tightly intertwined. A new repository gives the refactor a clean dependency boundary, a stable package namespace, and a place to design code contracts before implementation.

## Why Not Directly Refactor The Old Project

Direct refactoring would risk breaking legacy results that still serve as the comparison baseline. The old code also contains many historical branches for Chapter 4 and Chapter 5, including stage pipelines, bundle runners, diagnostic scripts, and plotting packages. Keeping it read-only preserves reproducibility and allows the new project to migrate behavior in small, verifiable increments.

## Long-Term Codex Rules

- Modify only files inside `C:\Dev\src\hgv-custody-tpipe`.
- Treat `C:\Dev\src\hgv-custody-inversion-scheduling` as read-only evidence.
- Avoid long-running experiments by default.
- Prefer small commits and small functional slices.
- Write durable conclusions into `docs/` so future Codex and ChatGPT sessions can recover context.
- Keep computation, plotting, STK, cache, and export concerns separated.
- Do not migrate large legacy code blocks blindly. First define contracts, baseline cases, and tests.

## MATLAB MCP Boundary

MATLAB MCP may be used for:

- environment and toolbox checks;
- static code analysis;
- startup and path smoke tests;
- tiny deterministic validation cases.

MATLAB MCP should not be used for:

- running old project heavy runners;
- launching large parameter scans;
- running dissertation-scale experiments without explicit user approval.

## Read-Only Legacy Principle

The old project is a source of truth for intent and baseline behavior, not a workspace. Codex may read files and summarize findings. It must not write, format, delete, move, or regenerate files under the old project path.

## Web ChatGPT And Codex Collaboration

Web ChatGPT can reason about architecture, research framing, and migration strategy using copied excerpts from `docs/SESSION_HANDOFF.md` and the other memory docs. Codex should turn those decisions into local files, tests, and code. Each Codex sprint should end by updating `docs/SESSION_HANDOFF.md` with what was read, changed, learned, and what should be asked next.
