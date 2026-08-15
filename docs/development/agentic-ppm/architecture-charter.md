# Agentic PPM Architecture Charter

## Status and binding direction

This fork is the **primary application codebase** for Agentic PPM. It is not a separate dashboard, a copy of OpenProject’s interface, or a thin API companion. Every new capability must be designed as an OpenProject-native extension that respects upstream conventions, workflows, authorization, data integrity, upgrade paths, and testing practices.

> **OpenProject remains the authoritative system of record for projects, work packages, memberships, schedules, status, and workflow state.** The Agentic PPM ontology and graph layer is the authoritative semantic intelligence model for cross-domain relationships, evidence, trends, recommendations, and portfolio reasoning.

The application must support hybrid, scaled Agile, and waterfall delivery without assuming a single delivery method. Project, work-package, milestone, dependency, person, risk, decision, objective, KPI, cost, change, service, and external-source evidence must be represented through the master ontology and be traceable back to source records.

## Non-negotiable product requirements

| Capability | Binding requirement |
| --- | --- |
| Base product | Extend this OpenProject fork rather than building an isolated replacement application. |
| Specialist agents | Provide exactly eight specialist agents: **PMO**, **VRO**, **OKR/KPI**, **OCM**, **Governance**, **FinOps**, **TMO**, and **Business Planning**. |
| Native modules | Implement OKR/KPI, OCM, Governance, portfolio intelligence, integrations, agent operations, ontology, and graph experiences as OpenProject-native module capabilities. |
| Knowledge graph | Use a master ontology and semantic layer to capture source identities and relationships, identify trends, and underpin evidence-based recommendations. |
| Memory | Use Letta for stateful agent operations and Mem0 for scoped memory extraction and retrieval. Memory must remain tenant-, user-, role-, and agent-aware. |
| Graph runtime | Use Memgraph as the graph runtime when graph traversal, relationship analysis, or graph-native reasoning is required. Do not substitute an in-memory visual graph for the graph runtime. |
| Model provider | Make model invocation configuration-driven. Claude may provide reasoning, but no Agentic PPM agent may be coupled to a single provider’s SDK, identifiers, or request format. |
| Integrations | Support governed connections and mapping contracts for OpenProject, Jira, ServiceNow, Dynatrace, and FinOps sources, with upload and connector alternatives where appropriate. |
| Orchestration | Provide routing, observability, traceability, policy checks, and action boundaries for all specialist agents. |
| Visual business rules | Use Langflow as a governed visual composition surface for approved end-user changes, with native lifecycle controls for draft, test, approval, publish, rollback, and audit. |
| Security | Keep credentials server-side; enforce OpenProject permissions and workspace policy boundaries; treat external synchronization as read-only until explicitly approved otherwise. |
| Demonstration proof | Create one representative project in a real OpenProject environment, synchronize it, deduplicate and map it into the ontology and knowledge graph, then inspect the graph and agent evidence. |

## Product invariants

The following invariants must be preserved in every design and code review.

1. **No parallel product shell.** Agentic PPM navigation, screens, workflows, permissions, and records must live within the OpenProject fork’s application structure.
2. **No hard-coded customer process.** Delivery method, source mappings, thresholds, ontology extensions, workflows, and agent policies must be configuration- or data-driven.
3. **Graph evidence is source-linked.** Every graph entity and relationship must preserve its origin, observed time, source key, confidence, and mapping rationale.
4. **No unsupervised external write.** Initial adapters ingest and reason over data. Any source mutation requires a separately designed approval, policy, and audit workflow.
5. **Memory is bounded and auditable.** Letta and Mem0 retrieval must identify agent, user, workspace, scope, retention rules, and source evidence.
6. **Agent output distinguishes evidence from recommendation.** Agents may infer and recommend, but must never present inferred conclusions as source facts.
7. **OpenProject upgrades remain possible.** Upstream touchpoints must be minimal, documented, tested, and isolated through modules, services, contracts, migrations, and feature flags where the framework permits.
8. **Agent construction remains explicit.** Letta is the persistent specialist-agent runtime; Mem0 is scoped memory retrieval; Memgraph is the semantic graph runtime; OpenProject-native services enforce policy and workflow boundaries.
9. **Visual configuration is governed.** Business users may change approved workflow and rule behavior visually, but cannot bypass OpenProject authorization, alter core schema, access credentials, or publish unsafe external actions.

## Target service boundary

| Layer | System | Responsibility | Source of truth |
| --- | --- | --- | --- |
| Operational project platform | OpenProject fork and PostgreSQL | Projects, work packages, work-package relations, users, memberships, permissions, workflow state, documents, and native PPM modules | OpenProject database |
| Semantic intelligence | Memgraph | Ontology-backed entities, relationships, graph traversal, graph analytics, provenance, confidence, and cross-domain correlation | Memgraph graph model with source pointers |
| Stateful agent runtime | Letta | Long-lived specialist-agent state, governed tool use, role-specific context, and conversational continuity | Letta state, constrained by source policy |
| Memory extraction and retrieval | Mem0 | Scoped memory capture, semantic recall, and memory lifecycle controls | Mem0, linked to source evidence and policy |
| Integration runtime | OpenProject-native service layer | Read-only external adapters, mapping, synchronization, validation, retries, and audit records | OpenProject integration records plus source systems |

## Delivery sequence

The work must proceed in the following order: understand the OpenProject codebase; identify stable extension points; define native modules and service contracts; provision the required services; add thin native scaffolding; create a real OpenProject project; synchronize and validate the ontology; and only then expand agent and portfolio experiences.

No component is considered complete merely because its interface renders. Completion requires native placement in the fork, source-backed data behavior, authorization coverage, tests, observability, documentation, and an upgrade-aware design.

## References

[1] [OpenProject upstream repository](https://github.com/opf/openproject)

[2] [OpenProject contributor instructions in this fork](../../../AGENTS.md)

[3] [Agent Runtime and Model Provider Contract](agent-runtime-contract.md)

[4] [Orchestration and Visual Business-Rule Decision Record](orchestration-decision-record.md)

[5] [Service Activation Contract](service-activation-contract.md)

[6] [OpenProject-Native Agentic PPM Module Design](native-module-design.md)
