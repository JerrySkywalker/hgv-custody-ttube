# Stage00-05 Native E2E Output Contract

Created: 2026-05-05
Branch: `codex/stage00-05-e2e-verification`

## Artifact Families

`stage00_bootstrap.v0` records project root, MATLAB version, timestamp, random seed, output paths, startup status, and optional test status.

`stage01_casebank_bundle.v0` records nominal, heading, and critical case families, scenario parameters, case counts, summary, and backend metadata.

`stage02_trajbank_bundle.v0` records trajectory banks for nominal, heading, and critical families, validation status, summary statistics, and trajectory backend.

`stage03_access_bundle.v0` records Walker constellation state, access/visibility banks for nominal, heading, and critical families, per-family visibility summaries, and backend metadata.

`stage04_window_gamma_bundle.v0` records window settings, gamma requirement, gamma metadata, per-family window summaries, worst-window summaries, and a controlled small metrics subset.

`stage05_search_bundle.v0` records native Stage05 search result, summary, frontier, Pareto/transition artifact, and plot bundle.

`stage00_05_run_manifest.v0` records all stage artifact schemas, output files, run profile, status file, producer, and timestamp.

`stage00_05_reproduction_report.v0` records old task coverage, native outputs, compatibility outputs, partial items, plot-smoke status, and cache side-effect policy.

## Native Coverage Policy

Native generation covers the main computational outputs for Stage00-05: bootstrap, casebanks, trajectory banks, access banks, window/gamma summaries, and Stage05 search/postprocess/plot bundle.

Compatibility outputs are table/summary/manifest equivalents for old cache and report products. The new pipeline does not reproduce old cache filenames or all side effects.

Legacy plots are not pixel-replicated. Plot support is verified by smoke rendering and by checking that viz consumes artifacts without recomputing metrics.

Partial outputs: old full Stage00-05 cache side effects, exact old figure appearance, and any large legacy `winbank`/FIM dump are intentionally not reproduced in Git-tracked outputs.
