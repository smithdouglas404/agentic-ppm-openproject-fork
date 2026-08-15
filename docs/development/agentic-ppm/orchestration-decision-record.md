# Orchestration and Visual Business-Rule Decision Record

## Context

Agentic PPM requires durable synchronization, memory extraction, graph update, anomaly evaluation, multi-step agent operations, and end-user-adjustable business flows. Traditional cron is insufficient as the sole control plane because it lacks event semantics, durable checkpoints, governed changes, and workflow-level observability.

## Langflow decision

Langflow will be evaluated as the **visual flow-composition surface** for approved business users. Its official documentation describes visual flows composed from configurable component nodes, real-time playground testing, API execution, custom components, and agent/MCP support. [1]

Langflow must not become the source of truth for project permissions, core OpenProject transactions, database migrations, source credentials, or unrestricted external writes. The OpenProject-native Agentic PPM module will wrap Langflow with a rule lifecycle that includes role-based access, draft state, validation, simulation, approval, publication, rollback, and audit history.

| Category | Business user may configure visually | Native OpenProject module must control |
| --- | --- | --- |
| Agent routing | Specialist selection, safe handoffs, escalation conditions | Permission checks, allowed agent set, tenancy, trace IDs |
| Evidence and retrieval | Approved graph queries, retrieval order, response templates | Data classification, source entitlement, provenance requirements |
| Alerts | Thresholds, notification conditions, review/approval paths | Alert persistence, delivery authorization, rate limits, external-write policy |
| Integration behavior | Read-only source selection, mapping invocation, exception routing | Credentials, source allow-list, transport security, idempotency, data validation |
| Workflow controls | Approval branches, wait states, human review steps | Transactional workflow state, OpenProject permissions, final commit actions |

## Inngest decision

Inngest is a candidate durable event-workflow runtime, not an automatic dependency. Its official documentation describes functions triggered by events, cron schedules, and webhooks, with retriable step checkpoints, flow control, and observability. [2]

The fork already includes a native background-job direction through Rails and Good Job. The engineering decision must compare an OpenProject-native job implementation against Inngest using the following criteria before a second scheduler is introduced:

1. Do workflows require durable waits, resumable human approvals, or multi-service branching beyond native job capabilities?
2. Can the required event contracts and observability be implemented upgrade-safely inside the OpenProject module boundary?
3. Does Inngest satisfy the deployment, tenancy, self-hosting, security, and data-residency requirements of the target environment?
4. Can one authoritative workflow history be retained, avoiding duplicate scheduling between cron, Good Job, and Inngest?

Until that decision is made, no traditional cron job may run a business-critical agent or synchronization workflow. Any scheduled trigger must call an idempotent, source-traceable workflow entry point.

## Inngest AgentKit assessment

The AgentKit referenced for this architecture is **Inngest AgentKit**. Its documentation describes primitives for agents, multi-agent networks, routers, tools, state, memory, MCP tools, streaming, multi-tenancy, retries, and model providers including Anthropic. [3] It is a viable composition library when the application needs a deterministic network of collaborating agents with durable event execution.

AgentKit does **not** replace Letta as the persistent specialist-agent runtime in the initial architecture. A PMO or VRO agent must not be simultaneously modeled as independent durable state in Letta and AgentKit without an explicit ownership decision. The initial implementation uses Letta identities; AgentKit is introduced only through a documented adapter when a multi-agent network, human-in-the-loop wait, or event-resumable workflow has a proven need.

The current baseline remains: **Letta for persistent specialists; Mem0 for scoped memory; Memgraph for semantic graph intelligence; OpenProject-native services for authorization and workflow policy; Langflow for governed visual composition; and Inngest only if a durable event-workflow evaluation supports it.**

## References

[1] [Langflow documentation](https://docs.langflow.org/)

[2] [Inngest Functions documentation](https://www.inngest.com/docs/learn/inngest-functions)

[3] [Inngest AgentKit documentation](https://agentkit.inngest.com/)
