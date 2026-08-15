# Source-First Engineering Gate

## Purpose

This gate corrects the development sequence for Agentic PPM. The OpenProject fork must be treated as a serious product codebase, not as a destination for speculative scaffolding. No implementation artifact may be described as an **integration**, **agent**, **module**, **workflow**, or **operational capability** until it satisfies the applicable proof criteria below.

## Freeze rule

Until Gate 3 is passed, no new specialist agent, Letta/Mem0/Memgraph/Langflow/Inngest integration, Jira/ServiceNow/Dynatrace/FinOps source connection, Governance/OCM/OKR/KPI module, visual business-rule feature, or portfolio UI expansion may be added.

Existing source files are treated as **unverified architecture scaffolding**. They are inputs to the verification process, not evidence of an implemented capability.

## Required gates

| Gate | Required evidence | Permits | Does not permit |
| --- | --- | --- | --- |
| 0 — Fork integrity | OpenProject fork remotes, branch policy, source inventory, and no accidental parallel application | Source analysis and environment setup | Feature claims or runtime assumptions |
| 1 — Runtime baseline | OpenProject starts from this fork; database migration status, authentication, project creation, and a targeted test command are demonstrated | Native module boot diagnosis and minimal corrective work | External service work or new feature modules |
| 2 — Extension baseline | A minimal native module is proven to load, register permissions/menu/routes, and pass targeted tests in the running fork | One vertical slice only | Multiple business domains or agent systems |
| 3 — Source-to-ontology proof | A real OpenProject project, people, work packages, and relationships are created in the controlled runtime; the projection record and source provenance are inspected | A graph-ready evidence slice and its UI | Declaring Memgraph, agents, memory, or visual workflows integrated |
| 4 — Service proof | One named external runtime or source is enabled with managed credentials, a health check, a controlled action, audit evidence, error handling, and tests | The demonstrated service capability only | Claims about any other unproven runtime or provider |
| 5 — User workflow proof | An authorized user performs a complete native OpenProject workflow, sees evidence, and permission/negative-path tests pass | Completion claim for that one vertical slice | Broad product-completion claims |

## Definition of done

| Term | Minimum proof required |
| --- | --- |
| Scaffold | Source files exist and pass static validation only. |
| Native module | The fork boots it, loads its migration, registers its permission and route, and passes targeted tests. |
| Integration | A live configured runtime/source completes a controlled request through the native module, with managed credentials, an audit record, error handling, and tests. |
| Agent | A named Letta identity executes an authorized tool flow, applies scoped memory policy, cites source/graph evidence, records a trace, and passes success and denial paths. |
| Visual rule | An authorized user creates a draft, validates/simulates it, approves/publishes it, sees it execute through native policy checks, and can roll it back. |
| Business module | A native OpenProject workflow has a real persisted data model, permissions, interface, tests, and user-visible evidence. |

## Mandatory engineering sequence

1. Read relevant OpenProject source and tests.
2. Run the baseline and record actual output.
3. Implement the smallest native change that is necessary for the next gate.
4. Run targeted and relevant regression tests.
5. Demonstrate the behavior in the running application.
6. Record evidence, known limits, and the next gate decision.

If an environment, credential, service, or test suite is unavailable, record the exact blocking fact and continue only with analysis or code that is necessary to remove that blocker. Do not compensate by creating adjacent feature scaffolding.

## Current status

The fork is at **Gate 0**. The existing `modules/agentic_ppm` code is unverified scaffolding. The immediate next task is to establish a real OpenProject development runtime and execute the baseline; it is not further Agentic PPM feature work.
