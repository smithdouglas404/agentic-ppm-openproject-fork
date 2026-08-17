# Memgraph Projection Contract

## Activation Boundary

Memgraph remains **inactive by default**. The native adapter may be enabled only when `MEMGRAPH_AGENTIC_ENABLED` is explicitly set, an authorized endpoint and protected credential are available, its bounded health query succeeds, and the caller has the required OpenProject project scope.

## Managed Graph Surface

Agentic PPM manages only the `AgenticProject`, `WorkPackageEntity`, `ActorEntity`, and `OntologyRelationship` labels. Every managed node has an immutable `entity_key` identity derived from its source system. The contract requires uniqueness constraints for the primary managed node labels and indexes for project, source-system, and observed-time filtering.

## Projection and Provenance

Writes are idempotent upserts in batches of at most 100 records. Every graph fact must preserve entity identity, project scope, source system and source record, mapping profile, authorization provenance, observed time, confidence, and a correlation identifier. The graph remains an evidence projection; it never becomes the transactional system of record.

## Authorization and Query Classes

Browsers cannot access Memgraph directly. The server authorizes read requests with `view_agentic_ppm` and write requests with `manage_agentic_ppm_integrations`, then limits them to evidence lookup, bounded relationship traversal, or aggregate trend analysis. Free-form write Cypher is not part of this contract.

## Health and Rollback

The activation health query is `RETURN 1 AS agentic_ppm_health` with a five-second limit. Failure disables the adapter and records only a non-secret error. Rollback is a projection-run-scoped compensating delete with correlation ID, run ID, authorizer, and reason. It must never delete OpenProject or external source records.
