# Migration Master Plan

## 1. Purpose

This document is the master migration plan for `hgv-custody-ttube`.

The goal is not to copy the old Stage-based MATLAB code into a new folder. The goal is to reconstruct the reusable computational system behind the old dissertation codebase:

- trajectory-tube modeling
- space-based sensing geometry
- worst-window observability and custody metrics
- static inverse constellation design
- dynamic custody-oriented scheduling
- resumable pipeline execution
- future STK validation
- future C++/MEX export

The old repository remains a read-only baseline source:

```text
C:\Dev\src\hgv-custody-inversion-scheduling
```

The new repository is the engineering reconstruction:

```text
C:\Dev\src\hgv-custody-ttube
```

## 2. Terminology

| Chinese | English | Meaning |
| --- | --- | --- |
| 轨迹管道 | Trajectory Tube | Dissertation core object: trajectory-family envelope and time-evolving support domain. |
| 连续托管 | Continuous Custody | Mission objective: persistent task-useful sensing support. |
| 最坏窗口 | Worst Window | Sliding-window interval where support or observability is weakest. |
| 可观性空泡 | Observability Bubble | Local degradation or loss region in support, geometry, or requirement margin. |
| 可观测性格莱米场 | Observability Gramian Field | Observability analysis tool or future estimation/observability submodule. |
| 计算流水线 | Pipeline | Software execution flow: DAG, cache, artifacts, manifest, resume, run status. |

Deprecated terms:

- trajectory pipe
- trajectory pipeline as a research-object term
- tpipe

Pipeline remains valid only for software execution flow.

## 3. Migration Principle

The old Stage series is a research-development sequence, not the target software architecture.

The new architecture should migrate capabilities, not Stage scripts.

Every legacy Stage should be decomposed into:

- reusable computational kernels
- data contracts and artifacts
- experiment recipes
- cache/progress/resume logic
- visualization/reporting
- baseline comparison cases

Target placement:

| Legacy concern | New location |
| --- | --- |
| Numeric trajectory, orbit, visibility, metrics | `src/+ttube/+core` |
| Trajectory tube family and envelope organization | `src/+ttube/+tube` or later equivalent |
| Experiment definitions | `src/+ttube/+experiments` |
| DAG, artifact, cache, status, resume | `src/+ttube/+pipeline`, `src/+ttube/+cache` |
| Figures and paper views | `src/+ttube/+viz` |
| STK integration | `src/+ttube/+stk` |
| MATLAB Coder / MEX / C++ export | `src/+ttube/+export`, `codegen/` |
| Legacy comparison data | `legacy_reference/golden_small` |

## 4. Legacy Stage Map

### Stage00: Bootstrap and environment self-check

Old purpose:

- initialize startup
- load default parameters
- create result/cache/log folders
- fix random seed
- produce a minimal self-check cache

Migration target:

- `scripts/check_environment.m`
- smoke tests
- `ttube.pipeline.createRunStatus`
- no formal research Stage in the new architecture

### Stage01: Scenario disk and casebank construction

Old purpose:

- construct protected disk scenario
- generate nominal, heading, and critical casebanks
- optionally anchor geometry to geodetic ENU/ECEF/ECI coordinates
- produce scenario summary and plot

Migration target:

- trajectory-tube casebank builder
- scenario/case contract
- family labels: nominal, heading, critical
- no plotting inside casebank construction

Target modules:

- `ttube.core.traj`
- future `ttube.tube`
- `ttube.experiments.ch4`

### Stage02: HGV trajectory generation

Old purpose:

- load Stage01 casebank
- propagate nominal, heading, and critical HGV trajectories
- output trajbank with ENU/ECEF/ECI states
- validate and summarize trajectories
- generate plots

Migration target:

- trajectory generator registry
- HGV propagation core
- trajectory artifact contract
- trajectory-tube family packaging
- plotting separated into viz

Target modules:

- `ttube.core.traj`
- future `ttube.tube`
- `ttube.pipeline/cache`

### Stage03: Walker constellation and visibility pipeline

Old purpose:

- load Stage02 trajectories
- build a single-layer Walker constellation
- propagate satellites
- compute visibility/access matrices
- output satbank, visbank, summary

Migration target:

- Walker generator as one constellation backend
- sensor model and access matrix core
- access artifact contract
- later STK parity for access windows

Target modules:

- `ttube.core.orbit`
- `ttube.core.sensor`
- `ttube.core.visibility`
- `ttube.stk`

### Stage04: Window worst-case and information matrix

Old purpose:

- load satbank/visbank
- build sliding windows
- compute window information matrices
- scan worst windows
- calibrate gamma_req
- output winbank, gamma metadata, spectral/margin statistics

