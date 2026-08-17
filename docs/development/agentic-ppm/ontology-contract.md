# Agentic PPM Canonical Ontology Contract

## Purpose

This contract defines the vocabulary used to project portfolio evidence from OpenProject and, only after authorization, from external systems. OpenProject remains the system of record for native project and work-package facts. The ontology is a derivative evidence layer, not a replacement transaction store.

## Canonical Entities

The canonical entity vocabulary includes **project**, **work package**, **milestone**, **person**, **risk**, **decision**, **objective**, **KPI**, **cost**, **service**, and **change**. The native runtime currently projects OpenProject project, work-package, milestone-by-type, and actor/person evidence. The remaining entity types are planned mappings and must not be represented as live graph facts until their owning source is connected, authorized, mapped, and proven.

## Canonical Relationships

The relationship vocabulary includes **contains**, **depends on**, **assigned to**, **governed by**, **contributes to**, **funds**, **impacts**, and **mitigates**. The native runtime currently proves containment, assignment-as-actor, hierarchy, and `follows` dependency evidence from OpenProject. Future mappings normalize native and external source semantics to the canonical relationship names only after an approved mapping profile is applied.

## Fact Envelope

Every future graph fact must carry **confidence**, **observed time**, **source system**, **source record**, **mapping profile**, and **authorization provenance**. Current native projection records persist observed time, OpenProject source identity, mapping configuration, and project-scoped authorization posture. `confidence` is source-asserted until an authorized derived-analysis policy is implemented; no derived confidence is fabricated.

## Change Control

New entity or relationship mappings require an approved ontology configuration update, test coverage, source-system authorization review, migration and rollback plan, and runtime evidence update. This prevents connector-specific terms from becoming uncontrolled graph schema.
