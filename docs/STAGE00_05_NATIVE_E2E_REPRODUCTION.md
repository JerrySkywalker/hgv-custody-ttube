# Stage00-05 Native E2E Reproduction

Created: 2026-05-05

Profiles:

- `smoke`: fast single nominal case with Stage05 smoke grid.
- `tiny`: nominal, heading, and critical families with small counts.
- `medium_safe`: nominal >= 6, heading >= 6, critical >= 2 with guarded runtime settings.

Generated native outputs:

- Stage00 bootstrap summary
- Stage01 casebank bundle
- Stage02 trajectory bank bundle
- Stage03 constellation/access bundle
- Stage04 window/gamma bundle
- Stage05 search bundle with summary, frontier, Pareto/transition, and plot-bundle metadata
- Stage00-05 manifest and validation report

Legacy output policy:

- old cache filenames and side effects are not reproduced;
- large winbank/FIM dumps are not generated;
- old figures are not pixel-replicated; plot support is smoke/summary equivalent;
- native pipeline does not call legacy helpers.

Result: native Stage00-05 E2E smoke/tiny/medium-safe profiles are covered by automated tests.
