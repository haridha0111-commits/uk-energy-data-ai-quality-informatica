# 5. Interview walkthrough

## 90-second opening

“I built a synthetic UK energy supplier case study around the customer-to-bill data chain. The scenario has fragmented CRM, account, meter, read and billing feeds, so I designed a control programme that starts with source profiling and business-owned definitions rather than a headline quality score. In Informatica IDMC, I would profile each source, turn approved definitions into reusable Cloud Data Quality assets, apply them through Data Integration mappings, preserve lineage, route critical failures into a steward queue and trend scorecards by source and rule. SQL and synthetic records make the measures easy to inspect. AI is deliberately assistive: source-drift alerts, exception ranking and duplicate candidates, with a person making consequential decisions. I avoid claiming any named supplier has these defects; the scenario is fictional and the regulatory rationale is cited to public UK primary sources.”

## What I would clarify with the client first

- Which customer, account, premise, meter, read and bill systems are in scope? What is each record’s grain and authoritative owner?
- Which source keys are stable? How are meter exchanges, account moves, estimated reads, corrections, late events, back-bills, rebills and reversals represented?
- What is the agreed business definition of “valid”, “current”, “actual”, “estimated”, “linked” and “duplicate” for each process?
- Which outputs are decision-critical, and what should happen on `FAIL` or `UNKNOWN`?
- What data access, consent, privacy, security, residency, retention and operational constraints apply?
- What IDMC services, licences, connectors, runtime, volumes, latency and deployment path exist?

## How to explain the control design

1. Start from customer/billing outcomes and risk; map the end-to-end lineage.
2. Profile and baseline by source; validate observations with owners.
3. Prioritise high-impact linkage, reading provenance, freshness and permission controls.
4. Keep raw values, canonical values and remediation evidence separate.
5. Separate pass/fail/unknown and technical errors; keep denominators visible.
6. Run shadow mode, calibrate with stewards, then release with owner-approved gates.
7. Use AI only where ranked suggestions improve human workflow and can be monitored.

## Likely challenge: “Why not just calculate one DQ score?”

“Averages can hide the one broken account-meter link that matters to a bill. I show each rule’s eligible, pass, fail and unknown counts, and gate critical controls separately. A roll-up is useful for trend and prioritisation only if its weights and denominator are visible.”

## Likely challenge: “Why use Informatica?”

“The deliverable maps the lifecycle to Informatica’s profiling, reusable Data Quality assets and Data Integration execution. I would validate tenant edition, connectors, licensing and release behavior before sizing or promising a design. The SQL example is an independent, transparent reference so an interviewer can inspect the logic.”

## Likely challenge: “Where does AI create value?”

“It can surface source drift and prioritise exception work, but it does not correct readings, infer consent or make identity/billing decisions. I would compare against a non-AI baseline, run shadow evaluation, give stewards override, and monitor error rates and outcomes by segment.”

## Portfolio credibility checklist

- Say “fictional case study” when presenting the supplier scenario.
- Do not present the sample defect rates as evidence about UK energy suppliers.
- Distinguish proposed targets from legal requirements and measured baselines.
- Explain that IDMC assets are specified, not deployed; you need tenant access to implement them.
- Start a real engagement with discovery, source contracts and owner approval.
