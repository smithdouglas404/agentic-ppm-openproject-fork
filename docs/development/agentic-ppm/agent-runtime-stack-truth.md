# Agentic PPM runtime-stack truth

This document is the source-of-truth boundary for the Agentic PPM runtime. It prevents a native contract, UI surface, disabled adapter, or external service configuration from being reported as a live capability without executable evidence.

## Product boundary

The private OpenProject fork is the product source of truth. Native OpenProject projects, work packages, memberships, permissions, workflows, jobs, migrations, audit records, and Agentic PPM engine records remain authoritative for transactional behavior. The retained rich React interface is a client experience and must use authenticated, project-scoped contracts; it is not a replacement for the fork.

The semantic graph is an analysis projection. It may support traversal, correlation, trend analysis, and evidence retrieval, but it must not replace native OpenProject transactional records. External providers are staged through source records, mapping policy, provenance, authorization, and an explicit approved synchronization workflow.

## Current framework decisions

| Capability | Target role | Current truth | Activation boundary |
|---|---|---|---|
| Native OpenProject Rails engine | Product core, permissions, workflows, audit, transactional records | Implemented native module contracts and protected routes exist in the fork | Run the fork against its supported PostgreSQL environment and execute focused engine/request specs |
| OpenProject native jobs | Durable projection, synchronization, and agent-run trigger boundary | Native AgentRun model/dispatch and projection contracts are present | Demonstrate a persisted job/run with correlation, evidence, outcome, and audit records |
| LangGraph | Agent-flow orchestration for resumable, multi-agent, approval, or long-running work | Chosen target orchestration for specialist flows; live local proof remains pending | Execute a source-backed PMO flow through the protected OpenProject handoff and preserve the run trace |
| LangChain | Model/tool abstraction used inside LangGraph flows where needed | Permitted as a subordinate library, not an alternative orchestration system | Record a real tool/model call with policy, source scope, and correlation evidence |
| Letta | Specialist-agent state and conversation state | Identity, scope, and adapter contracts are defined; live eight-identity proof remains pending | Prove protected state creation/read/write for all eight specialist identities with project scope |
| Mem0 | Scoped long-term memory and retrieval | Memory model and protected retrieval contract exist; live approved-finding persistence remains pending | Prove source-cited write/read, retention, deletion, and failure visibility |
| Memgraph | Knowledge-graph projection and traversal | Ontology vocabulary and projection envelope are defined; live service health/query proof remains pending | Prove authorized graph projection, query, rollback, and source-backed UI result |
| Langflow | Visual business-rule composition and versioning | Native rule validation/simulation/publication lifecycle is implemented; live authorized visual-flow execution remains pending | Prove business-owner draft, validation, simulation, approval, publish, rollback, and audit without bypassing OpenProject permissions |
| LiteLLM | Provider routing, model policy, and approved model aliases | Protected provider configuration was validated in the managed environment; the full local stack remains pending | Prove authenticated chat and embedding calls from the intended agent runtime |
| Inngest AgentKit | Optional event triggering only when a named workflow requires it | Evaluated against native GoodJob/ActiveJob; not the default agent orchestrator | Do not enable it unless a concrete durable external-event workflow is documented and tested |

## Evidence rules

A service is **configured** when its endpoint and protected credential reference pass configuration validation. A service is **reachable** when a protected health or contract request succeeds. A capability is **live** only when a source-backed operation succeeds and its correlation, authorization, provenance, and failure behavior are persisted or otherwise captured in the governed trace.

The following states must remain visible to operators and users:

| State | Meaning | Permitted product behavior |
|---|---|---|
| Disabled | No approved endpoint/credential or feature activation exists | Show setup guidance; do not call the provider |
| Configured | Approved metadata and protected credential reference exist | Show readiness; permit only the explicitly approved health or onboarding operation |
| Degraded | A configured capability has an attention condition, failed dependency, stale projection, or partial result | Show the failure boundary and remediation; do not silently substitute fabricated evidence |
| Live | A source-backed end-to-end proof has passed | Permit the proven operation within native authorization and evidence scope |

## Security and data handling

Raw credentials never enter the rich UI, graph evidence, agent prompts, memory content, logs, or source control. Agent tools must use scoped server-side references. Every graph fact and agent finding must carry source system, source record, project/tenant scope, observed time, ontology/mapping version, correlation ID, and authorization context. Missing evidence must be stated explicitly.

## Verification sequence

The required order is: boot the unmodified OpenProject fork; verify PostgreSQL, Redis, worker, authentication, permissions, and migrations; load the Agentic PPM engine; create or ingest a real project; project it into the ontology; verify the graph projection; execute one protected PMO flow; approve evidence before memory persistence; and only then expand to the remaining specialist vertical slices or external connectors.

The current Ruby bundle is installed under Ruby 4.0.6. Focused native RSpec is not yet a completed proof because the inherited TiDB-style `DATABASE_URL` is invalid for Rails and the temporary PostgreSQL URL has no available local PostgreSQL credentials. This is an environment blocker, not evidence that the native lifecycle code passed.
