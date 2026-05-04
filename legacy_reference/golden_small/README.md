# Golden Small Legacy References

This directory is reserved for small, reviewed legacy reference artifacts used by regression tests.

Current Batch 3 scope:

- plan a Stage01-03 minimal baseline;
- define manifest schema and directory layout;
- avoid committing large legacy outputs;
- avoid running full legacy Stage01-03 unless a safe lightweight extraction path is reviewed.

Large `.mat` files and generated outputs over 5 MB must not be committed. Record their paths and sizes in `docs/SESSION_HANDOFF.md` instead.

The old repository remains read-only:

```text
C:/Dev/src/hgv-custody-inversion-scheduling
```

The initial planned baseline is:

```text
stage01_03_minimal
```

It should eventually contain a filtered, minimal legacy reference for one Stage01 case, one Stage02 trajectory, and one Stage03 visibility/access record.
