# Retained UI integration contract

## Intent

The existing rich governance and portfolio UI remains part of the product experience. It is not discarded or replaced with a minimal OpenProject page. Its authority changes: the UI must consume fork-owned OpenProject contracts for identity, project scope, permissions, records, workflows, approvals, provenance, and audit history.

The external UI may remain a separately deployable client during development and may later be embedded or linked from native OpenProject navigation. Separately deployable does not mean separately authoritative.

## Surface mapping

| Retained UI surface | Native OpenProject authority | Allowed interaction | Agent/runtime dependency |
|---|---|---|---|
| Portfolio/dashboard and PMO intelligence | Project, work package, projection, AgentRun, finding, recommendation, and audit records | Read scoped evidence; request governed PMO run; review recommendations | PMO runtime, Memgraph, Mem0, Letta |
| Graph explorer, dependency map, and KG query | Native projection records plus provenance-preserving graph projection | Read-only traversal constrained by project and user permission | Memgraph and ontology service |
| Agent chat and interaction | AgentRun, specialist contract, user/project permissions, conversation audit | Submit an authorized prompt; receive cited response; no direct mutation | LangGraph/LangChain, Letta, Mem0, LiteLLM |
| Agent observatory and activity | AgentRun, trace references, job status, model/memory traces | Read-only operational inspection; filter by authorized project/specialist | LangGraph runtime and observability store |
| Findings, RAID, violations, and HITL inbox | Native finding/recommendation/approval records, journals, workflow transitions | Review, approve, reject, escalate, or request clarification through native policy | Specialist runtime; no autonomous write without approval |
| Prompt library, policy-as-code, and visual rules | Native BusinessRule records, lifecycle, version, validation result, Langflow reference | Draft, validate, submit, approve, publish, rollback under native permissions | Langflow only for visual flow execution/reference |
| Document/RAG library and uploads | Native attachment/document permissions and ingestion jobs | Upload/read/delete only within project and policy scope; trigger KG correlation check | RAG, ontology, Memgraph, specialist agents |
| OKR/KPI, value realization, resources, capacity, and financial views | Native Agentic PPM domain records linked to projects, work packages, users, budgets, and evidence | Read and governed updates through OpenProject workflows | OKR/KPI, VRO, FinOps, Business Planning agents |
| Connector and integration administration | Native integration connection metadata, policy, credential reference, sync run, provenance | Admin-only configuration; disabled by default; no raw secret exposure | Jira, ServiceNow, Dynatrace, FinOps, MCP adapters |
| Reports and subscriptions | Native query/report/subscription records and notification permissions | Create/read reports within authorized scope; delivery via native notification jobs | Agent outputs and native reporting |

## Contract rules

The UI must not call a supporting agent service directly for data that OpenProject owns. It must call a fork-owned API or adapter that applies the current user, project, role, policy, and audit context. A supporting runtime may be called only by that native boundary.

The UI may display a runtime observation such as a LangGraph trace, Letta state status, Mem0 retrieval trace, Memgraph relationship, or Langflow simulation result. Such observations must be labeled with source, timestamp, project scope, and availability state. Runtime state is not a substitute for a native OpenProject transaction.

Every governed write follows the same path: UI request, OpenProject authorization, native validation, native record or workflow transition, optional agent/runtime execution, native journal/audit entry, and refreshed UI projection. An agent recommendation remains advisory until a native approval policy accepts it.

## Identity and project scope

The external UI uses the OpenProject identity/session or an explicitly exchanged short-lived token issued by the fork. It must never maintain a second user or permission model. Each request carries the OpenProject user identity, project ID, specialist key where relevant, correlation ID, and evidence scope. Cross-project aggregation requires an explicit portfolio-level permission and must preserve per-project provenance.

## Migration approach

The current retained UI can be integrated incrementally. First, replace direct agent-server data reads with a fork-owned read contract for dashboards, graph, agent runs, findings, and observability. Next, route chat and rule actions through native Agentic PPM controllers. Then move OKR/KPI, OCM, VRO, FinOps, TMO, Governance, and Business Planning records into native models or explicitly linked extension tables. Finally, embed or link the UI from OpenProject navigation without changing its visual language.

The UI remains valuable throughout the migration. The authority boundary is what changes, not the product experience.