Migration target:

- window-index extraction
- FIM/Gramian assembly
- requirement calibration
- worst-window summary
- all figure/report generation separated from core

Target modules:

- `ttube.core.visibility`
- `ttube.core.estimation`
- `ttube.core.metrics`

### Stage05: Nominal-family Walker static search

Old purpose:

- inherit gamma_req
- search Walker designs over `(h, i, P, T, F)` or subsets
- evaluate nominal trajectory family
- produce feasible grid, pass ratio, inclination frontier, heatmaps, Pareto/transition plots

Migration target:

- reusable grid-search pipeline
- static inverse design experiment recipe
- metric artifact output
- visualization consumes computed artifacts only

Target modules:

- `ttube.experiments.ch4.staticInverseDomain`
- `ttube.pipeline`
- `ttube.core.metrics`
- `ttube.viz.ch4`

### Stage06: Heading-family Walker search

Old purpose:

- define heading perturbation ranges
- build heading family
- run Walker search
- compare with Stage05 nominal results
- plot heading robustness

Migration target:

- trajectory-tube family robustness study
- reuse same grid-search pipeline as Stage05
- treat heading as one perturbation family, not a special Stage-only workflow

Target modules:

- future `ttube.tube`
- `ttube.experiments.ch4.familyRobustnessStudy`
- `ttube.core.metrics`

### Stage07: Critical geometry and reference Walker

Old purpose:

- select reference Walker from Stage05/06
- define C1/C2 critical geometry
- scan heading-risk maps
- select representative nominal/C1/C2 examples
- generate dissertation plots and notes

Migration target:

- reference-design selector
- critical-case selector
- risk-map artifact
- paper plots and figure notes as report/viz outputs

Target modules:

- `ttube.experiments.ch4.selectReferenceDesign`
- `ttube.experiments.ch4.selectCriticalCases`
- `ttube.viz.ch4`

### Stage08: Window-length scan and final window selection

Old purpose:

- define Tw grid
- scan representative cases
- scan full casebank statistics
- scan small-grid search around reference Walker
- analyze boundary window sensitivity
- recommend final window length

Migration target:

- requirement-window study
- reusable window sensitivity metrics
- RequirementSpec or equivalent artifact
- no new search algorithm separate from pipeline

Target modules:

- `ttube.core.visibility`
- `ttube.core.metrics`
- `ttube.experiments.ch4.windowRequirementStudy`

### Stage09: Formal inverse feasible-domain scan

Old purpose:

- prepare task spec
- optionally validate window kernel and single design
- build feasible domain over design variables
- extract minimum boundary
- produce DG/DA/DT/joint metric packs and layered plots

Migration target:

- formal static inverse design experiment
- frozen DG/DA/DT contracts
- joint feasibility contract
- minimum boundary extractor
- layered visualization suite

Target modules:

- `ttube.core.metrics.computeDG`
- `ttube.core.metrics.computeDA`
- `ttube.core.metrics.computeDT`
- `ttube.core.metrics.computeJointFeasibility`
- `ttube.experiments.ch4.staticInverseDomain`
- `ttube.viz.ch4`

### Stage10: Spectral structure, bcirc prototype, FFT validation, screening

Old purpose:

- truth structure diagnostics
- block-circulant prototype
- legal baseline
- FFT spectral validation
- symmetry-breaking margin
- screening benchmark/refinement
- final report pack

Migration target:

- optional acceleration/certificate layer after core metrics are stable
- screening must be conservative and validated
- not part of early migration

Target modules:

- `ttube.core.estimation.spectralApprox`
- `ttube.core.metrics.screeningRule`
- `ttube.experiments.ch4.screeningBenchmark`

### Stage11: Tightened geometric certificates

Old purpose:

- build input dataset from Stage10 outputs
- compute weak partition, subspace bounds, block bounds, joint bounds
- run sanity/diagnosis
- export CSV, figures, report, cache

Migration target:

- certificate/bound layer after metrics and screening contracts are stable
- do not migrate early
- separate bound kernels from reporting

Target modules:

- `ttube.core.metrics.certificate`
- `ttube.experiments.ch4.certificateStudy`

### Stage12A: Truth baseline kernel

Old purpose:

- build a controlled truth baseline for a chosen case, theta, and window
- compute DG/DA/DT truth with Stage09 evaluator

Migration target:

- golden baseline generator
- regression fixture source
- not a core algorithm

Target modules:

- `ttube.experiments.baseline.makeTruthBaselineCase`
- `legacy_reference/golden_small`

### Stage12B: Truth case-window scan

Old purpose:

- compute full window-level truth curves for one case/theta pair
- generate per-window DG/DA/DT and gap metrics
- mark worst windows

Migration target:

