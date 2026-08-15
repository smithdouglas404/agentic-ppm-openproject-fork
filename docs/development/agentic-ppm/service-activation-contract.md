# Service Activation Contract

## Principle

The Agentic PPM module must be developable and testable before optional service runtimes are available. Each service is addressed by an OpenProject-native adapter with an explicit health state: `disabled`, `configured`, `available`, `degraded`, or `unavailable`. The module must provide transparent degraded behavior and must never fabricate an external service response.

## Letta

Letta supports either a local development backend that starts an App Server as a subprocess or a remote App Server that serves shared agents over the Agent SDK. The official documentation notes that self-hosted agent state is not automatically backed up. [1]

For the Agentic PPM evaluation environment, the adapter must support a disabled mode, a local-development mode, and a remote App Server mode. Production deployment will use a remote App Server only after durable storage, backup, authentication, and network policies are approved.

## Inngest AgentKit and durable functions

Inngest functions use event, schedule, or webhook triggers, retriable steps, and flow control. [2] Inngest AgentKit can build agent networks with routers, tools, state, memory, MCP support, and multiple model providers. [3]

The OpenProject-native workflow adapter must remain independent of the chosen durable runtime. It will expose canonical events such as `agentic_ppm.source_sync_requested`, `agentic_ppm.graph_refresh_requested`, `agentic_ppm.memory_extract_requested`, and `agentic_ppm.rule_evaluation_requested`. Native Good Job handling may consume these events before Inngest is introduced; Inngest may later consume the same event contract without changing business semantics.

## Mem0

The Mem0 self-hosted bundle provides a REST API, dashboard, administrator account, per-user API keys, metadata-oriented entities, and request audit logging. Its documented deployment expects Docker and Docker Compose, a configured model provider, a JWT secret, and distinct dashboard and API ports. [4]

The initial adapter will treat Mem0 as an optional remote service. Its metadata envelope must include the OpenProject installation, workspace or project context, user or role scope, specialist agent, source evidence references, retention policy, and data-classification marker. Self-hosted Mem0 authentication must remain enabled outside an isolated development setup.

## Memgraph

Memgraph provides official Docker images, Docker Compose guidance, client libraries, Cypher querying, transaction support, graph modeling, and graph-oriented AI/GraphRAG documentation. [5] The master ontology graph must use stable source keys and `MERGE`-style idempotent projection semantics, retain provenance on every entity and relationship, and avoid treating the graph as a mutable replacement for OpenProject operational data.

## Local activation behavior

| Service | Core mode when absent | Activation trigger | Non-blocking behavior |
| --- | --- | --- | --- |
| Letta | Agent calls return an explicit runtime-unavailable capability state; no fake conversation is generated | Valid endpoint and managed token | Native rules, traces, and agent configuration continue to work |
| Mem0 | Memory extraction is queued or marked unavailable; source evidence remains in OpenProject and Memgraph | Valid endpoint and managed token | Conversation and workflow state remain available without semantic recall |
| Memgraph | Graph projection status is degraded; source records remain in OpenProject | Valid endpoint and graph credential | Project operations remain available; graph-dependent insights disclose degradation |
| Langflow | Visual editing is unavailable; last approved native rule definition remains active | Valid endpoint and managed token | No unpublished visual flow is executed |
| Inngest / AgentKit | Native durable job adapter processes the event contract | Explicit adapter enablement | No duplicate schedules or second workflow history is created |

## References

[1] [Letta self-hosting documentation](https://docs.letta.com/self-hosting)

[2] [Inngest Functions documentation](https://www.inngest.com/docs/learn/inngest-functions)

[3] [Inngest AgentKit documentation](https://agentkit.inngest.com/)

[4] [Mem0 self-hosted setup](https://docs.mem0.ai/open-source/setup)

[5] [Memgraph Docker installation](https://memgraph.com/docs/getting-started/install-memgraph/docker)
