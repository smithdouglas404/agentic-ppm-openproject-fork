# OpenProject-Native Agentic PPM Module Design

## Engine boundary

The initial engine is `openproject-agentic_ppm`, located at `modules/agentic_ppm`. It depends only on core OpenProject plugin conventions and does not add a hard boot dependency on Letta, Mem0, Memgraph, Langflow, Inngest, AgentKit, Jira, ServiceNow, Dynatrace, or FinOps providers.

The engine registers the `:agentic_ppm` project module with a dependency on `:work_package_tracking`. It uses a project-menu entry for the project-level intelligence workspace and an administrator-only global configuration entry. The first route is server-rendered and permission-protected; it reports actual module and service-capability state, rather than presenting fabricated insights.

## Functional modules

| Module area | OpenProject-native responsibility | External service interaction |
| --- | --- | --- |
| Agentic PPM Core | Feature enablement, workspace/project context, service registry, capability state, permissions, audit identifiers | None required to boot |
| Ontology and Projection | Source identity, mapping profile, graph projection state, provenance, confidence, idempotency keys | Projects entities and relationships to Memgraph when available |
| Portfolio Intelligence | Portfolio health inputs, evidence aggregation, recommendation records, user-facing evidence links | Reads approved graph and memory evidence through adapters |
| Specialist Agents | Agent configuration, policy, allowed tools, invocation record, trace pointer, human escalation | Invokes Letta; reads/writes scoped Mem0 only through policy-aware adapter |
| Visual Rules | Rule definitions, version, draft, simulation result, approval, publish, rollback, audit | Executes an approved Langflow flow only through a native policy gateway |
| Integrations | Connection metadata, credential reference, mapping profile, sync run, source provenance, exception handling | Calls OpenProject/Jira/ServiceNow/Dynatrace/FinOps adapters server-side |
| Observability | Correlation identifiers, service capability state, agent trace references, job/run status, alert evidence | Reads external trace metadata without exposing credentials or hidden chain-of-thought |

## Data ownership

| Data | Owner | Notes |
| --- | --- | --- |
| Project, work package, milestone, relation, membership, workflow state | OpenProject | Agentic PPM reads these records under the requesting user’s permission scope. |
| Ontology entity and relationship meaning, provenance, confidence, graph traversal | Memgraph | Every graph fact retains OpenProject or external source identity and observed time. |
| Agent durable state | Letta | Agent state is external but references OpenProject project and user policy context. |
| Extracted memory | Mem0 | Memory remains scoped and evidence-linked; it cannot become an authorization bypass. |
| Visual flow composition | Langflow | The approved flow definition is mirrored in OpenProject rule records for lifecycle and audit. |
| Rules, approvals, jobs, audit records, integration metadata | OpenProject Agentic PPM module | These are native operational records and must be migration-backed. |

## Permission model

| Permission | Scope | Enables |
| --- | --- | --- |
| `view_agentic_ppm` | Project | View project intelligence, ontology projection state, evidence, and allowed agent outputs. |
| `run_agentic_ppm_agents` | Project | Invoke the PMO/VRO and other allowed specialists in the current project context. |
| `manage_agentic_ppm` | Project | Configure project-level enablement, agent policy assignments, and mapping profiles. |
| `manage_agentic_ppm_rules` | Project | Create, simulate, submit, approve, publish, or roll back visual business-rule definitions as permitted by lifecycle role. |
| `manage_agentic_ppm_integrations` | Project | Configure connector metadata and run read-only synchronizations; credentials remain server-managed. |
| `administer_agentic_ppm` | Global | Configure service adapters, provider allow-lists, global retention policy, and platform-wide visual flow boundaries. |

Permissions must be checked both at the controller/API boundary and in service objects; menu visibility alone is insufficient.

## Canonical event contract

The module uses the following semantic event names irrespective of whether ActiveJob/Good Job or Inngest processes them:

| Event | Producer | Initial consumer |
| --- | --- | --- |
| `agentic_ppm.project_projection_requested` | Project change or explicit authorized sync | Native projection job |
| `agentic_ppm.integration_sync_requested` | Authorized connector action or scheduler trigger | Native integration sync job |
| `agentic_ppm.memory_extract_requested` | Completed agent interaction | Native memory lifecycle job |
| `agentic_ppm.rule_evaluation_requested` | Project event or approved manual run | Native rule evaluation job |
| `agentic_ppm.agent_invocation_requested` | Authorized user interaction | Native agent invocation job/service |

Every event must include an idempotency key, project identifier, actor or system identity, policy version, correlation identifier, and source-evidence references.

## First native implementation slice

1. Register the module gem and Rails engine.
2. Register the `:agentic_ppm` project module and the first viewer/manager permissions.
3. Add a project menu item and protected controller route.
4. Render a native capability-state page with project context, module status, service status, and a safe next-action explanation.
5. Add a module-local `ServiceRegistry` that resolves configuration to `NullAdapter` behavior unless a service is explicitly enabled and healthy.
6. Add RSpec coverage for engine registration, permissions, disabled-project behavior, controller authorization, and null-adapter behavior.

No data migration or external call is required in this first slice. The next slice introduces persisted projection metadata and a native job, followed by a real OpenProject project and graph synchronization proof.

## Rejected initial approaches

| Approach | Reason rejected |
| --- | --- |
| Separate React/Tailwind companion application | Does not satisfy the requirement to extend OpenProject as the application. |
| Direct provider SDK use in controllers | Makes permission, observability, retries, and failure handling inconsistent. |
| Business rules directly editable as arbitrary graph or Ruby code | Violates governed visual-workflow, audit, and safety requirements. |
| Always-on cron as the only orchestration model | Does not provide the required event semantics, idempotency, and durable workflow behavior. |
| Treating Memgraph as an operational replacement for OpenProject | Breaks authoritative project workflow and upgrade boundaries. |
