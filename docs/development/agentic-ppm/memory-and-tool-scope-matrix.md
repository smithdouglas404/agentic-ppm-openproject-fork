# Agent Memory, State, and Tool Scope Matrix

## Scope key

Every state or memory operation is keyed by `tenant/workspace/project/principal/specialist`. A run correlation ID is retained as an audit dimension but is not a substitute for project scope. A missing tenant, project, principal, or specialist fails closed.

## Letta state scopes

| Specialist | Canonical identity | Letta state scope | Retention and deletion |
|---|---|---|---|
| PMO | `agentic_ppm/PMO` | Project portfolio posture, work-package context, approved evidence summary, open escalations | Retain by project policy; delete with project/tenant erasure request |
| VRO | `agentic_ppm/VRO` | Value hypotheses, benefits, measures, checkpoints, realization gaps | Retain by value-stream policy; delete with project/tenant erasure request |
| OKR/KPI | `agentic_ppm/OKR_KPI` | Objectives, key results, KPI definitions/versions, sourced observations | Retain by objective period; delete expired project/person scope |
| OCM | `agentic_ppm/OCM` | Change initiatives, stakeholder groups, readiness dimensions, interventions | Retain aggregate readiness; delete personal/sensitive scope on request |
| Governance | `agentic_ppm/GOVERNANCE` | Active approved policy versions, control posture, exceptions, validation trace | Retain by policy/audit schedule; preserve immutable approval audit |
| FinOps | `agentic_ppm/FINOPS` | Funding, costs, allocations, forecasts, assumptions, variances | Retain by finance policy; delete project scope without deleting statutory audit |
| TMO | `agentic_ppm/TMO` | Transformation streams, dependency chains, milestones, outcomes, sequence risks | Retain by transformation horizon; delete project scope on request |
| Business Planning | `agentic_ppm/BUSINESS_PLANNING` | Assumptions, capacity envelopes, scenarios, planning options, alignment | Retain by planning period; delete expired scenario drafts |

Letta state contains current working context and approved control cards. It does not become an uncontrolled source of truth. Native OpenProject records and accepted evidence remain authoritative.

## Mem0 memory scopes

Mem0 uses the same composite namespace and stores only evidence-allowlisted, source-cited episodic findings. The memory payload must include `tenant_id`, `workspace_id`, `project_id`, `principal_id`, `specialist`, `correlation_id`, source/entity references, observed time, confidence, approval state, and retention class. Retrieval always applies all scope dimensions; no global specialist search is permitted.

Extraction is limited to findings that pass the evidence-steward source/entity match gate. Low-severity, uncited, cross-project, malformed, or unapproved findings are not written. Deletion removes the scoped memory records and retrieval indexes while native audit records retain the deletion event and reason.

## Tool allowlists

| Tool class | Allowed uses | Prohibited uses |
|---|---|---|
| OpenProject read | Scoped projects, work packages, risks, issues, budgets, teams, objectives, evidence | Cross-project reads, hidden user data, unbounded exports |
| OpenProject governed write | Native AgentRun, recommendation, approval request, audit event | Direct SQL mutation, silent budget/policy/schedule change |
| Memgraph read/write | Approved ontology projection, scoped relationship query, provenance correlation | Unscoped graph traversal, secret storage, unsupported entity creation |
| Letta | Scoped state cards, identity resolution, lifecycle update | Cross-agent state access, raw credential storage |
| Mem0 | Scoped retrieval and evidence-allowlisted episodic write/delete | Global retrieval, uncited write, tenant bypass |
| Langflow | Authorized policy-flow authoring, simulation, validation trace | Direct production publish without native approval |
| Jira/ServiceNow/FinOps/Dynatrace connectors | Credential-free governed read-only adapter calls when enabled | Raw credential exposure, write/mutation, disabled connector calls |
| LLM | Classification, synthesis, deterministic-tool interpretation with citations | Invented evidence, unapproved action, hidden policy change |

## Activation validation

A specialist route may activate only when its native contract, canonical identity, required memory/state scope, evidence mapping, tool allowlist, output schema, and escalation owner are present. The validator must report missing or mismatched fields and reject activation; it must never silently downgrade to a generic agent.
