# 2. A–Z implementation guide in Informatica IDMC

## Before opening Informatica

1. Confirm access to the organisation’s IDMC tenant, Cloud Data Quality, Data Profiling and Data Integration services, applicable licences, secure agent/runtime, source/target connectivity and supported versions. Product packaging and screens vary; use the tenant’s current documentation.
2. Obtain data-owner approval for domain scope, source extracts, keys, permitted use, retention, geography, refresh frequency and the release gate. Use synthetic records for this learning project.
3. Name the owner and steward for each domain. Agree business definitions and the first release’s tolerance for exceptions; do not make a technical team the sole authority for business validity.
4. Create a non-production project/folder, naming convention, role-based access, secrets handling, development/test/prod promotion process and runbook location.

Suggested folder/assets naming (adapt to tenant conventions):

```text
UK_ENERGY_DQ/
  00_REFERENCE/REF_COUNTRY | REF_METER_STATUS | REF_READ_TYPE | REF_UOM
  01_PROFILE/PRF_CUSTOMER | PRF_ACCOUNT | PRF_METER | PRF_READ | PRF_BILL
  02_RULES/RS_CUSTOMER | RS_METER | RS_READ | RS_BILL_LINK | RS_AI_FEATURE
  03_MAPPING/MP_RAW_TO_CANONICAL | MP_DQ_ROUTE | MP_EXCEPTION_EXPORT
  04_SCORECARDS/SC_CUSTOMER | SC_METER_READ | SC_BILLING_CHAIN
```

Names above are proposed labels, not guaranteed exact asset types in every IDMC edition.

## 1 — Discover and profile

- Inventory actual source objects and interface contracts; capture source owner, key, grain, update semantics, timestamps/time zones, code sets, null conventions, units, soft-delete and late-arrival behaviour.
- Land a small, approved, representative extract. Preserve source identifiers and batch metadata. Use a profiling environment with equivalent schema and data distributions, not copied unrestricted PII.
- In Data Profiling, create a profile per source/domain. Examine row/column counts, nulls, distinct values, value distributions, patterns, min/max, formats, key uniqueness and relationships. Segment by source, date and relevant operational process.
- Validate inferred patterns with domain owners. A profile describes observed values; it does not certify business truth.
- Record a baseline snapshot with denominator, rules/definitions, profiling date, extract window, known exclusions and source coverage. Do not invent baseline rates before running on approved data.

## 2 — Agree controls and rule specifications

Use the catalogue in `03-rule-catalogue.md`. For each rule approve: business definition, dimension, input grain, null behaviour, valid reference source, severity, numerator/denominator, threshold, action, owner, steward queue, evidence, rule version and effective date. Check time-dependent semantics before comparing events. Keep `unknown` separate from `pass` and `fail`.

Create reference tables with an owner, version, effective dates and approval process. Examples: known source code → canonical status mapping; unit codes; allowed reading type codes. Do not rely on undocumented hard-coded lists.

In Cloud Data Quality, create reusable Rule Specification assets for row-level business conditions where the tenant supports them; use Cleanse/Parse/deduplication or address assets only when fit for the data and licensed. Use deterministic logic for authoritative pass/fail. Use a dedicated duplicate-candidate workflow and steward confirmation before any merge. Annotate the business dimension and maintain asset versions.

## 3 — Build IDMC data flow

Conceptual mapping sequence (exact transformations/connectors are tenant/version dependent):

```text
Source read / approved extract
 → audit fields + type/format normalisation (raw preserved)
 → reference/code mapping (unmapped values remain exceptions)
 → reusable DQ rules (one output per rule: PASS / FAIL / UNKNOWN)
 → critical-gate routing (eligible / quarantine / review)
 → curated output + exception output + run metrics
```

- Build a mapping for a single domain first; parameterise source and batch where possible.
- Keep technical load failures distinct from data-quality failures.
- Produce a row-level exception record with source key, rule ID/version, failed value or safe evidence reference, execution ID, batch ID, timestamp, severity and disposition status. Restrict sensitive payload fields.
- Write curated results only after required validations. Use idempotent batch keys / merge semantics approved for the target; prove restart and replay behaviour.
- Orchestrate dependencies, retries, alerting and run windows. Avoid retry loops that multiply output. Capture record counts at source, accepted, failed, unknown and written stages.
- Promote assets through version-controlled export/import or the organisation’s approved promotion mechanism; parameterise environment-specific connections; peer review and approve changes.

## 4 — Exceptions and remediation

Triage in this order: potential customer/bill harm, regulatory/privacy/security exposure, operational blockers, then analytics convenience. Give every issue a disposition (`new`, `assigned`, `investigating`, `source_fix`, `approved_standardisation`, `accepted_exception`, `closed`, `reopened`), owner, due date, evidence pointer, root cause and resolution code. Keep exception history immutable. A source correction should follow the source system’s controlled process; never “fix” only the warehouse and imply the source is corrected.

## 5 — Scorecards and operating metrics

Publish each rule with numerator, denominator, pass/fail/unknown counts and trend; segment by source, process and period. Also publish freshness, late arrival, rule execution status, unresolved critical exceptions, mean age/age bands and recurrence. Overall score is supplementary: critical gating rules must be shown separately. The included SQL computes a simple rule-level score from demo records; it does not replace IDMC scorecards or stewardship tooling.

## 6 — Release and operate

Release gate: owner-approved definitions; approved source-to-target mapping; security and privacy sign-off; reviewed thresholds; calibrated false positives; completed reconciliation; alert/escalation route; restore/replay approach; dashboard ownership; steward capacity; release/change record; rollback trigger and post-release observation period. Run shadow mode first where business risk warrants. Re-baseline after schema/volume/process changes, material acquisition, rule/reference updates or model/data drift.

## 7 — Example stewardship decision

Two customer rows share a normalised email but have different names and premises. Rule `CST-004` creates a duplicate candidate, not an automatic merge. The steward reviews permitted identity evidence and existing enterprise policy, records one of `same_person`, `different_person`, `insufficient_evidence`, or `refer_to_owner`; insufficient evidence stays unresolved. Any eventual merge is reversible and auditable.

## Mapping from project to Informatica capability

| Need | IDMC design capability (confirm edition/current tenant) |
|---|---|
| Understand distributions and patterns | Data Profiling profiles |
| Reusable business conditions | Cloud Data Quality rule specification / supported DQ assets |
| Apply rules at scale and route rows | Data Integration mapping and orchestration with DQ assets |
| Measure rules over time | Data Profiling scorecards/metrics where configured; publish governed operational mart as needed |
| Verify asset relationships | Available catalog/lineage capability, if licensed/configured |

This deliberately avoids promising a particular AI feature, exact connector, SLA, threshold or UI label without the client tenant details.
