# Synthetic source extracts

These files are fictional training fixtures for Informatica profiling and the SQL demo. Every person, address, identifier and event is invented; email addresses use the reserved `.test` domain. Do not connect them to production. The deliberate defects are documented in `docs/03-rule-catalogue.md` and comments in `sql/01_demo_schema_and_data.sql`.

| File | Grain | Rows (excluding header) | Deliberate examples |
|---|---|---:|---|
| `customers.csv` | Customer source record | 18 | malformed email, invalid-postcode candidate, missing optional email, possible duplicate signal |
| `accounts.csv` | Account | 19 | orphan customer key, unmapped status code |
| `meters.csv` | Meter | 19 | suspect fuel/unit combination |
| `meter_reads.csv` | Meter read event | 19 | missing value, negative value, unmapped read type, unexpected unit, future-dated event |
| `bills.csv` | Bill | 19 | missing read, meter mismatch, period/provenance mismatch, orphan account |

`ingested_at` is fixed at `2026-08-31T08:00:00Z` for repeatable examples. Reference mappings, effective-dated history, interval-consent evidence and production-scale distributions are intentionally not fabricated here; obtain them from approved owners in a real implementation.

The SQL demo loads its own equivalent rows and does not read these CSVs automatically. To use the CSVs in IDMC, configure approved flat-file connections in your learning tenant and map each header to the corresponding demo table/schema.
