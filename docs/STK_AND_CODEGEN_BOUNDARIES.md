# STK And Codegen Boundaries

## Modules That Should Eventually Convert To C++

- `core.traj` numeric propagation kernels and trajectory transforms.
- `core.orbit` Walker generation and simple propagation kernels.
- `core.sensor` LOS, range, FOV, occultation, and measurement Jacobian kernels.
- `core.visibility` access matrix, window extraction, gap, and worst-window kernels.
- `core.estimation` FIM/Gramian, CRLB-like metrics, and compact EKF kernels.
- `core.metrics` DG, DA, DT, ClosedD/OpenD scalar kernels, pass ratio, bubble, and custody time-series kernels.
- selected `core.scheduler` scoring and selection kernels after policy contracts stabilize.

## Modules That Must Not Enter Codegen

- plotting and report generation;
- STK and COM automation;
- file IO, cache, artifact registry, manifest, and resume machinery;
- experiment runners and dissertation bundle scripts;
- interactive configuration and progress dashboards;
- large MATLAB tables as core compute interfaces, except at boundaries.

## Modules That May Exchange Data With STK

- `core.traj`: export target ephemeris to STK and import STK-sampled ephemeris for comparison.
- `core.orbit`: export Walker definitions and compare satellite ephemerides.
- `core.sensor`: map FOV/range/off-nadir constraints to STK sensor/access settings.
- `core.visibility`: compare MATLAB access matrices/windows to STK access reports.
- `pipeline/cache`: orchestrate STK backend runs and store comparison artifacts.

## Backend Relationship

MATLAB core is the reference algorithmic implementation. STK backend is a high-fidelity external geometry and scenario backend. C++/MEX backend is a deployment-oriented compiled implementation of stable core kernels.

The backends should share explicit data contracts rather than call each other directly.

## Backend Selection Per Pipeline Step

A pipeline step should declare:

- step name and semantic output;
- required inputs and artifact fingerprints;
- backend: `matlab_core`, `stk`, `mex`, or `cpp`;
- expected output contract;
- comparison tolerance when multiple backends exist.

For example, an access-window step may run with `matlab_core` for fast scans, `stk` for validation, and `mex` later for speed. The step output should still be an access artifact with the same schema.

## Minimum MVP Consistency Test

The first three-backend MVP should be deliberately small:

1. One short HGV trajectory segment with fixed time grid.
2. One tiny Walker or hand-built satellite set.
3. One simple sensor model with range and LOS constraints.
4. MATLAB core computes access matrix and worst-window metrics.
5. STK backend computes equivalent access windows for the same objects.
6. MEX/C++ backend computes the same core access/window metrics from the same numeric arrays.
7. A comparison report checks time alignment, access-window start/end deltas, visible count deltas, and DG/DT-like scalar deltas within explicit tolerances.

ClosedD/OpenD should not be exported until their exact definitions and baseline cases are frozen.
