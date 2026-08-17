# Agentic PPM Runtime Evidence

> **Evidence gate:** This record contains only verified facts. An adapter, service definition, source file, or user-interface placeholder is **not** a live capability until its evidence row records a running route, persisted source record, or passing test.

## Verified Runtime Evidence

| Capability | Evidence | Recorded |
|---|---|---|
| Native OpenProject runtime | The fork starts through `agentic-ppm-openproject.service` on the Cloud Computer using Puma single mode with one minimum and two maximum threads. Local configured-host login returned HTTP 200 after the recovery restart. | 2026-08-17 |
| Native Agentic PPM module | The project-scoped dashboard route returned HTTP 200 for the representative project through authenticated administrator and controlled project-member sessions. | 2026-08-16 |
| Native dashboard evidence panels | Authenticated administrator rendering returned HTTP 200 with delivery-method, schedule, relationship/dependency, and capability panels. The page displayed the projected Sprint source record and the native `follows` relationship. | 2026-08-16 |
| Native evidence explorer controls | The isolated native module suite passed after adding project-scoped relationship-type filtering, projected-entity inspection, and deterministic source-review alert drill-down. Authenticated Cloud Computer requests returned HTTP 200 for the `follows` filter, a projected entity key, and the `missing_schedule:3` alert selection; the latter rendered exact source work-package details for the recorded incomplete schedule. These controls expose recorded evidence and derived field completeness only; they do not fabricate graph facts or agent-generated anomalies. | 2026-08-17 |
| Native PMO/VRO conversation workspace | The isolated native module suite passed for a permission-gated project route that shows only the configured PMO and VRO contracts, request history, and explicit runtime boundary. Authenticated Cloud Computer rendering returned HTTP 200. A production-equivalent invocation harness persisted a controlled PMO request as `unavailable`, reported Letta unavailable, and confirmed no response value. The workspace does not claim live graph grounding, memory retrieval, or agent output while those services remain inactive. | 2026-08-17 |
| Native eight-agent contract | Authenticated dashboard rendering returned HTTP 200 with PMO Agent, VRO Agent, OKR/KPI Agent, OCM Agent, Governance Agent, FinOps Agent, TMO Agent, and Business Planning Agent. Each contract declares scoped inputs, permitted tools, outputs, escalation, and inactive-runtime boundaries. | 2026-08-17 |
| Persistent schema | The isolated PostgreSQL database contains the native Agentic PPM projection, agent-run, integration-connection, sync-run, and business-rule tables. | 2026-08-16 |
| Source-to-ontology projection | The representative project projection persisted project, work-package, actor, and relationship records, including native source identities. | 2026-08-16 |
| Projection lifecycle success state | Direct isolated-database inspection showed 26 representative projection records in `projected` state after the native `agentic_ppm:run_projection` task completed. | 2026-08-17 |
| Projection lifecycle failure provenance | A controlled in-process projection-service failure was re-raised and persisted as a `failed` record with phase `project_projection_job` and bounded `RuntimeError` provenance; direct database inspection confirmed the record. | 2026-08-17 |
| Concurrent delivery methods | Project projection payload contains configuration-derived `waterfall`, `scaled_agile`, and `hybrid` evidence based on a native Milestone and Sprint work package. | 2026-08-16 |
| Schedules and dependency | Representative work packages hold native start/due dates. Projection record `openproject:relationship:follows:6:2` preserves the `follows` relation from the Sprint to the stage-gate Milestone. | 2026-08-16 |
| Stable representative source identity | The seed persisted configured source-key markers and reconciled the legacy Sprint record as superseded; direct database inspection showed one active marker-backed Sprint source record. | 2026-08-16 |
| Least-privilege access | Non-admin `agentic-ppm-member` holds only `view_agentic_ppm`, project, and work-package view permissions. The member reached the dashboard, while agent controls were withheld. | 2026-08-16 |
| Exact browser assets | A CI-built frontend artifact from this fork was installed with native manifest and Rails assets. Login and manifest-mapped entrypoints returned HTTP 200. | 2026-08-16 |
| Module regressions | The private-fork isolated PostgreSQL module workflow passed after test-support load-order repair; business-rule publish and rollback coverage is included. | 2026-08-16 |
| Native business-rule administration | Protected administrator authentication reached the project-scoped Business Rules interface with HTTP 200 and the rendered `Governed business-rule lifecycle` boundary. The interface remains unable to fabricate external visual-flow validation. | 2026-08-17 |
| Native integration onboarding | Protected administrator authentication reached the global-admin integration onboarding interface with HTTP 200 and rendered its protected credential-reference boundary plus connection inventory. The Jira/ServiceNow policy allows only configured read-only modes; a protected disallowed Jira `basic` mode POST returned HTTP 302 and created no connection. | 2026-08-17 |

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
| Memgraph projection contract | Inactive | Managed labels, provenance envelope, idempotent projection, health, server-side authorization, and projection-run-scoped rollback are defined; no authorized endpoint or graph write proof exists. |
| Lightweight isolated module-test path | Pending workflow proof | The hosted workflow now uses a module-specific Rails/PostgreSQL image and avoids frontend and browser setup; a completed current-branch module-suite run is still required before it is treated as verified. |

## Gate Operation

The `agentic-ppm-evidence-gate` workflow runs on the private fork for Agentic PPM source changes. It fails when a native module change does not update this evidence record, forcing every implementation claim to be paired with refreshed evidence or an explicit inactive status.

The runtime and operational details needed to reproduce the verified rows are recorded in the Cloud Computer `AGENTS.md` and in the architecture, service-activation, and frontend-artifact compatibility records under this directory. Secrets are deliberately excluded.
