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

## Validation Result

Requested Stage00-05 E2E suite passed: 21 tests, 0 failed, 0 incomplete.

Stage status:

- Stage00: covered by native bootstrap artifact.
- Stage01: covered by native nominal/heading/critical casebank bundle.
- Stage02: covered by native trajectory bank bundle using `native_vtc`.
- Stage03: covered by native Walker/constellation/access bundle.
- Stage04: covered by native window/gamma summary bundle with controlled metrics subset.
- Stage05: covered by Stage04-connected native Stage05 search bundle.

Partial boundaries:

- old cache filenames and cache side effects are not reproduced;
- old figures are not pixel-replicated;
- large full Stage04 winbank/FIM dumps are not generated;
- this sprint did not migrate Stage07/08/09/14/Ch5.
