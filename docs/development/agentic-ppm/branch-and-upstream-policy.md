# Agentic PPM Branch and Upstream Policy

## Repository Ownership

The **source-of-record** for Agentic PPM work is the private fork at `smithdouglas404/agentic-ppm-openproject-fork` (`origin`). The upstream OpenProject source remains `https://github.com/opf/openproject.git` (`upstream`). No Agentic PPM contributor pushes to upstream.

## Branch Roles

| Branch or remote | Role | Allowed changes |
|---|---|---|
| `upstream/dev` and upstream release branches | Read-only OpenProject reference | Used only to inspect and selectively synchronize upstream changes. |
| Fork default branch | Stable fork integration baseline | Receives reviewed upstream synchronization and deliberately approved Agentic PPM integration changes. |
| `agentic-ppm-runtime-proof` | Evidence-gated implementation and runtime-proof branch | Receives native module, test, runtime-evidence, and deployment-support changes only when their evidence record is updated. |
| Short-lived feature branches | Isolated implementation branches | Must merge to the evidence-gated implementation branch only with matching tests and evidence updates. |

## Native Module Ownership

`modules/agentic_ppm/` is the owned native extension boundary. It may use supported OpenProject engine, permission, worker, model, and frontend extension points, but it must not alter upstream core behavior unless the change is first isolated, tested, and documented in the Agentic PPM architecture records.

The OpenProject project and work-package records remain the delivery-system source of truth. Projection records and future graph or agent services are derivative evidence stores; they must preserve source identity, observed time, idempotency, and authorization provenance.

## Upstream Synchronization

Before integrating any upstream OpenProject update, the maintainer must fetch `upstream`, record the exact upstream commit or release, review migration and module-extension impact, run the isolated Agentic PPM module suite, and execute the Cloud Computer representative-project proof. Conflicts in `modules/agentic_ppm/`, its configuration, or extension points require an explicit decision-log entry.

## Release Discipline

No branch is described as customer-ready merely because it compiles or contains a scaffold. A release requires an exact frontend artifact, protected runtime configuration, a live authenticated OpenProject route, persisted representative evidence, passing isolated regression coverage, and an updated `runtime-evidence.md` row. External agent, graph, memory, Langflow, and connector services remain explicitly inactive until they have their own health, authorization, provenance, and end-to-end proof.
