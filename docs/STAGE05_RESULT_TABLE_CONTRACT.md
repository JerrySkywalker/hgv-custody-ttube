# Stage05 Result Table Contract

Schema: `stage05_result_table.v0`

Required columns:

- `design_id` string
- `h_km` double
- `i_deg` double
- `P` double/integer-valued
- `T` double/integer-valued
- `F` double/integer-valued
- `Ns` double/integer-valued, expected `P*T`
- `gamma_req` double
- `lambda_worst` double
- `D_G` double finite
- `feasible` logical
- `pass_ratio` double
- `mean_visible` double
- `dual_ratio` double
- `backend` string
- `notes` string

`normalizeStage05ResultTable` standardizes names and types only. It does not calculate new metrics beyond deterministic identifiers and missing-field notes.
