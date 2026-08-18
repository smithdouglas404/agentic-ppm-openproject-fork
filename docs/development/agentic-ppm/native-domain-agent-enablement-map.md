# Native OpenProject domain and agent-enablement map

## Product boundary

The private OpenProject fork is the product source of truth. Agentic PPM capabilities must be implemented as source-level extensions of OpenProject’s native Rails, database, background-job, permission, event, and frontend systems. The local LangGraph/LangChain, Letta, Mem0, Memgraph, LiteLLM, and Langflow services are supporting runtimes behind native OpenProject contracts.

The knowledge graph is a semantic projection and traversal layer, not a replacement for OpenProject’s transactional records. Every graph entity must retain OpenProject source identity, project scope, observed time, provenance, and authorization context. Agent insights must cite both the native source records and any graph relationships used to derive them.

## Native domain seams

| Native OpenProject domain | Source-level seams to extend | Agentic capability enabled | Initial specialist agents |
|---|---|---|---|
| Projects, modules, memberships, and roles | `Project`, project patches, module permissions, project controllers, project menu registration | Project-scoped agent activation, authorization, tenant boundary, agent ownership | All eight |
| Work packages, relations, versions, and schedules | `WorkPackage`, relation models, schedule services, journals, projection jobs | Delivery posture, dependencies, milestone health, evidence projection, change detection | PMO, TMO, OCM |
| Risks, issues, and action items | Native work-package types, status transitions, queries, journal events | Escalation, risk trend detection, decision-readiness, control exceptions | PMO, Governance, OCM |
| Budgets, costs, time, and financial plans | Cost/budget models, cost reports, time entries, project financial services | Funding variance, allocation analysis, forecast and value signals | FinOps, VRO, Business Planning |
| Teams, users, memberships, and responsibilities | `User`, `Member`, roles, principals, assignment services, notification recipients | Accountability, capacity, ownership gaps, stakeholder and change-readiness signals | OCM, PMO, TMO |
| Statuses, workflows, forms, and transitions | Workflow matrices, status services, role permissions, transition hooks | Policy-as-code, governed transitions, approval readiness, control enforcement | Governance, OCM |
| Queries, reports, dashboards, and exports | Query models, report services, dashboard components, export jobs | Native insight surfaces, saved analytical views, executive reporting, evidence drill-down | All eight |
| Notifications, journals, and audit history | Journal creation, notification jobs, activity streams, audit records | Event-driven triggers, traceability, human-in-the-loop escalation, learning feedback | All eight |
| Documents, attachments, and project wiki content | Attachment storage, extraction jobs, document permissions, full-text indexing | Evidence ingestion, ontology alignment, correlation checks, policy evaluation | Governance, OKR/KPI, OCM, Business Planning |
| Integrations and imports | Jira/ServiceNow import patterns, integration connections, sync jobs, provenance records | Controlled external evidence ingestion and MCP-backed source adapters | PMO, Governance, FinOps, TMO |

## Specialist modules

Each specialist becomes a native Agentic PPM domain contract with a model or record type for its evidence, a policy boundary, an OpenProject job/event trigger, a graph projection mapping, a runtime route, and a native result/approval surface. The agent runtime does not own these transactional records.

| Specialist | Native domain module | Required first-class records | Evidence and graph focus | Human decision boundary |
|---|---|---|---|---|
| PMO | Delivery oversight and portfolio health | Delivery findings, dependency signals, escalations | Work packages, milestones, relations, schedules, risks | PMO owner reviews escalations and actions |
| VRO | Value realization and benefits | Benefit hypotheses, realization checkpoints, variance questions | Outcomes, benefits, milestones, financial evidence | Value owner accepts, challenges, or re-baselines hypotheses |
| OKR/KPI | Objectives, measures, and contribution | Objectives, key results, indicators, measurements | Objective-to-work-package and KPI-to-outcome relations | Objective owner validates attribution and targets |
| OCM | Change readiness and adoption | Change impacts, stakeholder readiness, adoption risks | Teams, stakeholders, communications, readiness work | Change owner approves interventions |
| Governance | Controls, policies, decisions, and approvals | Policies, controls, exceptions, decision records | Policy references, workflow transitions, approval evidence | Governance owner approves or rejects exceptions |
| FinOps | Funding and cost governance | Cost observations, allocations, forecasts, variance findings | Costs, budgets, time, funding, delivery progress | Finance owner approves corrective action |
| TMO | Transformation sequencing and dependencies | Transformation milestones, dependency risks, sequencing recommendations | Cross-workstream relations, roadmaps, outcomes | Transformation owner accepts sequencing changes |
| Business Planning | Assumptions, capacity, and strategic alignment | Planning assumptions, capacity constraints, scenario findings | Objectives, demand, capacity, funding, delivery records | Planning owner approves assumption changes |

## Agent-enablement lifecycle

1. A native OpenProject event, approved request, document ingestion, connector sync, or future schedule creates an evidence envelope. The envelope is project-scoped, source-cited, idempotent, and authorization-aware.
2. A native policy and permission service determines whether a specialist may run, which tools it may use, which memories it may retrieve, and whether a human approval is required before any action.
3. OpenProject persists an `AgentRun` control-plane record and queues a native GoodJob/ActiveJob worker. The worker calls the local runtime through a protected adapter and never passes raw connector credentials.
4. The runtime traverses the ontology and knowledge graph, retrieves scoped Letta/Mem0 context, applies published Langflow rules, and returns a structured response with trace, evidence references, uncertainty, escalation, and proposed action.
5. OpenProject persists the response, citations, graph references, approvals, recommendations, and audit journal. Any mutation is a separate governed OpenProject workflow and is not an implicit agent side effect.

## Refactoring rules

New PPM modules must prefer native OpenProject models and services over duplicated source records. A module may add tables for concepts OpenProject does not represent, but it must link them to native projects, users, work packages, memberships, and journals. New agents must be registered in the native contract file, permission map, runtime adapter registry, local route map, tests, and documentation before being advertised as executable.

The initial PMO/Governance dispatch slice is intentionally narrower than the full map. The remaining six specialist routes must be implemented and proven independently; their native contracts are present but they must not be marked operational until their runtime routes, evidence mappings, memory scopes, and OpenProject result persistence are verified.
