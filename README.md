# UK Energy Data & AI Quality — Informatica IDMC project

An interview-ready, synthetic enterprise case study for a Data & AI Quality Lead/Manager. It shows how to discover, measure, improve and govern fragmented customer, account, meter, reading and billing data using Informatica Intelligent Data Management Cloud (IDMC) Cloud Data Quality/Data Profiling and Data Integration, supported by readable SQL and a self-contained HTML presentation.

> **Scenario and data are fictional.** “Northstar Energy” is an invented supplier. This project does not assert that any named supplier has poor data quality, and its sample values are not customer data or measured industry statistics. The control rationale is based on the public sources in [`docs/sources.md`](docs/sources.md).

## Start here

1. Open [`presentation/index.html`](presentation/index.html) in a browser for the project walkthrough and live synthetic KPI cards.
2. Read [`docs/01-project-brief.md`](docs/01-project-brief.md) for the case, scope, outcomes and assumptions.
3. Follow [`docs/02-build-guide.md`](docs/02-build-guide.md) for the A–Z Informatica implementation.
4. Use [`docs/03-rule-catalogue.md`](docs/03-rule-catalogue.md) for dimensions, thresholds, severity and owners.
5. Review [`docs/04-ai-and-assurance.md`](docs/04-ai-and-assurance.md) before discussing AI use.
6. Run the SQL examples in order using a SQL Server-compatible database: [`sql/01_demo_schema_and_data.sql`](sql/01_demo_schema_and_data.sql), then [`sql/02_quality_metrics.sql`](sql/02_quality_metrics.sql). SQL is a transparent demo/reference implementation, not an Informatica runtime dependency.
7. Practise the concise interview narrative in [`docs/05-interview-walkthrough.md`](docs/05-interview-walkthrough.md).

## What is included

- Synthetic multi-system energy dataset with deliberate, documented defects.
- Conceptual target model, source-to-target notes, DQ operating model and release gates.
- Twenty-four proposed rules covering completeness, validity, uniqueness, consistency, timeliness, accuracy proxies, integrity and consent controls.
- IDMC implementation plan: profile → design reusable assets → map/execute → measure/triage → improve, with exception handling, lineage and operational ownership.
- Human-supervised AI opportunities with prohibited/guarded decisions and a model assurance checklist.
- Local, dependency-free HTML presentation; no external scripts, data calls or CDN.

## Important implementation boundary

This is a build specification and portable demonstration, not an exported Informatica project package. No Informatica tenant, licence, runtime, connector configuration, release-specific UI or credentials were supplied, so no IDMC asset has been created or executed. Confirm the tenant’s exact service names, supported connectors, feature availability, licensing, runtime and privacy/security controls with the organisation and current Informatica documentation before implementation. SQL outputs and the dashboard use only the clearly labelled synthetic example data.

## New GitHub repository

Suggested repo name: `uk-energy-data-ai-quality-informatica`. Create it under the requested account at [github.com/new](https://github.com/new?owner=haridha0111&name=uk-energy-data-ai-quality-informatica), then from this project directory run:

```powershell
git init
git add data-ai-quality-informatica-energy
git commit -m "Add UK energy data and AI quality Informatica case study"
git branch -M main
git remote add origin https://github.com/haridha0111/uk-energy-data-ai-quality-informatica.git
git push -u origin main
```

The owner/repository URL is a suggested URL based on the handle supplied in the request; it does not verify account ownership or create the remote repository. Review and commit only the new project folder; this workspace contains other files.

## Deliverable path

The workspace-safe project folder is `C:\Users\harid\Documents\Codex\Projects\purview-tax-governance-project\data-ai-quality-informatica-energy`. The separately requested `C:\Users\harid\Documents\Codex\2026-09-02\i-x20\outputs` path is outside the writable workspace and will be attempted only through the sandbox’s reviewed access mechanism after the deliverable is complete.
