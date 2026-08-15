# OpenProject Architecture Analysis for Agentic PPM

## Analysis scope

This analysis is based on the checked-out OpenProject fork rather than API documentation alone. The objective is to identify upgrade-aware, native extension points before Agentic PPM code changes core workflows.

## Observed architecture

| Domain | Observed implementation | Agentic PPM implication |
| --- | --- | --- |
| Module system | Modules live under `modules/`; module dependencies are declared in `Gemfile.modules`; Rails engines use `OpenProject::Plugins::ActsAsOpEngine`. | Create a separately namespaced `modules/agentic_ppm` engine, not a new standalone application. |
| Project capability | Module engines register `project_module` and gate project menu visibility through `project.module_enabled?`. | Make Agentic PPM a project module with explicit enablement, while retaining global administration settings separately. |
| Authorization | Engine declarations register permissions and map controller actions through `OpenProject::AccessControl`. | Every Agentic PPM endpoint, visual rule change, agent invocation, and integration action must have an explicit permission. |
| Native navigation | Module engines register `top_menu`, `global_menu`, `project_menu`, and administration entries. | Add a project-level **Portfolio intelligence** entry and an administrator-only **Agentic PPM** configuration entry through the engine. |
| Background processing | `ApplicationJob` is an `ActiveJob` base with Good Job status, shared setup, and priority support. | Start with native ActiveJob/Good Job consumers for the canonical Agentic PPM event contract; introduce Inngest only through an adapter. |
| Scheduled activity | Module engines may register cron cleanup through `add_cron_jobs`. | Do not place core agent logic directly in cron; cron may only trigger idempotent event workflow entry points where necessary. |
| Integrations | The webhooks module is a Rails engine with administration navigation, post-initialization subscription, and a cleanup job. Other modules use focused synchronization services. | Model source adapters as module-local services with explicit credentials, audit records, retries, and native jobs. |
| Frontend | The application uses Rails-driven menu registration, server-rendered views/ViewComponents, and a substantial `frontend/` TypeScript area. | The first PPM slice should use native Rails route, layout, menu, and permission patterns; introduce richer frontend components only after verifying the appropriate framework boundary. |
| Test conventions | Modules own local `spec/` trees and use repository-wide RSpec helpers, factories, request/service/component, and feature coverage. | The first module must include engine, permission, service, route, and disabled-project tests before external service integration. |

## Evidence paths

| Concern | Paths inspected |
| --- | --- |
| Module registration and menus | `modules/reporting/lib/open_project/reporting/engine.rb` |
| Webhook integration pattern | `modules/webhooks/lib/open_project/webhooks/engine.rb` |
| Native background jobs | `app/workers/application_job.rb`, `app/workers/cron/quarter_hour_schedule_job.rb`, `app/workers/import/jira_fetch_and_import_projects_job.rb` |
| API and services | `lib/api/v3/`, `app/services/api/v3/`, `app/services/`, `modules/*/app/services/` |
| Navigation | `app/menus/`, `app/controllers/*/menus_controller.rb`, `frontend/src/app/shared/components/resizer/resizer/main-menu-resizer.component.ts` |
| Module test structure | `modules/*/spec/spec_helper.rb`, `modules/*/spec/services/`, `modules/*/spec/features/` |
| Local environment | `AGENTS.md`, `docker/dev/AGENTS.md`, `docker-compose.yml`, `docker-compose.override.example.yml`, `bin/compose` |

## First implementation slice

The first native implementation will be a minimal `openproject-agentic-ppm` engine under `modules/agentic_ppm`. It will register a project module, project-level viewer and manager permissions, a native project-menu entry, a protected controller route, a capability-state page, and a module-local service registry. It will not require Letta, Mem0, Memgraph, Langflow, Inngest, or AgentKit to boot.

The page will expose the **actual** service-capability state and project context; it will not imitate a separate product shell. The next slice then adds persisted ontology projection metadata and an idempotent native job before graph or agent calls are enabled.

## Upgrade and risk controls

1. Keep new code inside `modules/agentic_ppm` unless a documented upstream extension point does not exist.
2. Use engine registrations, permission declarations, and menu APIs instead of core monkey patches whenever possible.
3. Keep provider-specific clients behind service adapters configured from `config/agentic_ppm/services.yml`.
4. Use native jobs and canonical events to avoid duplicate Good Job, Inngest, and cron execution histories.
5. Add module-local RSpec coverage before changing project workflows, work-package semantics, or source integration behavior.
6. Preserve source provenance and authorization checks when projecting OpenProject data to the semantic graph.

## Next implementation reads

Before code scaffolding, inspect the engine entrypoint and loader conventions of a focused module, the engine specs that assert menus and permissions, the route definition pattern, and the project module/permission factories. The exact files should be selected from the current fork during the module scaffold task, rather than assuming copied upstream filenames remain stable.
