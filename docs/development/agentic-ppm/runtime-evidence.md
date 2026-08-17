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
| Canonical ontology contract | Pending deployed proof | The configuration now defines required entity, relationship, and fact-provenance vocabulary; inspect the native configuration through an isolated test or running route before treating the contract as verified. |
| Model provider policy | Inactive | Claude-preferred but provider-neutral policy configuration exists; no provider credential, invocation, model selection, fallback, or evaluation evidence is activated yet. |
| Letta specialist template contract | Inactive | Exact agent identities, scopes, tool and action policy, memory constraints, and trace fields are defined; no Letta service, credential, agent provisioning, or invocation proof exists. |
| Mem0 memory governance contract | Inactive | Scope, extraction, retrieval, retention, deletion, citation, and observability policy is defined; no memory backend connection, write, retrieval, or deletion proof exists. |
| Langflow visual governance contract | Inactive | Embedding, role, validation, simulation, publication, rollback, and audit policy is defined; no Langflow service, credential, embedded editor, external validation result, or visual-flow execution proof exists. |
| Inngest AgentKit evaluation | Native GoodJob retained | The documented decision matrix keeps Inngest AgentKit disabled because no demonstrated workflow gap or authorized service proof currently justifies a second durable workflow authority. |
| Lightweight isolated module-test path | Pending workflow proof | The hosted workflow now uses a module-specific Rails/PostgreSQL image and avoids frontend and browser setup; a completed current-branch module-suite run is still required before it is treated as verified. |
| Native business-rule administration | Pending deployed proof | A project-scoped permission-gated native rule surface uses the lifecycle service, but no external visual-flow validation is fabricated; render it and prove a safe draft or rollback path before treating it as verified. |
| Projection lifecycle completion and failure provenance | Pending deployed proof | The native job now marks successful records as projected and stores bounded known-project error provenance before re-raising; run both safe success and controlled failure tests before treating it as verified. |

## Gate Operation

The `agentic-ppm-evidence-gate` workflow runs on the private fork for Agentic PPM source changes. It fails when a native module change does not update this evidence record, forcing every implementation claim to be paired with refreshed evidence or an explicit inactive status.

The runtime and operational details needed to reproduce the verified rows are recorded in the Cloud Computer `AGENTS.md` and in the architecture, service-activation, and frontend-artifact compatibility records under this directory. Secrets are deliberately excluded.
