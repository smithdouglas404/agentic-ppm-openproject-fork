# Native Agentic PPM execution model

## Decision

OpenProject is the product and the system of record. Agentic PPM is implemented as native code in the fork, primarily through the `modules/agentic_ppm` Rails engine. The engine owns project scope, permissions, database records, evidence provenance, workflow state, approvals, audit history, and user-visible controls.

The PMO Agent, VRO Agent, OKR/KPI Agent, OCM Agent, Governance Agent, FinOps Agent, TMO Agent, and Business Planning Agent are autonomous specialist execution contracts. They are not pages that a user must open, and they are not a separate governance application. Pages and conversations are optional observation or interaction surfaces for inspecting a run, supplying an approved request, reviewing evidence, or approving a recommendation.

## Execution boundary

```text
OpenProject event, approved request, or native schedule
        |
        v
Native Agentic PPM authorization and evidence scope
        |
        v
AgentRun record + correlation ID + project-scoped evidence references
        |
        v
Native AgentRunJob
        |
        v
Protected local LangGraph/LangChain runtime
        |
        +--> Letta: specialist state, scoped to project/user/agent
        +--> Mem0: approved memory extraction and retrieval
        +--> Memgraph: ontology and relationship traversal
        +--> LiteLLM: configured model-provider boundary
        +--> Langflow: governed visual business rules where published
        |
        v
Structured result, citations, trace, escalation, and approval state
        |
        v
OpenProject AgentRun, findings, recommendations, and audit history
```

Supporting services are internal dependencies of the fork. They must be reachable from the created local or Cloud Computer environment and protected by managed credentials. No supporting service may bypass OpenProject authorization, write directly to source-system records, read cross-project evidence, access raw connector credentials, or retrieve unscoped memory.

## Current native implementation

`AgenticPpm::Agents::InvocationService` creates the OpenProject-owned `AgentRun` record. When the protected local runtime contract is configured, it enqueues `AgenticPpm::AgentRunJob`. The job delegates to `AgenticPpm::Agents::RuntimeDispatchService`, which calls an explicitly registered local runtime route and persists only the returned asynchronous state, response envelope, and evidence references. If the runtime is not configured, the record remains `unavailable`; the module does not fabricate an answer.

The first registered runtime routes are PMO and Governance because those routes already exist in the local LangGraph service. The remaining six specialists retain their exact native contracts and must receive their own real local runtime routes before being marked executable. This is an evidence gate, not a reason to represent them as completed.

## Runtime and deployment rule

The native OpenProject fork is the authoritative application. The supporting services are deployed in the created local/Cloud Computer/Docker environment. External hosting is optional and must never be required for local development, native OpenProject operation, or customer demonstration. Existing historical deployment artifacts must not be treated as user-approved architecture.

## Safety requirements

Every run must carry an OpenProject user ID, project ID, specialist invocation key, authorization decision, correlation ID, evidence references, model-provider trace, and memory-retrieval trace. Agent output is advisory until a native approval policy allows an action. The first rollout must not permit an agent to mutate OpenProject or external source systems directly; all actions must return through a governed OpenProject workflow.
