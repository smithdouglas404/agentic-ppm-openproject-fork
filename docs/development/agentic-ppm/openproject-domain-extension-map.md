# OpenProject Domain and Agentic PPM Extension Map

## Product authority

The forked OpenProject Rails application owns transactional project data, permissions, workflows, jobs, notifications, queries, reporting, approvals, audit history, and AgentRun control records. The external React command center is a rich client of these fork-owned contracts; it is not an alternate database or product authority.

## Core domain seams

| OpenProject domain | Native source of truth | Agentic PPM extension seam | Default agent posture |
|---|---|---|---|
| Projects and memberships | Project records, hierarchy, membership roles, module permissions | Project-scoped Agentic PPM module, authorization policy, ontology project projection, AgentRun scope | All specialists read only within authorized project scope |
| Work packages and milestones | Work-package records, statuses, dates, relations, versions | Project/work-package projection records, evidence envelope, dependency graph edges | PMO, TMO, VRO, OKR/KPI, OCM read governed evidence |
| Risks, issues, and impediments | Native work-package types, statuses, priorities, assignees, custom fields | Evidence-cited finding references, escalation state, approval/HITL records | PMO, Governance, OCM, TMO produce recommendations; no direct mutation |
| Budgets, costs, and allocations | Native project/custom-field data plus governed FinOps imports | Finance evidence records, scoped financial projections, source provenance | FinOps reads approved financial evidence and escalates variance |
| Teams and actors | Users, roles, memberships, watchers, responsible owners | Actor/entity ontology projection and owner resolution | All escalation targets resolve to authorized owners |
| Workflows and approvals | OpenProject workflow transitions, status rules, permissions | Policy-as-code validation, approval state, governed write service, audit event | Agents recommend; OpenProject users approve governed changes |
| Notifications | Native notification and watcher mechanisms | Agent-run notifications, approval/escalation notices, trace links | Human decisions remain in OpenProject notification/audit flow |
| Queries and reporting | Native saved queries, filters, project reports | Agentic dashboard API, source-cited summaries, methodology views | Read-only analytics until a governed write is approved |
| Audit and history | Native journals, AgentRun records, evidence references, correlation IDs | Runtime trace links, model/memory traces, approval decisions, provenance | Every agent action is reviewable and attributable |

## Agentic module seams

Each specialist module uses the same native seams: a specialist contract in `config/agentic_ppm/agents.yml`; a project-scoped permission policy; an invocation route and `AgentRun` record; a service object for evidence reads; a durable job; a protected runtime dispatch; evidence references and approval state; and an audit/observability projection. Domain-specific modules add only their evidence vocabulary and permitted read tools.

| Module | Native extension seam | Initial evidence vocabulary | Specialist |
|---|---|---|---|
| PMO | Project/work-package projection, dependency relations, AgentRun, escalation | Delivery posture, milestones, dependencies, risks, impediments | PMO |
| VRO | Benefit/value evidence records and accountable owner resolution | Benefits, outcomes, hypotheses, realization variance | VRO |
| OKR/KPI | Objective, measure, key-result and indicator evidence module | Objectives, KPI values, targets, contribution links | OKR/KPI |
| OCM | Change-impact, readiness, stakeholder and adoption evidence module | Readiness, adoption, stakeholder impact, change risk | OCM |
| Governance | Policy, control, decision, approval and exception records | Controls, decisions, approvals, policy references | Governance |
| FinOps | Cost, funding, allocation and forecast evidence module | Cost variance, funding, allocations, forecasts | FinOps |
| TMO | Transformation sequencing and cross-workstream relationship module | Workstreams, dependencies, milestones, blockers | TMO |
| Business Planning | Planning assumptions, capacity, strategy alignment evidence module | Assumptions, capacity, objectives, strategic alignment | Business Planning |

## Read/write boundary

Agents may read only authorized, project-scoped evidence and may record an audited AgentRun, finding, recommendation, escalation, or approval request through native services. Agents may not directly update project records, work packages, budgets, memberships, workflows, or connector credentials. A human or governed policy workflow must approve any business-data mutation; the native OpenProject transaction then performs the write and creates the audit record.

## Integration boundary

Jira, ServiceNow, Excel, Dynatrace, and FinOps providers are ingestion sources, not competing product authorities. Adapters normalize records into a source/provenance envelope, validate endpoint and policy metadata, and write only through governed native projection services. The ontology and Memgraph projection preserve source identity, observed time, mapping profile, and correlation ID. The Agentic PPM UI consumes fork-owned APIs and never bypasses native authorization to contact provider systems directly.
