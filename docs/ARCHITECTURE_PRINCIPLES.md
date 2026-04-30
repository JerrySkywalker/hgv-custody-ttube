# Architecture Principles

## Backend Roles

MATLAB is the research mother implementation. It is where equations, baselines, tests, and dissertation experiments are developed first.

C++/MEX is the deployment outlet. Only stable, codegen-friendly computational kernels should cross this boundary.

STK is the high-fidelity backend for scenario construction, object modeling, orbital/geometry cross-checks, and validation against an external astrodynamics environment.

## Core Layer Rules

The core layer must be as codegen-friendly as practical. It should prefer numeric arrays, plain structs, deterministic functions, explicit units, and stable data contracts.

The core layer must not contain:

- plotting;
- STK calls;
- COM automation;
- file IO;
- cache or artifact registry logic;
- experiment runners;
- MATLAB handle graphics;
- complex object systems that block code generation.

## STK Boundary

STK code belongs only under `src/+tpipe/+stk`. That layer may translate MATLAB core contracts into STK objects and translate STK access, geometry, or ephemeris results back into pipeline artifacts.

## Export Boundary

MATLAB Coder and C++/MEX export code belongs under `src/+tpipe/+export` and `codegen/`. Export wrappers should depend on core functions, not on pipeline, viz, STK, or experiment code.

## Viz Boundary

`viz` only renders already-computed data. It may compute lightweight display transforms, but it must not recompute trajectory propagation, access windows, FIM/Gramian, D-series metrics, or scheduler decisions.

## Pipeline And Cache Boundary

`pipeline/cache` owns DAG steps, artifacts, manifests, fingerprints, run metadata, and resume behavior. It calls core functions and backend adapters, then records outputs in a reproducible artifact layout.

## Experiment Boundary

`experiments` organizes Chapter 4 and Chapter 5 studies. It chooses parameters, cases, and report packs. It must not become the home of core algorithms.

## Layer Direction

Allowed direction:

`experiments -> pipeline/cache -> core`

`experiments -> viz`

`pipeline/cache -> stk`

`export -> core`

Avoid reverse dependencies from core into pipeline, viz, STK, export, or experiments.
