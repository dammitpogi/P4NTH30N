# Railway GraphQL Client (Strategist Tool)

Tool path: `STR4TEG15T/tools/railway_graphql_client.py`

Purpose:
- Verify Railway API authentication mode.
- Run read-only discovery queries.
- Run reversible write smoke tests to prove edit authority.

## Usage

Set token in environment (recommended):

```bash
set RAILWAY_API_TOKEN=YOUR_TOKEN_HERE
```

Auth probe:

```bash
python STR4TEG15T/tools/railway_graphql_client.py probe-auth --mode auto
```

Schema hints (top-level query/mutation names):

```bash
python STR4TEG15T/tools/railway_graphql_client.py schema-hints --mode bearer
```

Execute query from file:

```bash
python STR4TEG15T/tools/railway_graphql_client.py execute --mode auto --query-file path/to/query.graphql --variables-file path/to/vars.json
```

## Gate-Clearing Smoke Test Plan

1) Read check: list variables for target project/environment/service.
2) Write check (reversible): set `PYXIS_ACCESS_TEST=ok`.
3) Revert check: unset `PYXIS_ACCESS_TEST`.
4) Confirm variable removed.

Do not run non-reversible mutations in this gate.
