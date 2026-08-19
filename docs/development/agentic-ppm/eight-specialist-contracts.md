# Agentic PPM Eight-Specialist Contracts

## Contract boundary

The eight specialists are **autonomous executable contracts**, not pages that a user must open. OpenProject remains the control plane for project identity, permissions, AgentRun records, evidence references, approval state, and audit history. LangGraph provides the shared resumable workflow; LangChain provides the model invocation path; Letta provides specialist state and cards; Mem0 provides scoped episodic memory; and Memgraph provides source-cited relationship context.

Every invocation carries `openproject_user_id`, `project_id`, `agent_invocation_key`, `authorization_decision`, `evidence_references`, `model_provider_trace`, and `memory_retrieval_trace`. Letta state is scoped to `project_user_agent`; conversation state is scoped to `project_and_authorized_user`; Mem0 memory is scoped to `workspace_project_user_agent_policy`. Tools are deny-by-default. Agents cannot perform direct OpenProject writes outside governed workflows, cross project boundaries without permission, access raw connector credentials, or retrieve unscoped memory.

## Specialist contract matrix

| Invocation key | Runtime route | Responsibility | Permitted tools | Output | Escalation |
|---|---|---|---|---|---|
| `PMO` | `/api/agents/pmo/run` | Portfolio delivery oversight, dependency awareness, and decision-readiness synthesis | `read_project_evidence`, `read_dependency_relationships`, `record_audited_agent_run` | Evidence-cited delivery posture, dependency signals, and escalation-ready portfolio summaries | Authorized PMO owner |
| `VRO` | `/api/agents/vro/run` | Value-realization hypothesis tracking and benefits-evidence synthesis | `read_project_evidence`, `read_value_evidence`, `record_audited_agent_run` | Evidence-cited value posture and benefit-realization questions | Value-realization owner |
| `OKR_KPI` | `/api/agents/okr-kpi/run` | Objective, key-result, and indicator evidence interpretation | `read_project_evidence`, `read_objective_evidence`, `record_audited_agent_run` | Traceable objective-contribution and KPI-evidence summaries | Authorized objective owner |
| `OCM` | `/api/agents/ocm/run` | Organizational-change readiness, adoption, and stakeholder-evidence interpretation | `read_project_evidence`, `read_change_evidence`, `record_audited_agent_run` | Evidence-cited readiness posture and change-risk questions | Authorized change owner |
| `GOVERNANCE` | `/api/agents/governance/run` | Decision, control, policy, and approval-evidence interpretation | `read_project_evidence`, `read_governance_evidence`, `record_audited_agent_run` | Evidence-cited governance posture and approval-readiness questions | Authorized governance owner |
| `FINOPS` | `/api/agents/finops/run` | Cost, funding, allocation, and financial-evidence interpretation | `read_project_evidence`, `read_financial_evidence`, `record_audited_agent_run` | Evidence-cited financial posture and accountable-finance questions | Authorized finance owner |
| `TMO` | `/api/agents/tmo/run` | Transformation sequencing, cross-workstream, and dependency-evidence interpretation | `read_project_evidence`, `read_dependency_relationships`, `record_audited_agent_run` | Evidence-cited sequencing posture and escalation-ready dependencies | Authorized transformation owner |
| `BUSINESS_PLANNING` | `/api/agents/business-planning/run` | Business-plan assumption, capacity, and strategic-alignment evidence interpretation | `read_project_evidence`, `read_planning_evidence`, `record_audited_agent_run` | Evidence-cited planning posture and accountable-owner questions | Authorized planning owner |

## Invocation lifecycle

An invocation begins from an approved project/evidence event or a governed user request. The native OpenProject authorization boundary is evaluated first. The AgentRun records the specialist key, project, requesting user, correlation ID, prompt, and authorization decision. The runtime then loads accepted project-scoped evidence, retrieves only the specialist’s scoped memory, resolves the exact Letta identity `agentic_ppm/<INVOCATION_KEY>`, mounts policy and evidence cards, invokes the shared LangGraph workflow through LangChain, and records the resulting response, citations, memory traces, and approval state.

Mem0 writes occur only after the evidence steward matches each finding’s source and entity key to an accepted OpenProject envelope. Human approval, refusal, or escalation remains a native OpenProject control-plane state; an agent recommendation is not a direct business-data mutation. Any missing credential, unavailable service, unauthorized project, absent evidence, failed model trace, or failed memory operation produces an explicit governed failure or `needs_review` state rather than fabricated output.

## Implementation references

The native identity and permission contract is defined in `config/agentic_ppm/agents.yml`. The native Rails sender is `OpenProjectEvidenceHandoffService`; the private runtime receiver is `/api/openproject/evidence`; the shared dispatcher is the eight-route registry in `agent_server.py`; and the LangGraph execution and memory/evidence gates are in `governance_langgraph.py`. Live service-backed execution remains a separate verification gate and must not be inferred from this contract document.
