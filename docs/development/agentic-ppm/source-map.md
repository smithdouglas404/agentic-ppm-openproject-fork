# Agentic PPM Source Map and Extension Decision Record

## Purpose

This record identifies the OpenProject source areas that must be understood before the Agentic PPM implementation changes workflows, data, authorization, navigation, or user experience. It is an analysis checklist, not a license to change source files without first documenting the extension decision.

| Concern | OpenProject source areas to analyze | Agentic PPM decision required |
| --- | --- | --- |
| Backend domain and workflow | `app/`, `lib/`, `config/routes.rb`, `db/`, `spec/` | Determine the module/engine/service placement for portfolio records, integration contracts, ontology bridges, and workflow hooks. |
| Native modules | `modules/`, `Gemfile.modules`, module loading configuration | Identify the supported pattern for a Community-compatible Agentic PPM module and isolate changes from upstream core. |
| Work packages and relations | Work-package models, contracts, services, API endpoints, and relation handling | Map hybrid delivery patterns, dependencies, risks, milestones, and outcome evidence without changing existing semantics. |
| Permissions and roles | Authorization policies, permission registries, project membership, global roles, API scopes | Define the administrator, portfolio, PMO, VRO, data steward, and reviewer boundaries for each PPM action. |
| Frontend and navigation | `frontend/`, view components, menus, feature flags, front-end test tooling | Add native navigation and views for agent operations, graph analysis, integrations, and portfolio modules without a competing product shell. |
| API and integrations | APIv3 endpoints, internal services, background job patterns, webhook and integration configuration | Define read-only source adapters, retries, mapping validation, provenance, scheduling, and audit behavior. |
| Background processing | Good Job configuration, job classes, queue policy, operational controls | Define durable graph synchronization, memory lifecycle, alert evaluation, and agent-event processing. |
| Testing | RSpec, frontend test suites, fixture factories, system tests | Establish a test matrix for authorization, workflow behavior, source mapping, graph provenance, memory policy, and upgrade compatibility. |
| Deployment | `docker/`, Compose files, environment configuration, PostgreSQL, Redis, workers | Run OpenProject, Memgraph, Letta, and Mem0 through explicit services with secrets and data volumes managed outside source code. |

## Mandatory extension decision template

Every material Agentic PPM change must document the following before implementation:

1. The source-of-truth owner and lifecycle of the data.
2. The OpenProject extension point and why it is preferred over a core modification.
3. The ontology entity types, predicates, provenance, and deduplication strategy.
4. The roles, permissions, user experience, and workflow effects.
5. The external service contract, authentication boundary, failure mode, and observability signals.
6. The backend, frontend, system, and migration tests required.
7. The expected impact on upstream upgradeability.

## Completed initial analysis

The source-grounded initial analysis is recorded in [OpenProject Architecture Analysis for Agentic PPM](openproject-architecture-analysis.md). It establishes the first implementation slice as a separately namespaced Rails engine under `modules/agentic_ppm`, using existing project-module, permission, menu, ActiveJob, and module-local RSpec conventions.
