# Agentic PPM Runtime Evidence

> **Evidence gate:** This record contains only verified facts. An adapter, service definition, source file, or user-interface placeholder is **not** a live capability until its evidence row records a running route, persisted source record, or passing test.

## Verified Runtime Evidence

| Capability | Evidence | Recorded |
|---|---|---|
| Native OpenProject runtime | The fork starts through `agentic-ppm-openproject.service` on the Cloud Computer with a one-worker production Puma profile. Local configured-host login returned HTTP 200 after each recorded restart. | 2026-08-16 |
| Native Agentic PPM module | The project-scoped dashboard route returned HTTP 200 for the representative project through authenticated administrator and controlled project-member sessions. | 2026-08-16 |
| Native dashboard evidence panels | Authenticated administrator rendering returned HTTP 200 with delivery-method, schedule, relationship/dependency, and capability panels. The page displayed the projected Sprint source record and the native `follows` relationship. | 2026-08-16 |
| Native eight-agent contract | Authenticated dashboard rendering returned HTTP 200 with PMO Agent, VRO Agent, OKR/KPI Agent, OCM Agent, Governance Agent, FinOps Agent, TMO Agent, and Business Planning Agent. Each contract declares scoped inputs, permitted tools, outputs, escalation, and inactive-runtime boundaries. | 2026-08-17 |
| Persistent schema | The isolated PostgreSQL database contains the native Agentic PPM projection, agent-run, integration-connection, sync-run, and business-rule tables. | 2026-08-16 |
| Source-to-ontology projection | The representative project projection persisted project, work-package, actor, and relationship records, including native source identities. | 2026-08-16 |
| Concurrent delivery methods | Project projection payload contains configuration-derived `waterfall`, `scaled_agile`, and `hybrid` evidence based on a native Milestone and Sprint work package. | 2026-08-16 |
| Schedules and dependency | Representative work packages hold native start/due dates. Projection record `openproject:relationship:follows:6:2` preserves the `follows` relation from the Sprint to the stage-gate Milestone. | 2026-08-16 |
| Stable representative source identity | The seed persisted configured source-key markers and reconciled the legacy Sprint record as superseded; direct database inspection showed one active marker-backed Sprint source record. | 2026-08-16 |
| Least-privilege access | Non-admin `agentic-ppm-member` holds only `view_agentic_ppm`, project, and work-package view permissions. The member reached the dashboard, while agent controls were withheld. | 2026-08-16 |
| Exact browser assets | A CI-built frontend artifact from this fork was installed with native manifest and Rails assets. Login and manifest-mapped entrypoints returned HTTP 200. | 2026-08-16 |
| Module regressions | The private-fork isolated PostgreSQL module workflow passed after test-support load-order repair; business-rule publish and rollback coverage is included. | 2026-08-16 |

## Explicitly Unverified or Inactive

| Capability | Status | Activation requirement |
|---|---|---|
| Letta, Mem0, and Memgraph adapters | Inactive | Restore valid Railway endpoints and protected credentials, then run health and authorization proof. |
| Eight live specialist agents | Inactive | Provision scoped agent identities, memory policies, model configuration, tools, and end-to-end vertical-slice evidence. |
| Langflow visual business-user workflow | Inactive | Deploy and authorize Langflow, then demonstrate governed draft, validation, approval, publish, and rollback through OpenProject permissions. |
| Inngest AgentKit runtime | Inactive | Adapter contract and CI coverage exist, but no external service is enabled. |
| Jira, ServiceNow, Dynatrace, and FinOps data | Inactive | Obtain authorized connector credentials and demonstrate ingestion, mapping, provenance, and revocation behavior. |

## Gate Operation

The `agentic-ppm-evidence-gate` workflow runs on the private fork for Agentic PPM source changes. It fails when a native module change does not update this evidence record, forcing every implementation claim to be paired with refreshed evidence or an explicit inactive status.

The runtime and operational details needed to reproduce the verified rows are recorded in the Cloud Computer `AGENTS.md` and in the architecture, service-activation, and frontend-artifact compatibility records under this directory. Secrets are deliberately excluded.
