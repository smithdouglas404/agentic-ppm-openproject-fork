# Agentic PPM Docker Desktop Runbook

## Purpose

This runbook defines the target local deployment for the **forked OpenProject application as the product authority**. The retained rich UI, agent runtime, LangGraph/LangChain flow, Letta, Mem0, Memgraph, Langflow, LiteLLM, RAGLite, connectors, and observability services are supporting components. They must not become a parallel product authority.

The current Manus sandbox does not have a reachable Docker daemon. Therefore this document defines the portable target and verification procedure; it is not evidence that the stack is currently running.

## Topology

The canonical Compose overlay is `docker-compose.macstudio.yml`. Its service groups are:

| Group | Services | Authority |
|---|---|---|
| Product core | `backend`, `worker`, `governance-db` | Native forked OpenProject and its database |
| Client experience | `rich-ui` | Reads/writes only through fork-owned APIs |
| Agent runtime | `agent-runtime`, `agent-postgres` | LangGraph/LangChain specialist flows and runtime state |
| Memory and graph | `letta`, `mem0`, `memgraph`, `fuseki` | Specialist state, scoped memory, semantic graph, ontology support |
| Model and evidence | `litellm`, `raglite` | Model routing, embeddings, and source evidence retrieval |
| Governance | `langflow` | Visual business-rule composition behind OpenProject permissions and lifecycle |

## Required configuration

Create a local `.env` from `.env.macstudio.example` and provide secrets through a protected local secret mechanism. Do not commit `.env`, provider keys, Letta tokens, Mem0 keys, database passwords, or raw credential values.

The required configuration groups are:

| Group | Required values |
|---|---|
| OpenProject | Rails secret, database URL/password, admin bootstrap values |
| Agent runtime | Agent service key, `LANGGRAPH_*`, `LANGCHAIN_*`, and correlation configuration |
| Letta | Service URL, API key, and eight canonical identity mappings |
| Mem0 | Base URL, API key, embedding/model configuration, retention policy |
| Memgraph | URI, username/password, graph database name |
| LiteLLM | Proxy URL, model aliases, embedding alias, provider credentials |
| Langflow | Service URL, protected API key, flow references, callback key |
| RAGLite | Service URL, evidence-store configuration, document volume reference |
| Connectors | Disabled-by-default Jira, ServiceNow, Dynatrace, FinOps, and Excel source configuration |

## Startup order

1. Confirm Docker Desktop is running and supports the host architecture. On Apple Silicon, use the declared platform settings in the Compose overlay; do not silently substitute an unrelated image.
2. Validate configuration without printing values: `docker compose --env-file .env config --quiet`.
3. Start databases and persistent stores first: `governance-db`, `agent-postgres`, `memgraph`, `fuseki`, and their named volumes.
4. Start model, memory, and evidence services: `litellm`, `letta`, `mem0`, `raglite`, and `langflow`.
5. Start `agent-runtime` and verify its liveness and degraded/readiness endpoints.
6. Start native OpenProject `backend` and `worker`, run migrations through the fork’s normal Rails process, and verify project authorization.
7. Start `rich-ui` only after the fork-owned API routes are reachable.

## Verification gates

A healthy container is not sufficient. Record the following results with a shared timestamp and correlation ID:

| Gate | Required result |
|---|---|
| Native core | Create a real OpenProject project and user-scoped request |
| Projection | Project/work-package facts receive ontology and provenance fields |
| Graph | Authorized graph query returns only project-scoped persisted records |
| Agent flow | Native AgentRun reaches LangGraph/LangChain with canonical specialist identity |
| Letta | All eight identities exist and state read/write is scoped to the project/user contract |
| Mem0 | Source-backed write/read returns citations and retention metadata; failed writes remain failures |
| Model routing | LiteLLM model and embedding aliases answer authenticated probes |
| Langflow | Draft, validate, simulate, approve, publish, and rollback produce audit evidence |
| HITL | Recommendation approval is required before governed mutation |
| UI | Rich UI can only call fork-owned APIs and displays degraded states accurately |

## Backup and restore

Before migrations or upgrades, record Compose configuration references, database dumps, graph exports, Letta state exports where supported, Mem0 memory exports where supported, Langflow flow definitions, RAG documents, and the fork Git commits. Store file bytes outside the relational database and retain hashes and provenance in native source records.

Restore in reverse dependency order: databases and volumes, graph and memory stores, evidence documents, Langflow definitions, model-routing configuration, agent runtime, native OpenProject migrations, and finally the rich UI. Re-run every verification gate before allowing production-like agent invocation.

## Rollback

Rollback source by selecting a preserved fork commit; do not use destructive history rewrites. Roll back database migrations only through reviewed Rails migration procedures. Disable agent invocation before rolling back runtime or ontology changes. Preserve AgentRun, finding, projection, sync, source-record, and audit evidence during rollback.

## Current status

The runbook and Compose topology are source artifacts. The Manus sandbox currently has no reachable Docker daemon, and the user’s Docker Desktop has not been connected. No claim of full-stack startup, migration, or end-to-end proof is made by this document.