- high-value regression baseline
- should be used after core window/gap/metric contracts are stable

Target modules:

- `ttube.experiments.baseline.windowTruthCurve`
- `tests/regression/legacy`

### Stage12C: Inverse slice packager

Old purpose:

- package constellation-parameter slices such as `(h, i)` and `(P, T)`
- call Stage09 feasible-domain scan
- produce view tables and summaries

Migration target:

- experiment recipe and report packaging
- not a separate computation kernel

Target modules:

- `ttube.experiments.ch4.sliceStudy`

### Stage12D: Task-side slice packager

Old purpose:

- package nominal/heading/critical task slices
- call Stage09 feasible-domain scan
- summarize casebank composition and fail partitions

Migration target:

- trajectory-tube family robustness report

Target modules:

- `ttube.experiments.ch4.taskFamilySliceStudy`

### Stage12E: Minimum-design packager

Old purpose:

- collect Stage12 results
- extract dissertation-facing minimum design
- generate boundary table, near-optimal table, dominant constraint distribution

Migration target:

- report layer consuming metric artifacts
- no recomputation

Target modules:

- `ttube.experiments.ch4.packageMinimumDesignReport`

### Stage13: Baseline neighborhood search

Old purpose:

- build candidate neighborhood around baseline
- evaluate candidates
- form signature table, tier map, summary table
- generate case-vs-baseline comparisons and dissertation export

Migration target:

- local candidate manager
- neighborhood-search experiment recipe
- paper export layer

Target modules:

- `ttube.experiments.ch4.neighborhoodSearch`
- `ttube.experiments.ch4.candidateManager`

### Stage14: OpenD / RAAN / phase / orientation sensitivity

Old purpose:

- raw RAAN grid scan
- fixed-design RAAN profile
- Ns envelope
- multi-Ns and multi-inclination statistics
- joint phase-orientation sensitivity
- joint phase Ns pass-ratio fusion

Migration target:

- OpenD as artifact family, not a single scalar
- first define scan/profile/envelope artifacts
- use DG-only compatibility initially unless research contract changes

Target modules:

- `ttube.experiments.ch4.openOrientationStudy`
- `ttube.viz.ch4.plotOpenDProfiles`
- `OpenDScanArtifact`
- `OpenDProfileArtifact`
- `OpenDEnvelopeArtifact`

### Stage15: Template/prior/local-kernel analysis line

Old purpose:

- not part of formal Stage00-14 run chain
- contains template family, local pair/triplet kernel, 3D schema, continuous prior, mapping fit, and holdout validation ideas

Migration target:

- do not migrate now
- later evaluate as prior/observability/local-kernel research branch

Potential future modules:

- `ttube.obsgram`
- `ttube.core.estimation.localKernel`
- `ttube.scheduler.prior`
- `ttube.experiments.ch5.priorCalibration`

## 5. Six-Batch Migration Roadmap

### Batch 1: Pure core primitives with synthetic tests

Status: completed in the new `+ttube` namespace with synthetic smoke/unit tests.

Corresponds to lowest-level functionality used by Stage03/04/08/09 and Ch5.

Scope:

- window-index extraction
- gap/outage segment summarization
- artifact validators
- minimal run status
- synthetic MATLAB tests for the pure primitives and contracts

Why first:

- no old project dependency
- easy to test with synthetic arrays
- establishes clean core/pipeline separation
- prevents old Stage script habits from contaminating the new architecture

Representative modules:

- `ttube.core.visibility.extractWindowIndices`
- `ttube.core.metrics.summarizeGapSegments`
- `ttube.pipeline.createRunStatus`

Completed Batch 1 contents:

- contract validators for trajectory, constellation state, access, window, and metric artifacts;
- `ttube.core.visibility.extractWindowIndices`;
- `ttube.core.metrics.summarizeGapSegments`;
- pipeline `status.json` progress MVP;
- smoke tests and synthetic unit tests.

Stage00-03 have not been migrated. HGV dynamics, Walker generation, real access geometry, FIM/Gramian assembly, DG/DA/DT, ClosedD/OpenD, STK, C++/MEX, and GUI remain unimplemented.

### Batch 2: D-metric contracts and toy metric kernels

Status: started and partially completed with a draft contract plus synthetic toy primitives. This is not production DG/DA/DT and is not a Stage09 migration.

Corresponds mainly to Stage04 and Stage09.

Scope:

- DG contract
- DA contract
- DT contract
- joint feasibility contract
- zero-information and outage handling rules
- toy FIM/Gramian examples
- generic requirement margin primitive
- synthetic D-triplet combiner and toy fixtures

Do not implement ClosedD until its definition is frozen.

Completed scaffold:

