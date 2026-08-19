# Rich UI to Native OpenProject Contract Map

## Boundary

The rich React command center is an operator experience for native OpenProject data and Agentic PPM runtime observations. It does not own project, work-package, approval, connector, memory, or graph records. Every surface either reads a fork-owned API, submits a governed native command, or displays an agent-runtime observation linked to an OpenProject `AgentRun` and evidence provenance.

| UI surface | Native contract | Operation class | Required trace |
|---|---|---|---|
| Command center | Project dashboard, projection records, relationships, alerts, AgentRuns | Read-only plus governed recommendation links | Project, user, source records, correlation ID |
| Specialist agents | AgentRun index/show/create, specialist registry, conversation workspace | Governed agent invocation; no direct business-data write | Specialist key, authorization, prompt, model trace, memory trace |
| Knowledge graph | Graph API, entity API, projection records, relationship provenance | Read-only graph exploration | Entity keys, source IDs, observed time, project scope |
| Integration hub | Connector metadata, policy validation, adapter sync runs | Governed connector setup and read-only sync | Provider, endpoint policy, mapping profile, provenance, sync ID |
| File mapper | Upload metadata, mapping profile, validation run, source envelope | Governed ingestion; bytes stored through approved storage boundary | File metadata, mapping profile, source hash, validation result |
| Domain reporting | Native query/report contracts plus projection evidence | Read-only analytics | Query ID, project scope, source record IDs |
| Portfolio intelligence | Dashboard evidence service, AgentRuns, recommendations, approvals | Read-only synthesis plus governed approval links | Finding ID, evidence citations, approval state, owner |
| Workspace modules | Native project module flags and module-specific records | Governed module activation/configuration | Project, module key, actor, authorization decision |
| Activity and tracing | Native audit/journal records, AgentRun observability, runtime traces | Read-only audit and operational review | Correlation ID, user, service, provider, state transition |
| Chat | Conversation workspace, AgentRun creation, runtime polling | Governed PMO/VRO interaction; recommendations only | User, project, specialist, prompt, citations, run state |

## Operation rules

**Read-only operations** may query only the current user’s authorized OpenProject scope. They must return project identity, source/provenance references, and an explicit empty state when no evidence exists. The UI must not manufacture graph nodes, alerts, recommendations, ratings, or customer testimonials.

**Governed writes** must enter through native Rails controllers/services, use OpenProject permission checks, create an audit/journal record, and expose approval state. Connector syncs must remain read-only until a separate governed write workflow is approved. Agent recommendations are not business-data writes.

**Agent-runtime observations** are not authoritative project records. They are linked to a native `AgentRun`, specialist contract, evidence references, model-provider trace, memory retrieval trace, and outcome state such as `requested`, `running`, `completed`, `failed`, `unavailable`, or `needs_review`.

## Data-flow rule

The UI requests fork-owned APIs. Native OpenProject authorizes the request, reads or writes native records, and emits an evidence envelope or AgentRun correlation when runtime work is needed. LangGraph/LangChain consumes only accepted project-scoped evidence. Letta and Mem0 are scoped by workspace/project/user/specialist; Memgraph receives source-provenant projections. Results return to the native control plane before the UI renders them.

## Current implementation posture

The command center currently renders verified code-level contracts and explicit NOT VERIFIED states for unavailable services. This map defines the target integration boundary; it does not claim that every UI operation or live service has already been executed in the current Manus sandbox.
