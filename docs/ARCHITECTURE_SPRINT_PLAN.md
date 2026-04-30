# Architecture / Memory Sprint Plan

This plan defines the practical completion boundary for the architecture and memory setup work. It is intentionally limited to documentation, package skeletons, data contracts, lightweight validators, smoke tests, and read-only legacy audits.

## Completion Criteria

The architecture/memory sprint is complete when the new repository has:

- durable project memory under `docs/`;
- package skeletons for core, pipeline/cache, viz, STK, and export layers;
- initial data contracts for trajectory, constellation state, access, window, and metric artifacts;
- lightweight validators for those contracts;
- smoke tests that prove startup and contract validators are reachable;
- a migration matrix with unresolved research questions clearly marked;
- focused read-only audit notes for the highest-risk legacy areas;
- an up-to-date `docs/SESSION_HANDOFF.md`.

## Sprint Slices

| Slice | Scope | Status |
|---|---|---|
| Sprint 0 | Project memory, research intent, architecture principles, compute modules, migration matrix, broad legacy audit | Complete |
| Sprint 1 | Package skeleton, data contracts, ClosedD/OpenD audit | Complete |
| Sprint 2 | Contract validators, synthetic fixtures, package smoke tests | Complete |
| Sprint 3 | STK/codegen boundary audit and MVP consistency plan refinement | Complete |
| Sprint 4 | Chapter 5 scheduler/bubble taxonomy audit | Pending |
| Final | Update handoff, backlog, and test summary | Pending |

## Non-Goals

- No algorithm migration from the old project.
- No long-running MATLAB experiments.
- No STK automation run unless explicitly requested.
- No C++/MEX generation.
- No dissertation figure reproduction.

## Commit Policy

Use small commits by slice:

- one commit for stable documentation/skeleton changes;
- one commit for lightweight MATLAB stubs/tests;
- one commit for each focused audit;
- one final commit for handoff and backlog updates.
