# Autonomous Decision Log

## Purpose

This log records material decisions made during the delegated autonomous implementation window. Each entry identifies the decision, rationale, boundaries, and the conditions that would require reconsideration. It is part of the delivery evidence for this fork.

| ID | Decision | Rationale | Boundary and review trigger |
| --- | --- | --- | --- |
| AD-001 | The GitHub repository `smithdouglas404/agentic-ppm-openproject-fork` is the upstream-linked OpenProject fork and primary Agentic PPM codebase. | The product must become an OpenProject-native application rather than a separate companion product. | Re-evaluate only if the organization moves the fork to an enterprise GitHub owner. |
| AD-002 | OpenProject remains the operational system of record; Memgraph is the semantic graph runtime. | Project workflows and permissions must remain native, while cross-domain intelligence needs graph-native relationships and provenance. | Validate source-of-truth synchronization and conflict rules before the first real project sync. |
| AD-003 | Letta is the persistent specialist-agent runtime and Mem0 is the scoped memory extraction/retrieval layer. | Separates enduring agent state from portable retrieval memories and keeps both policy-bound. | Re-evaluate after live agent workload and memory-quality measurements. |
| AD-004 | Langflow is the visual composition layer for approved end-user business rules and agent flows. | It enables business-user changes without requiring engineers for every permitted workflow adjustment. | Visual flows cannot bypass OpenProject authorization, credentials, transactional commits, or external write policy. |
| AD-005 | The term AgentKit refers to **Inngest AgentKit**. It is a candidate multi-agent orchestration library, not the primary persistent-agent runtime. | Its agent networks, routers, tools, state, MCP support, and Anthropic support complement event-driven orchestration but overlap with Letta. | Adopt only when a specific multi-agent workflow cannot be expressed cleanly through OpenProject-native services, Letta, and the selected event runtime. |
| AD-006 | Traditional cron is not the primary workflow mechanism for Agentic PPM. | Critical synchronization and agent workflows require idempotency, retries, checkpoints, traceability, and durable event behavior. | Select native Good Job or Inngest after comparative implementation analysis; maintain one authoritative workflow history. |
| AD-007 | No real external credentials, user accounts, or production service activation will be created without an approved target environment and an available authorization path. | The user authorized autonomous decisions but did not supply a target OpenProject instance or secret-management route. | Continue immediately once the extended service environment provides the controlled evaluation instance. |
| AD-008 | The current development sandbox does not provide Docker, so service runtimes are defined through non-blocking Compose profiles and managed-secret adapters rather than started in this environment. | OpenProject, Memgraph, Langflow, and self-hosted Mem0 services require container-capable infrastructure; the user explicitly directed that development not wait for them. | Activate the existing Compose profile in an extended container-capable server environment; do not change the native module contracts. |
| AD-009 | The first code slice is a minimal `modules/agentic_ppm` OpenProject engine with project permissions, native project navigation, protected routes, a transparent capability-state view, and configuration-driven adapters. | This proves the application is being extended in the fork without pretending that unavailable external services are operational. | Add persisted ontology projection metadata and a native event/job implementation next; do not add provider-specific logic to controllers. |

## Current operating assumption

Implementation proceeds without routine confirmation. The work pauses only for an unavoidable external credential, access boundary, payment, or irreversible production action.
