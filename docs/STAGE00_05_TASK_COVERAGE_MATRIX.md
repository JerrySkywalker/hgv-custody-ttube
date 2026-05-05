# Stage00-05 Task Coverage Matrix

| old stage | old task | old output | new module | new output | status | test | notes |
|---|---|---|---|---|---|---|---|
| Stage00 | startup/default params/seed | self-check cache/log | `ttube.experiments.stage00` | `stage00_bootstrap.v0` | covered | `test_stage00BootstrapNative` | Native summary, not old cache filename. |
| Stage00 | logs/cache/results dirs | directory tree | `runStage00Bootstrap` | run/output/log/cache/table/fig dirs | covered | `test_stage00BootstrapNative` | Uses run-local tree. |
| Stage01 | scenario disk | scenario summary | `ttube.experiments.stage01` | `stage01_casebank_bundle.v0.summary` | covered | `test_stage01CasebankBundle` | Geodetic native approximation. |
| Stage01 | casebank nominal/heading/critical | casebank structs | `stage01` builders | nominal/heading/critical cases | covered | `test_stage00To05OutputCompleteness` | Profile-controlled counts. |
| Stage01 | scenario plot | figure | future viz/report | plot-smoke equivalent only | partial | E2E report | Pixel parity not attempted. |
| Stage02 | trajbank nominal/heading/critical | trajbank | `ttube.experiments.stage02` | `stage02_trajbank_bundle.v0` | covered | `test_stage02TrajbankBundle` | Backend `native_vtc`. |
| Stage02 | trajectory validation | validation summary | `validateTrajectoryArtifact` | bundle validation status | covered | `test_stage02TrajbankBundle` | Native contract validation. |
| Stage02 | trajectory figures | figures | future viz/report | summary equivalent | partial | E2E report | Pixel parity not attempted. |
| Stage03 | Walker constellation/satbank | satbank | `ttube.experiments.stage03` | walker + constellation artifact | covered | `test_stage03AccessBundle` | Native circular Walker. |
| Stage03 | visbank families | visbank | `runStage03VisibilityPipeline` | visbank nominal/heading/critical | covered | `test_stage03AccessBundle` | Native access artifacts. |
| Stage03 | visibility figure | figure | future viz/report | summary equivalent | partial | E2E report | Pixel parity not attempted. |
| Stage04 | window grid | winbank | `ttube.experiments.stage04` | `stage04_window_gamma_bundle.v0` | covered | `test_stage04WindowGammaBundle` | Large full winbank not dumped. |
| Stage04 | FIM/window metrics | matrix bank | `core.estimation` via Stage04 bundle | small metrics subset + summary | partial | `test_stage04WindowGammaBundle` | Avoids large FIM artifacts. |
| Stage04 | gamma/meta/worst window | gamma summary | `runStage04WindowWorstcase` | `gamma_req`, `gamma_meta`, worst summary | covered | `test_stage04WindowGammaBundle` | Manual/default gamma supported. |
| Stage05 | nominal Walker search | result grid | `ttube.experiments.stage05` | `stage05_search_bundle.v0.search` | covered | `test_stage05FromStage04Bundle` | Native full pipeline. |
| Stage05 | feasible/ranking/frontier | tables | Stage05 summary/frontier | summary/frontier artifacts | covered | `test_stage00To05OutputCompleteness` | Native table equivalents. |
| Stage05 | heatmaps/Pareto/plots | figures/tables | Stage05 full native | Pareto/transition + plot bundle metadata | covered | `test_stage05FullNativePipeline` | Plot smoke, not pixel parity. |
