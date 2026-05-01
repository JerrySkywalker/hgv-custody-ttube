# STK / Codegen Focused Audit

## Scope

Sprint 3 performed a read-only audit of old-project STK and C++/MEX/codegen evidence. No STK automation, MATLAB Coder, MEX build, or old runner was executed.

## Files Read Or Searched

Read directly:

- `src/analysis/build_stk_walker_scenario_geometry.m`
- `src/analysis/check_stk_matlab_availability.m`
- `src/analysis/stk_export_satellite_states.m`

Searched:

- STK/COM terms: `STK`, `actxserver`, `COM`, `IAg`, `AgStk`, `Connect`, `Scenario`, `Satellite`, `Sensor`, `Access`.
- codegen/export terms: `codegen`, `coder.`, `coder.config`, `coder.typeof`, `MATLAB Coder`, `mex`, `MEX`, `C++ export`.

## STK Findings

The old STK integration is partial and scenario-oriented.

`check_stk_matlab_availability` checks Windows COM availability by scanning configured STK ProgIDs in the registry and verifying `actxserver` availability.

`build_stk_walker_scenario_geometry` creates an STK scenario through COM, configures time period, creates satellites from the Stage03 Walker definition, sets classical orbital states through STK command strings, exports satellite state reports, and assembles a geometry struct for shared scenario visualization. If STK report export fails, it falls back to Stage03 propagation and ECI-to-ECEF conversion.

`stk_export_satellite_states` calls STK `ReportCreate`, attempts several report styles, normalizes the exported table to `time_s`, `x_km`, `y_km`, `z_km`, and mirrors the CSV export.

Key limitation: the observed STK code validates constellation/scenario geometry and satellite state export. Sprint 3 did not find a mature STK access-window adapter for target-sensor access reports. That should be designed in the new `src/+ttube/+stk` layer instead of copied from legacy code.

## Codegen / C++ Findings

No mature MATLAB Coder, MEX, C++ export, `coder.config`, or generated-code project lineage was found in the old project during Sprint 3 search.

Some Stage15 files use words like kernel, static world, pair bank, and template, but these appear to be MATLAB analysis kernels and dataset builders, not MATLAB Coder or C++ export infrastructure.

Conclusion: `src/+ttube/+export` and `codegen/` in the new repository should be greenfield. They should target stable numeric core kernels only after contracts and baseline tests are accepted.

## STK Adapter Boundary For New Repo

`src/+ttube/+stk` should own:

- STK availability checks;
- scenario creation;
- object naming and cleanup policy;
- trajectory ephemeris export/import;
- Walker constellation creation;
- sensor object creation;
- STK access report export;
- conversion of STK reports into `DATA_CONTRACTS.md` artifacts.

It must not live in core modules. It may depend on pipeline artifacts and core data contracts, but core must not call STK.

## Codegen Boundary For New Repo

`src/+ttube/+export` and `codegen/` should own:

- MATLAB Coder entrypoints;
- fixed-size or bounded-size type definitions;
- MEX/C++ build scripts;
- generated report capture;
- backend parity tests.

The first codegen candidates should be pure numeric kernels only:

- vector geometry checks;
- access mask from numeric states and sensor parameters;
- window index extraction;
- gap metrics;
- DG/DA/DT scalar kernels after definitions are frozen.

Do not export:

- MATLAB tables;
- file IO;
- STK/COM;
- plotting;
- cache/manifest code;
- experiment runners;
- variable-shape historical structs from the old project.

## Three-Backend MVP Refinement

Minimum backend consistency plan:

1. Define a tiny synthetic trajectory artifact and constellation state artifact.
2. MATLAB core computes access and window artifacts.
3. STK adapter builds equivalent objects and exports access windows or state/geometry reports.
4. MEX backend later computes the same access/window outputs from numeric arrays.
5. Pipeline/cache stores all outputs with backend labels.
6. A comparison step checks:
   - time grid alignment;
   - visible count agreement;
   - access-window start/end deltas;
   - gap metric deltas;
   - DG/DT-like scalar deltas only after metric definitions are frozen.

## Risks

- STK time formatting and epoch semantics can diverge from MATLAB core.
- STK report columns and units may vary by report style or installation.
- COM automation is Windows-specific and should remain optional.
- Legacy fallback behavior can hide STK failure if not recorded explicitly.
- Codegen will fail if core accepts tables or unbounded nested structs.

## Open Questions

- Which STK access report style should be the first supported target for parity tests?
- Should STK be treated as a validation backend only, or as an alternate production backend for high-fidelity artifacts?
- What tolerances are acceptable for STK versus MATLAB core access-window boundaries?
- Which core kernel should be the first MEX export candidate: access mask, window extraction, gap metric, or DG scalar?
