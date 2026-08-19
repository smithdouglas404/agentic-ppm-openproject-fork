# Agentic PPM Mac Studio Docker Desktop Transfer Manifest

## Target boundary

This package is built and validated in Manus first, then transferred to the user’s Mac Studio Docker Desktop. The native OpenProject fork remains the product authority. Railway, the Cloud Computer, and the historical overlay runtime are not target dependencies. Neo4j is excluded; **Memgraph is the sole Agentic PPM graph service**.

## Source of truth

| Component | Repository | Reference |
|---|---|---|
| Native OpenProject fork | `smithdouglas404/agentic-ppm-openproject-fork` | Branch `agentic-ppm-runtime-proof`, commit `35f89dcf029c914b8fc55b05cd588e76e9129208` |
| Agent runtime: eight routes, receiver, status | `smithdouglas404/governance-agent-server` | Branch `master`, blob `agent_server.py` `396b7738dcff93a51a8ec0682a61757f7457a62f` |
| Agent runtime: LangGraph, LangChain, memory gate | `smithdouglas404/governance-agent-server` | Branch `master`, blob `governance_langgraph.py` `0386290c03483dc023dbd05c8265aa5baacf6da0` |
| Compose overlay | Native fork | `docker-compose.macstudio.yml` |
| Secret template | Native fork | `.env.macstudio.example` |
| Operational runbook | Native fork | `docs/development/agentic-ppm/macstudio-docker-desktop-runbook.md` |

The agent runtime’s local-only cleanup removes historical Railway service defaults. Letta, Mem0, RAG, document storage, and Memgraph are discovered only through environment variables and the local Docker network.

## Agent execution contract

The runtime exposes exactly eight native specialist routes through one shared LangGraph dispatcher: PMO, VRO, OKR/KPI, OCM, Governance, FinOps, TMO, and Business Planning. LangChain `ChatOpenAI` is the preferred model invocation path and uses the local LiteLLM, Forge, or OpenAI-compatible configuration; the existing fallback path remains available and can be explicitly disabled or selected through configuration.

Letta resolution recognizes the exact native identities `agentic_ppm/PMO`, `agentic_ppm/VRO`, `agentic_ppm/OKR_KPI`, `agentic_ppm/OCM`, `agentic_ppm/GOVERNANCE`, `agentic_ppm/FINOPS`, `agentic_ppm/TMO`, and `agentic_ppm/BUSINESS_PLANNING`, together with legacy aliases. Mem0 retrieval and writes are scoped by workspace, project, authorized principal, and specialist. Mem0 writes are allowed only when a finding matches an accepted OpenProject source/entity envelope through the evidence-steward gate.

The protected `/api/openproject/evidence` receiver requires `X-Agent-Key`, validates project-scoped projected records, persists accepted envelopes idempotently, and carries source, entity, observed-time, and idempotency provenance into LangGraph synthesis. Runtime status distinguishes installed, enabled, configured, and live-probed states; configuration status is never presented as live health.

## Runtime services

| Boundary | Service | Responsibility |
|---|---|---|
| Product authority | OpenProject backend and worker | Native projects, work packages, permissions, AgentRuns, evidence handoff, and durable job processing |
| Orchestration | `agent-runtime` | LangChain/LangGraph specialist execution and protected service calls |
| State | `letta` | Specialist identity, core memory, cards, and agent state |
| Long-term memory | `mem0` | Scoped episodic memory and retrieval backed by local PostgreSQL/pgvector |
| Knowledge graph | `memgraph` | Ontology projections, source-cited relationships, and graph traversal |
| Model routing | `litellm` | Local provider routing; provider credentials remain in the uncommitted secret file |
| Visual governance | `langflow` | Local business-rule workflow authoring and simulation boundary |
| Evidence retrieval | `raglite` | Local source/document retrieval through the model router |

## Required local variables

Create `.env.macstudio` from `.env.macstudio.example` on the Mac Studio. Generate local random values for all required passwords and service keys. Supply a valid model-provider credential separately when real inference or embedding operations are enabled. Do not commit `.env.macstudio`, print it, or place provider keys in frontend code.

The Compose overlay accepts explicit `LETTA_TOKEN` and `MEM0_API_KEY` names. The managed aliases `LETTA_AGENTIC_AUTH_TOKEN` and `MEM0_AGENTIC_AUTH_TOKEN` are also accepted as fallbacks for portability, but the Mac Studio template should prefer the explicit local names.

## Safe startup

From the native fork root, first validate the merged configuration without starting services:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.macstudio.yml \
  --env-file .env.macstudio \
  config --quiet
```

Start the local stack only after the validation passes:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.macstudio.yml \
  --env-file .env.macstudio \
  up -d --build
```

Never use `docker compose down -v` as a troubleshooting shortcut. Named volumes contain OpenProject, PostgreSQL, Memgraph, Letta, Mem0, Langflow, and evidence state.

## Verification gate

A container being up is not sufficient. The transfer is complete only after the following real checks pass: native OpenProject authentication; creation of one real project and work package; native AgentRun creation and worker processing; protected evidence handoff to LangGraph; Memgraph source-cited projection and authorization boundary; Mem0 authenticated write and scoped search; Letta authenticated agent resolution and core-memory read/write; a LangChain model probe through the local model router; and a terminal AgentRun response with correlation ID, evidence references, and explicit approval state.

## Current status

This manifest and the source commits are prepared in Manus. The physical Mac Studio Docker Desktop has not been connected in this task, so no claim is made that its containers are running. The next action after transfer is local Compose validation, followed by bounded service health and real project-scoped memory/graph/model proofs.