- `docs/D_METRIC_CONTRACT_DRAFT.md`;
- `ttube.core.metrics.computeRequirementMargin`;
- `ttube.core.metrics.combineDTriplet`;
- synthetic D-metric fixtures and unit tests.

Remaining before Batch 3:

- user/research review of DG/DA/DT production definitions;
- zero-information and outage handling decisions;
- Stage01-03 legacy golden baseline extraction planning.

### Batch 3: Small legacy baseline for Stage01-03

Status: extraction scaffold completed. A read-only Stage01-03 audit, `legacy_reference/golden_small/stage01_03_minimal` manifest scaffold, dry-run migration tools, and manifest regression test exist, but no legacy extraction has been run and no golden artifact has been generated.

Corresponds to Stage01/02/03.

Scope:

- one small casebank
- one nominal HGV trajectory
- one tiny Walker constellation
- one tiny access matrix
- legacy golden artifacts

Purpose:

- connect clean core primitives to old project outputs
- verify trajectory/orbit/visibility data contracts

Current Batch 3 guardrail:

- do not run full Stage01-03 until a reviewed lightweight extraction path exists;
- do not commit large legacy outputs;
- first extract only one minimal case such as `N01` from reviewed cache files or a dedicated safe extractor.
- baseline extraction requires explicit user confirmation and must remain read-only with respect to the old repository.

### Batch 4: Stage05/09 static inverse design tiny grid

Corresponds to Stage05 and Stage09.

Scope:

- nominal static search tiny grid
- feasible domain artifact
- minimum boundary artifact
- pass ratio and frontier summary
- no full dissertation-scale scans

### Batch 5: Stage14 OpenD artifact family

Corresponds to Stage14.

Scope:

- tiny RAAN/F scan
- OpenD scan/profile/envelope artifact
- DG-only compatibility
- no scalar OpenD until research definition is frozen

### Batch 6: Stage12/13 report packaging and neighborhood study

Corresponds to Stage12A-12E and Stage13.

Scope:

- truth baseline packager
- window truth curve packager
- slice study
- minimum-design report
- neighborhood candidate manager

This comes after core metrics and static inverse artifacts are stable.

## 6. Test Strategy

### Unit tests

Purpose:

- validate a small function in isolation

Input:

- synthetic arrays
- expected outputs hard-coded

Examples:

- `extractWindowIndices`
- `summarizeGapSegments`
- `validateTrajectoryArtifact`

### Contract tests

Purpose:

- validate artifact schemas and required fields

Input:

- minimal synthetic artifact structs

Examples:

- trajectory artifact
- constellation state artifact
- access artifact
- window artifact
- metric artifact

### Legacy regression tests

Purpose:

- verify new code against old project outputs

Input:

- frozen `legacy_reference/golden_small` artifacts

Examples:

- Stage02 nominal trajectory
- Stage03 tiny visibility case
- Stage04/09 small window metric case

### Backend parity tests

Purpose:

- compare MATLAB core, STK, and MEX/C++ backends

Do not start until core contracts are stable.

### Report/figure smoke tests

Purpose:

- verify figure generation without recomputing metrics

Input:

- saved artifacts and tables

## 7. Unattended Development Rule

For unattended Codex runs:

Allowed:

- Batch 1 pure utilities
- tests
- documentation updates
- synthetic fixtures
- run status or manifest drafts

Forbidden:

- reading old project unless explicitly authorized
- running old Stage runners
- generating large outputs
- implementing HGV dynamics
- implementing Walker propagation
- implementing DG/DA/DT without contract approval
- implementing ClosedD/OpenD
- implementing STK or C++ export

## 8. Go / No-Go Criteria

Before moving from Batch 1 to Batch 2:

- all smoke tests pass
- synthetic unit tests pass
- `SESSION_HANDOFF.md` updated
- `MIGRATION_MATRIX.md` updated
- no old project dependency introduced
- no core file IO/plotting/STK/COM/cache logic

Before moving from Batch 2 to Batch 3:

- DG/DA/DT contracts reviewed
- zero-window/outage handling rules documented
- toy metric tests pass
- legacy baseline extraction plan reviewed

Before moving from Batch 3 to Batch 4:

- at least one Stage01/02/03 golden baseline exists
- new trajectory, constellation, and access artifacts validate
- time/frame/unit conventions are verified

## 9. Current Recommended Next Step

Batch 3 scaffold has started. The next recommended step is review:

- review `docs/BATCH3_LEGACY_STAGE01_03_BASELINE_PLAN.md`;
- review and, if approved, extend the dry-run cache extractor for `stage01_03_minimal`;
- keep Stage05/09/14 and Ch5 out of scope.

Do not jump directly to Stage05/09 large scans.
