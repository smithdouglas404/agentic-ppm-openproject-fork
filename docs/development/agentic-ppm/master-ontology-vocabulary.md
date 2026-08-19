# Agentic PPM Master Ontology Vocabulary

## Authority and identifiers

OpenProject remains the transactional source of truth for project, work-package, actor, membership, status, and native audit records. The knowledge graph is a derived, provenance-bearing semantic projection. Every graph entity and relationship carries `tenant_id`, `workspace_id`, `project_id` where applicable, `source_system`, `source_record_id`, `source_version`, `observed_at`, `ingested_at`, and `correlation_id`.

Canonical identifiers use `apm:<namespace>:<type>:<stable-key>`. Native OpenProject identifiers are preserved as source keys and are never replaced by generated graph IDs. A graph entity without a source reference is not authoritative and cannot drive a governed write.

## Namespaces and concepts

| Namespace | Canonical concepts | Primary source/boundary |
|---|---|---|
| `portfolio` | portfolio, investment theme, strategic objective, funding envelope, decision | OpenProject portfolio/module records and approved planning evidence |
| `project` | project, program, work package, milestone, deliverable, dependency, methodology profile | OpenProject native records |
| `delivery` | stream, phase, sprint, release, outcome, schedule baseline, forecast | OpenProject plus approved source connectors |
| `value` | value hypothesis, benefit, measure, KPI, OKR, realization checkpoint, variance | Native OKR/KPI/VRO modules and source evidence |
| `people` | actor, team, role, membership, stakeholder group, owner, approver | OpenProject identity/membership and governed OCM records |
| `finance` | budget, funding envelope, cost, allocation, forecast, currency, variance, approval | Native FinOps module and approved finance evidence |
| `change` | change initiative, impact, readiness assessment, adoption signal, intervention, change risk | Native OCM module and governed evidence |
| `governance` | policy, control, rule, exception, approval, evidence, decision, audit event | Native Governance module and policy lifecycle |
| `planning` | assumption, scenario, option, capacity envelope, constraint, alignment assessment | Business Planning module and approved planning evidence |
| `risk` | risk, issue, action, decision, dependency, escalation, control gap | Native RAID/governance records and approved evidence |
| `agent` | specialist, AgentRun, finding, recommendation, trace, memory reference | OpenProject control plane and agent runtime traces |

## Relationship vocabulary

Relationships are directed, typed, and provenance-bearing. Core types are `contains`, `depends_on`, `blocks`, `delivers`, `owns`, `approves`, `assigned_to`, `supports`, `measures`, `contributes_to`, `realizes`, `funded_by`, `allocated_to`, `impacts`, `mitigates`, `governed_by`, `violates`, `aligned_to`, `derived_from`, `observed_in`, `correlates_with`, `escalates_to`, and `supersedes`.

A relationship requires source references on both endpoints, a source record or accepted evidence envelope, observed time, and confidence. `derived_from` and `correlates_with` are analytical relationships and cannot directly mutate OpenProject records. `owns`, `approves`, `governed_by`, and `funded_by` require authorization and native control-plane records before they are treated as decision facts.

## Methodology profiles

A project has one active methodology profile and may retain versioned historical profiles. Supported profiles are waterfall, agile, hybrid, SAFe, Scrum, Kanban, Lean Portfolio Management, and customer-defined profiles. Each profile maps lifecycle states, planning cadence, evidence expectations, role vocabulary, and allowed transitions without changing the identity of native OpenProject records.

## Constraints and provenance

Project and workspace scope is mandatory for all agent, memory, graph, and UI queries. Cross-project relationships require an explicit approved portfolio scope. People and financial records require stronger authorization and cannot be inferred from unapproved text. Numeric metrics retain unit, currency, period, timezone, and observation status. Model-derived hypotheses are labeled `inferred` and cannot be presented as observed facts.

Ontology changes are versioned. A vocabulary or mapping change records actor, rationale, effective time, superseded version, affected namespaces, migration status, and rollback plan. Deletion is tombstoning with provenance retention; source corrections produce a new observed version rather than overwriting history.
