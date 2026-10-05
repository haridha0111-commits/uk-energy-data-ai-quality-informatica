# 1. Project brief: trusted customer-to-bill data

## Executive case

**Fictional organisation:** Northstar Energy, a UK domestic supplier in this case study. This is an invented composite scenario, not a representation of any real supplier or client engagement.

**Problem statement:** Customer, account, premise, meter, meter-reading and bill events arrive from acquired legacy platforms, CRM, metering operations and billing. They use different identifiers, formats, update schedules and ownership. In the scenario, duplicate identities, unresolved account-to-premise links, missing or stale reads, inconsistent units/status codes and conflicting effective dates make it hard to establish whether a bill was calculated from an eligible, correctly linked reading. Teams reconcile cases manually; downstream reporting and analytics inherit the uncertainty. The project establishes measurable controls and a steward-led remediation loop before expanding AI use.

This problem is a **plausible synthetic design scenario**, not a factual claim that these defects occur at any named energy company. UK public guidance establishes relevant customer, billing-transparency and smart-meter data-access expectations; it does not establish the fictional baseline or quantify this scenario.

## Outcomes and acceptance

Business outcome: improve confidence in the chain `customer → account → premise → meter → reading → bill`, prioritising defects that can affect a customer bill, contact or analytics result.

First release acceptance, to be agreed and baselined with the sponsor (proposed targets are project choices, not legal thresholds):

- 100% of in-scope records have stable source key, ingestion timestamp and traceable lineage.
- Every critical rule has a named business owner, definition, severity, threshold, action and evidence location.
- Critical billing-link and bill-read failures are quarantined or sent for explicit review before certified consumption; the business approves any exception policy.
- Baseline and post-remediation results are comparable by source, segment, rule and processing date; no single blended score hides critical failures.
- Every automated correction is deterministic, reversible, logged and approved; ambiguous identity or bill changes go to a human steward.
- AI use cases pass privacy, security, fairness, performance and human-oversight gates before production.

## Scope

**In:** domestic customer/account/premise/meter master and read-to-bill linkage; batch landing and canonical quality layer; profiling; reusable rules and reference data; duplicate candidate queue; DQ scorecards/operational measures; stewardship workflow; AI-assisted prioritisation and anomaly detection under oversight.

**Out of initial release:** real customer data, live smart-meter interval ingestion, bill recalculation, customer communications, automated account merges, production GenAI, tariff optimisation, supplier rankings, legal determinations, and claims about a real supplier’s control environment.

## Personas / decision rights

| Role | Accountability |
|---|---|
| Data & AI Quality Lead | Framework, criticality, rule standards, thresholds, evidence and cross-domain delivery |
| Customer / Billing Data Owner | Business meaning, control acceptance, remediation policy and risk acceptance |
| Informatica Data Quality Engineer | Profiles, reusable rule assets, mappings, execution, logging and technical lineage |
| Data steward / operations analyst | Investigates exceptions; records evidence and dispositions; no silent source edits |
| Privacy / DPO / security / model risk | Reviews personal-data purpose, access, retention, AI risk, controls and incident route |
| Product / billing operations | Confirms process impact, release gate and operational service levels |

## Conceptual architecture

```text
CRM + legacy account + premise/meter registry + read service + billing ledger
                    │ governed, least-privilege batch extracts / CDC as approved
                    ▼
      immutable raw landing (source key, batch ID, event/effective/ingest time)
                    ▼
 Informatica IDMC Data Integration: standardise → reusable DQ assets → route
                    │                                      │
                    ▼                                      ▼
       curated trusted layer                     exception/steward queue
                    │                                      │
       scorecards / quality mart ◀──── dispositions, evidence, approved fixes
                    │
           governed analytics / approved AI features
```

This is a logical design. Network, runtime location, encryption, connectors, processing mode, service limits and security architecture are deployment decisions requiring the client’s platform and security teams.

## Data lifecycle / controls

Preserve source values and raw history. Every load carries `source_system`, `source_record_id`, `batch_id`, `ingested_at`, `effective_from`, `effective_to` where supplied, and a stable hash or equivalent change identifier. Standardised values are separate from raw values. Never invent a missing reading, customer identity, consent record or meter link. Keep rule version, execution ID, row disposition and reason code. Define retention and access with privacy/security owners.

## Risks and mitigations

| Risk | Response |
|---|---|
| False positive blocks a valid bill | Shadow run, representative validation, business-approved thresholds and manual override with reason |
| Overzealous dedup merges different people | Candidate scoring only; evidence-based steward review; reversible survivorship and audit |
| Source semantics differ | Data contracts, code mapping tables, owner sign-off and source-specific exception patterns |
| Metrics improve by excluding difficult rows | Reconcile input, pass, fail, excluded and unknown counts; publish denominators |
| Personal data exposed to an AI service | No real PII in demo; approved environment, minimisation, DPIA screening and access review |
| Drift after release/acquisition | Scheduled profiles, source-level drift alerts, versioned rules and change control |

## Delivery plan (indicative)

Discover and agree scope → baseline/profile → rule workshops and data contracts → build reusable IDQ assets/mappings → shadow run and steward calibration → controlled release → monitor, remediate and iterate. Indicative sequencing is a planning proposal, not a supplier commitment; size after source/volume/connector discovery.
