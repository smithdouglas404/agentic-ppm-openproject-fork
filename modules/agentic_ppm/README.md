# OpenProject Agentic PPM Module — Unverified Scaffold

This module is an **unverified OpenProject-native scaffold** for Agentic Portfolio and Transformation Management. It has not yet been booted in a running OpenProject environment, migrated, exercised through a real project, or validated by the OpenProject test suite. It must not be described as an operational module, service integration, agent integration, visual-rule integration, or external-source integration.

Read the architecture records in `docs/development/agentic-ppm/` before extending this module, especially [Source-First Engineering Gate](../../docs/development/agentic-ppm/source-first-engineering-gate.md). No feature expansion is permitted until its runtime and proof requirements are passed.

## Current capability behavior

The project page reports `disabled`, `degraded`, or `configured` capability state from deployment configuration. It does not make network requests or generate placeholder agent insights. This preserves a safe OpenProject-native baseline while the external services are activated independently.

## Ontology projection foundation

The module now persists source-linked projection records for an enabled OpenProject project, its work packages, assigned actors, project containment, assignment, and hierarchy relationships through an idempotent native job. The records are deliberately graph-runtime independent: they retain source identity, entity keys, observed time, payload, and projection state before a Memgraph adapter becomes available. Delivery method is derived later from configured ontology evidence rather than hard-coded project labels.

## Representative integration proof

After the controlled OpenProject evaluation environment is running, execute `bundle exec rake agentic_ppm:seed_representative_project`. The task uses `config/agentic_ppm/representative_project.yml`, creates a real project and native work packages, assigns the controlled user, enables the module, and queues source-to-ontology projection. It is idempotent by project identifier and work-package subject, and it makes no external write beyond the controlled OpenProject evaluation environment.

## Direct PMO and VRO conversations

The native project page includes an audited PMO/VRO conversation form for users with `run_agentic_ppm_agents`. Until Letta is explicitly configured and healthy, requests are persisted with an `unavailable` state and no response is fabricated. The next service-integration slice will submit these authorized runs to Letta, attach Mem0-scoped retrieval and Memgraph evidence, then return an evidence-linked response.

## Jira and ServiceNow adapters

Jira and ServiceNow are native provider adapters, not browser automations. An authorized project connection stores a provider, non-secret configuration, and a managed credential reference. When enabled, Jira projects issue records into the ontology as source-provenance work-package evidence, while ServiceNow projects approved demand, change, incident, service, and risk table records into their ontology types. Neither adapter runs until the connection is enabled and the referenced managed credential is available.

## Governed visual business rules

Business rules are native project records with lifecycle states for draft, submission, approval, publication, rollback, and archive. Langflow flow references are not enough to publish a rule: the native lifecycle requires an approved rule, a visual flow reference, and a validation result explicitly marked valid. This keeps business-user visual updates possible while retaining OpenProject permission, audit, and publication control.
