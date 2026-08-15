# Agent Runtime and Model Provider Contract

## Decision

The eight Agentic PPM specialists will be created as **persistent Letta agents**. OpenProject-native services remain responsible for authorization, workflow state, source-system permissions, data policy, tool registration, and audit records. Letta is not a replacement for OpenProject; it is the stateful specialist-agent runtime called by the Agentic PPM module.

| Agent | Letta identity | Primary OpenProject-native tools | Principal graph focus |
| --- | --- | --- | --- |
| PMO | `pmo` | Portfolio health, delivery confidence, work-package and milestone analysis | Projects, work packages, milestones, dependencies, risks |
| VRO | `vro` | Benefits realization, outcome evidence, value-risk correlation | Outcomes, OKRs, KPIs, benefits, risks |
| OKR/KPI | `okr_kpi` | Objective and measure analysis | Objectives, key results, measures, delivery contribution |
| OCM | `ocm` | Readiness, stakeholder, adoption, and change-impact analysis | People, change impacts, readiness evidence |
| Governance | `governance` | Decision, control, policy, and assurance analysis | Decisions, obligations, controls, evidence |
| FinOps | `finops` | Cost, forecast, allocation, and optimization analysis | Cost, investment, service, forecast variance |
| TMO | `tmo` | Transformation sequencing and dependency analysis | Programs, tranches, milestones, dependencies |
| Business Planning | `business_planning` | Demand, capacity, scenario, and trade-off analysis | Demand, capacity, investment, strategic plan |

## Runtime boundaries

1. **Letta** stores the durable agent state and runs each specialist’s governed reasoning loop.
2. **Mem0** stores extracted, scoped memories and returns retrieval candidates. It must not become an untraceable shadow database; each memory must include workspace, agent, user or role scope, retention policy, and source-evidence references.
3. **Memgraph** stores the master ontology, relationships, provenance, confidence, and graph analytics. Agent tools retrieve evidence from Memgraph and link it to OpenProject source identifiers.
4. **OpenProject** owns authoritative operational records and decides whether a requesting user is authorized to see, create, update, or act on those records.
5. **The Agentic PPM module** provides policy enforcement, tool schemas, correlation checks, agent traces, workflow handoffs, and the user interface.

## Model provider contract

The reasoning model is an OpenProject-native, configuration-driven provider contract. Claude may be selected as the initial provider because it supports tool use and capable reasoning, but no agent code, prompt, memory record, workflow, or database migration may assume a Claude-specific identifier or request format.

| Contract responsibility | Requirement |
| --- | --- |
| Provider selection | Workspace or installation configuration, constrained by approved providers and model policies |
| Invocation | A provider adapter receives normalized messages, tool definitions, safety policy, trace identifiers, and token limits |
| Tool calls | Validated by OpenProject-native policy before reaching Letta, Memgraph, integrations, or OpenProject write workflows |
| Evidence | Every response must retain graph and OpenProject evidence references separately from recommendation text |
| Failure handling | Return a transparent degraded response, log the trace, and never fabricate source evidence |
| Observability | Record agent, provider, model, tool calls, memory retrieval, graph query fingerprint, policy decision, and outcome |

## LangGraph decision rule

LangGraph is **not** a required runtime in the first implementation. Native OpenProject services/jobs plus Letta handle the initial specialist interactions, approvals, and durable state. Introduce LangGraph only after a documented requirement demonstrates that a graph-orchestrated, resumable multi-agent flow cannot be expressed safely through those native workflow and background-job capabilities.

## References

[1] [Agentic PPM Architecture Charter](architecture-charter.md)

[2] [OpenProject upstream repository](https://github.com/opf/openproject)
