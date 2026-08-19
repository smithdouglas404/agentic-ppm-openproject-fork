# Agentic PPM Service Security and Health Contract

## Runtime boundary

The target runtime is local Docker Compose during development and Mac Studio Docker Desktop for later transfer. Services communicate over an internal Compose network. Railway and public service-to-service calls are excluded. The native OpenProject fork remains the transaction and authorization authority.

## Authentication

| Path | Authentication | Authorization boundary | Failure behavior |
|---|---|---|---|
| OpenProject → agent runtime | `X-Agent-Key` over internal network | Project-scoped evidence handoff and AgentRun correlation | Reject missing/invalid key; do not persist envelope |
| Agent runtime → Letta | `LETTA_TOKEN` or protected alias | Canonical specialist identity and scoped state | Fail closed; preserve run as unavailable/retryable |
| Agent runtime → Mem0 | `MEM0_API_KEY` or protected alias | Composite tenant/workspace/project/principal/specialist scope | Reject unscoped retrieval/write |
| Agent runtime → Memgraph | Internal Bolt/HTTP credential over private network | Ontology projection and scoped graph query | Mark graph context unavailable; do not fabricate relationships |
| Agent runtime → LiteLLM | Internal key over private network | Provider/model policy and correlation ID | Return model-unavailable posture; no fallback to remote endpoint |
| Business owner → Langflow | Protected application/API key, secure cookie, restricted CORS | Flow authoring/simulation only until native approval | Block publish without validation and native approval |
| Browser → OpenProject/UI | Native session/OAuth and OpenProject permissions | User/project/workspace authorization | Deny unauthorized access and mutation |

Secrets are injected through protected environment configuration. They are never written to source, prompt text, graph nodes, evidence envelopes, memory payloads, or logs. Explicit local variable names take precedence over managed aliases; missing required credentials fail closed.

## Rotation

Rotate `AGENT_BACKEND_KEY`, Letta token, Mem0 key, Memgraph credential, LiteLLM key, and Langflow application keys independently. Rotation uses overlap windows: accept old and new only during a bounded operator-approved window, update dependent services, probe authenticated health, then revoke the old credential. A rotation record contains actor, timestamp, affected service, key version, probe result, and rollback decision without storing secret material.

## Network and TLS policy

Development services bind to the private Compose network and expose only explicitly documented operator ports. Mac Studio Docker Desktop may expose the UI through a user-controlled reverse proxy; internal service ports remain private. Production or customer-facing traffic requires TLS termination, secure cookies, restricted CORS, and certificate rotation. Internal plaintext is permitted only inside the isolated development network and must be labeled as such in the runtime posture.

## Health and readiness

Health is split into four states: `source_contract_ready`, `configured`, `reachable`, and `operational`. A `/docs` or process response is not equivalent to authenticated dependency health. Readiness probes must verify the service process, credentials, database/graph dependency, and one bounded read/write operation where safe. The runtime must report dependency-specific states and never upgrade `NOT VERIFIED` to healthy from configuration alone.

Required checks are: OpenProject login and native health; agent runtime `/health`, contract status, and protected evidence receiver; Letta authenticated identity listing and scoped state read; Mem0 authenticated scoped write/search/delete; Memgraph authenticated query and provenance projection; LiteLLM policy endpoint and bounded model/embedding probe; Langflow health, protected flow retrieval, validation callback, simulation trace, publish, and rollback; and GoodJob/AgentRun enqueue, consume, poll, and terminal persistence.

## Failure states

| State | Meaning | Allowed action |
|---|---|---|
| `NOT_CONFIGURED` | Required endpoint or credential absent | Show setup requirement; no invocation |
| `UNREACHABLE` | Network/process unavailable | Retry with bounded backoff; preserve source run |
| `UNAUTHORIZED` | Credential rejected | Stop writes; create rotation/incident record |
| `DEPENDENCY_FAILED` | Database, graph, or provider dependency failed | Keep agent run non-terminal/retryable or `needs_review` |
| `EVIDENCE_BLOCKED` | Source/entity steward check failed | Skip memory write and escalate |
| `OPERATIONAL` | Authenticated bounded checks passed | Permit governed invocation within scope |

No health check may seed synthetic evidence, fabricate a finding, or delete persistent data as a recovery action.
