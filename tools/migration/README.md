# Migration Tools

These tools support Batch 3 legacy baseline extraction scaffolding. They are not part of the default test suite and should not be used to run long experiments.

## Rules

- The old repository is read-only: `C:/Dev/src/hgv-custody-inversion-scheduling`.
- The default mode is dry-run.
- Legacy Stage01-03 runners are not executed unless a future reviewed implementation explicitly enables them.
- Large legacy outputs must not be committed. Files over 5 MB should be reported in `docs/SESSION_HANDOFF.md`.
- The output location must stay inside `legacy_reference/golden_small/<baseline_id>` in the new repository.

## Local Configuration

Copy the example and edit local paths if needed:

```powershell
Copy-Item tools/migration/legacy_paths.local.example.json tools/migration/legacy_paths.local.json
```

Do not commit `legacy_paths.local.json`.

## Dry Run

From the new repository root:

```powershell
.\tools\migration\export_legacy_stage01_03_baseline.ps1
```

This prints the MATLAB command that would be used. It does not launch MATLAB unless `-RunMatlab` is passed.

To launch MATLAB in dry-run mode:

```powershell
.\tools\migration\export_legacy_stage01_03_baseline.ps1 -RunMatlab
```

The MATLAB scaffold writes `manifest.dryrun.json` and does not copy legacy `.mat` outputs.

## Explicit Execution

`-AllowLegacyRun` is intentionally not enough to run old Stage01-03 in the current scaffold. The MATLAB implementation raises an error if it is set, because a safe minimal runner has not been reviewed yet.

Future execution should require:

- reviewed lightweight extraction logic;
- explicit user confirmation;
- file size checks before `git add`;
- no modification to the old repository.
