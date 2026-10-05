# 4. Practical AI inclusion and assurance

## Principle

Make the data rules, provenance and stewardship process dependable first. Use AI to help people find and prioritise patterns; keep deterministic controls authoritative for customer/billing decisions. No model should manufacture missing readings, infer consent, decide legal eligibility, silently overwrite source values or merge customer records.

## Prioritised use cases

| Use case | AI role | Input / output | Human control and success measure |
|---|---|---|---|
| Anomaly detection for source drift | Unsupervised/statistical detector ranks unusual null, code, volume, freshness or distribution changes | Aggregated per-source/time-window metrics → alert candidates | Engineer confirms root cause; measure useful alert rate, detection lead time and missed material shifts |
| Exception prioritisation | Model suggests order from rule severity, age, customer/billing process impact and approved attributes | Minimise personal data; return priority + reason codes, not remediation | Steward can override; monitor queue age, resolution time and priority calibration by segment |
| Duplicate candidate ranking | Entity-resolution similarity proposes pairs for human review | Approved identifiers/features → candidate pairs + evidence | Never auto-merge; steward decision is outcome; measure precision at reviewed top-K and false-match rate |
| Rule-authoring assistant | Generative assistant drafts SQL/rule descriptions from owner-approved definitions and synthetic examples | Business rule text + synthetic/schema metadata → draft, tests and explanation | Peer review, sample counterexamples, owner approval and versioned release; never execute generated logic directly |
| Read-gap prediction (later phase) | Forecast missing/late-read probability for operational planning | Historical aggregated timeliness data → risk band | Do not replace actual meter reads or change a bill; assess usefulness, calibration and segment effects |

## AI boundaries and controls

- **No AI in this demo is run on personal data.** Example records are fictional. Production requires documented purpose, lawful basis, data minimisation, access/security review, retention limits, supplier/processor review and DPIA screening as applicable.
- For smart-meter consumption, apply the current approved Data Access and Privacy Framework interpretation, purpose and granularity controls. Do not use half-hourly or other detailed data on the assumption that a generic consent field is enough; validate actual permission and applicable exceptions with privacy/legal owners.
- Keep a model/use-case inventory: owner, objective, data lineage, intended users, prohibited uses, model/version, vendor/hosting, evaluation, approval, monitoring and retirement date.
- Evaluate false positives and false negatives; calibration; robustness/drift; explainability appropriate to the decision; subgroup performance where lawful and meaningful; human override and contest route; incident/escalation process.
- Do not send customer names, addresses, meter reads, account numbers, credentials or confidential extracts to public generative services. Use approved environments and only the fields required.
- Store model suggestions and steward decisions as distinct, traceable events. An AI explanation is not evidence of correctness.

## Suggested delivery gates

1. Document business problem, affected people, decision and non-goals.
2. Map data lineage and permissions; assess accuracy, representativeness and missingness by source/segment.
3. Complete privacy, security, model-risk, procurement and regulatory reviews required by the organisation.
4. Establish a non-AI baseline and compare model-assisted outcomes in shadow mode.
5. Agree thresholds, human review capacity, override, rollback, audit and incident processes.
6. Pilot with synthetic or appropriately protected data; measure errors and outcomes; obtain owner approval.
7. Monitor drift, changes in source feeds, disparities, reviewer overrides and material incidents; suspend the model if guardrails fail.

This is a practical governance proposal, not legal advice or an assertion that any specific AI regulation applies. Follow current organisational policy and applicable law; ICO AI guidance is under review as noted in the source list.
