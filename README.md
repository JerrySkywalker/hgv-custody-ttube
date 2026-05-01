# hgv-custody-ttube

This repository is the clean MATLAB engineering reconstruction of the HGV custody inversion and scheduling codebase.

The old project is treated as a read-only legacy baseline source.

The repository namespace is `hgv-custody-ttube`, and MATLAB code lives under the `+ttube` package. In research text, the core dissertation object is the trajectory tube; `pipeline` remains reserved for software execution flow such as DAGs, cache, manifests, resume, and run status.

## Current stage

- Initialize new repository
- Configure project-level MATLAB MCP
- Build minimal MATLAB smoke-test loop
- Prepare for gradual migration from the old codebase
