# OpenProject Agentic PPM Module

This module is the OpenProject-native foundation for Agentic Portfolio and Transformation Management. Its first slice exposes a project-level capability page and a configuration-driven service registry. It intentionally does not require external agent, memory, graph, visual workflow, or event-processing services to boot.

Read the architecture records in `docs/development/agentic-ppm/` before extending this module.

## Current capability behavior

The project page reports `disabled`, `degraded`, or `configured` capability state from deployment configuration. It does not make network requests or generate placeholder agent insights. This preserves a safe OpenProject-native baseline while the external services are activated independently.

## Ontology projection foundation

The module now persists source-linked projection records for an enabled OpenProject project, its work packages, assigned actors, project containment, assignment, and hierarchy relationships through an idempotent native job. The records are deliberately graph-runtime independent: they retain source identity, entity keys, observed time, payload, and projection state before a Memgraph adapter becomes available. Delivery method is derived later from configured ontology evidence rather than hard-coded project labels.

## Representative integration proof

After the controlled OpenProject evaluation environment is running, execute `bundle exec rake agentic_ppm:seed_representative_project`. The task uses `config/agentic_ppm/representative_project.yml`, creates a real project and native work packages, assigns the controlled user, enables the module, and queues source-to-ontology projection. It is idempotent by project identifier and work-package subject, and it makes no external write beyond the controlled OpenProject evaluation environment.
