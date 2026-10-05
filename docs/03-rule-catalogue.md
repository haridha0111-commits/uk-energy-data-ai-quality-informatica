# 3. Proposed rule catalogue

These are **starting controls for the synthetic case**, not regulatory thresholds. Owners must confirm meanings and thresholds against actual source contracts and billing processes. `UNKNOWN` is used when evidence is missing or the rule cannot safely decide. A critical failure is held/reviewed according to an owner-approved control; the rule does not itself cancel or amend a bill.

Severity: **Critical** = potential wrong customer/account/meter/bill link or consent breach; **High** = material operational/customer/data-product risk; **Medium** = reporting or enrichment issue.

| ID | Domain / dimension | Proposed condition | Severity | Action / owner |
|---|---|---|---|---|
| CST-001 | Customer / completeness | Stable customer source key present | High | Reject to source-key exception; Customer owner |
| CST-002 | Customer / validity | Email shape valid when supplied; blank is unknown, not an invalid email | Medium | Flag; Customer steward |
| CST-003 | Customer / validity | Postcode conforms to agreed UK postcode parser/reference; do not use naive regex as legal validation | Medium | Flag / approved cleanse; Customer steward |
| CST-004 | Customer / uniqueness | Candidate duplicate by configured evidence set; never auto-merge solely by fuzzy similarity | High | Steward review; Customer owner |
| CST-005 | Customer / consistency | Normalised email/phone agrees across current customer views or conflict is explained | Medium | Conflict queue; Customer owner |
| ACC-001 | Account / completeness | Account source key and status present | High | Exception; Account owner |
| ACC-002 | Account / validity | Account status maps through effective-dated reference table | High | Unmapped code queue; Account owner |
| ACC-003 | Account / integrity | Account references an existing customer | Critical | Quarantine relation; Customer/account owners |
| PRM-001 | Premise / completeness | Supply point / premise key present at agreed grain | Critical | Hold downstream link; Metering owner |
| PRM-002 | Premise / validity | Postcode/region valid under approved address reference | Medium | Steward review; Premise owner |
| LNK-001 | Relationship / uniqueness | At most one active account per agreed supply-point/time slice, subject to approved exceptions | Critical | Quarantine overlap; Billing owner |
| MTR-001 | Meter / completeness | Meter ID, premise link and status present | Critical | Hold reading join; Metering owner |
| MTR-002 | Meter / validity | Meter status and fuel type belong to effective-dated reference values | High | Reference exception; Metering owner |
| MTR-003 | Meter / consistency | Meter fuel type compatible with supply/premise service under approved model | High | Review; Metering owner |
| MTR-004 | Meter / timeliness | Active meter event has a current effective interval; stale/overlapping intervals flagged | High | Temporal review; Metering owner |
| RED-001 | Reading / completeness | Reading key, meter key, event time, value, unit and read type populated | Critical | Quarantine row; Reads owner |
| RED-002 | Reading / validity | Reading value is numeric and non-negative unless domain rule explicitly permits otherwise | High | Quarantine; Reads owner |
| RED-003 | Reading / validity | Unit maps to expected fuel/meter measurement unit | Critical | Quarantine; Reads owner |
| RED-004 | Reading / consistency | Read type maps to actual/estimated/validated categories via owned reference | High | Unmapped type queue; Reads owner |
| RED-005 | Reading / timeliness | Reading event time is not unreasonably future-dated vs agreed processing time/window | High | Review time zone/clock; Reads owner |
| RED-006 | Reading / plausibility | Consumption delta outside meter/fuel-specific operational bounds flagged; bounds calibrated, never universal | High | Review, not automatic correction; Metering owner |
| RED-007 | Reading / sequence | Reading sequence does not decrease for compatible meter/register, accounting for reset/replacement/rollover events | High | Sequence investigation; Metering owner |
| RED-008 | Reading / uniqueness | Duplicate source event key or exact retransmission handled idempotently | High | Deduplicate only by governed event key; Reads owner |
| BIL-001 | Bill / integrity | Bill references an existing active account and matching effective premise | Critical | Quarantine/review; Billing owner |
| BIL-002 | Bill / integrity | Bill reading reference exists, belongs to the linked meter and falls in the relevant bill window | Critical | Hold/review; Billing owner |
| BIL-003 | Bill / consistency | Actual/estimated provenance on bill agrees with source reading/provenance mapping | Critical | Hold/review; Billing owner |
| BIL-004 | Bill / validity | Bill period end > start; currency/unit/tariff codes mapped and amount precision valid | High | Exception; Billing owner |
| CON-001 | Consent / privacy | Detailed consumption access/use has valid purpose, granularity, legal basis/permission state and effective evidence per approved policy | Critical | Prevent use, privacy escalation; Data owner/DPO |
| TIM-001 | Pipeline / timeliness | Source-to-curated freshness meets owner-agreed service objective | High | Alert pipeline owner |
| GOV-001 | Governance / traceability | Every output row links to source key, batch, run ID and rule version | High | Fail batch if audit contract broken; Platform owner |

## Measurement pattern

For each rule and run:

```text
eligible_count = rows where the rule can be evaluated
pass_count     = evaluated rows satisfying the rule
fail_count     = evaluated rows violating the rule
unknown_count  = rows where required evidence is missing or unavailable
pass_rate      = pass_count / eligible_count (only if eligible_count > 0)
```

Show unknown separately; do not count it as pass. For relationship and temporal rules, count relationship/time-slice grain, not arbitrary joined rows. State the grain beside the metric. Report exclusions and failed technical runs. Thresholds are agreed from baseline + impact, operational capacity and risk appetite. No numerical threshold in this portfolio pack is represented as a UK legal requirement.
