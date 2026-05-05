# Stage00-05 Legacy Output Audit

Old Stage00 tasks: run startup, load default parameters, set random seed, prepare logs/cache/results directories, and emit self-check summary.

Old Stage01 tasks: build scenario disk, nominal/heading/critical casebanks, summary, and scenario plot.

Old Stage02 tasks: generate nominal/heading/critical trajectory banks, validate trajectories, summarize trajectories, and render trajectory figures.

Old Stage03 tasks: build Walker constellation, produce satbank, compute nominal/heading/critical visibility banks, summarize visibility, and render visibility figure.

Old Stage04 tasks: build window grid, compute information matrices/window metrics, scan worst windows, calibrate `gamma_req`/`gamma_meta`, summarize spectra/margins, and render figures.

Old Stage05 tasks: run nominal Walker search, emit result table and feasible grid, produce feasible/ranking/frontier/heatmap-ready tables, compute Pareto/transition diagnostics, and render plot bundle.

Native E2E equivalence:

- Stage00: covered by `stage00_bootstrap.v0`.
- Stage01: covered by `stage01_casebank_bundle.v0`; old plot is plot-smoke/summary equivalent only.
- Stage02: covered by `stage02_trajbank_bundle.v0`; figures are not pixel-replicated.
- Stage03: covered by `stage03_access_bundle.v0`; old satbank/visbank names are compatibility concepts.
- Stage04: covered by `stage04_window_gamma_bundle.v0`; full large winbank/FIM cache side effects are intentionally avoided.
- Stage05: covered by native Stage05 full bundle; old full runner side effects are not reproduced.
