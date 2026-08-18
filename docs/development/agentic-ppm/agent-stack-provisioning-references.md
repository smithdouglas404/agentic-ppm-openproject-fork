# Agent Stack Provisioning References

## Selected Architecture

The Agentic PPM target uses **LangGraph and LangChain** as the only agent-flow framework. Langflow is the governed visual composition surface; Letta supplies durable state; Mem0 supplies scoped episodic memory; Memgraph supplies relationship evidence; and OpenProject retains authorization, transaction, and audit ownership. Inngest AgentKit is not a second agent framework in this architecture.

## Official Sources and Deployment Facts

| Component | Verified deployment fact | Source |
| --- | --- | --- |
| LangGraph | LangGraph is a stateful, long-running orchestration framework and can be used with LangChain components. It supports durable execution and human-in-the-loop patterns. | [LangGraph repository](https://github.com/langchain-ai/langgraph) |
| Langflow | Langflow 1.11.x provides a visual editor and API for creating, testing, serving, and embedding flows. Its API supports flow management and run endpoints, and authenticated deployments use API keys. | [Langflow overview](https://docs.langflow.org/) and [Langflow API examples](https://docs.langflow.org/api-reference-api-examples) |
| Langflow container | Official Docker image is `langflowai/langflow`. The published production path recommends a persistent PostgreSQL database; Docker images default `LANGFLOW_AUTO_LOGIN=false` and require a strong superuser password when auto-login remains disabled. | [Langflow Docker deployment](https://docs.langflow.org/deployment-docker) |
| Letta | The official Docker server documentation describes `letta/letta`, HTTPS for remote ADE connectivity, a secure password mode, and provider credentials. It notes that the legacy Docker server surface is deprecated in favor of the Letta App Server for new custom applications. | [Letta Docker deployment](https://docs.letta.com/v1-sdk/docker) |
| Mem0 | The current self-hosted server includes REST API, dashboard, API-key authentication, audit logs, a required JWT secret under auth, and requires an LLM-provider credential for runtime memory work. | [Mem0 self-hosted setup](https://docs.mem0.ai/open-source/setup) |

## Provisioning Guardrails

1. Do not expose database, graph, agent-state, or memory ports publicly.
2. Generate passwords, JWT secrets, and application keys only into protected service variables or root-owned host files; do not commit or print secret values.
3. Route all OpenProject access through an application policy boundary. Langflow flows and LangGraph nodes cannot directly bypass OpenProject permissions or transactional rules.
4. Use real source evidence only. No synthetic project, memory, policy, or recommendation data is used to claim agent capability.
5. Pin verified image versions once health checks pass; do not leave production services on an unverified `latest` tag.
