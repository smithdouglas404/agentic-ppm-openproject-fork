# Mem0 Memory Governance Contract

## Status

The contract is inactive by default. It is the required policy boundary for a future self-hosted or authorized Mem0 service; it does not indicate that memory extraction, storage, or retrieval currently occurs.

## Scope

Every memory is scoped by workspace, project, OpenProject user, specialist agent key, and authorization policy. Retrieval requires all scope dimensions and a current OpenProject permission decision. A project member cannot retrieve memory from another project merely because a specialist agent shares the same base template.

## Extraction and Citation

Only authorized conversation content, source-backed OpenProject evidence summaries, and user-confirmed preferences may be extracted. Connector credentials, session tokens, unscoped cross-project content, and unverified agent inferences are prohibited. Every retained memory must cite its source system, source record identity, observed time, authorization provenance, and policy version.

## Retention and Deletion

Retention is governed by workspace policy. User deletion requests, retention expiry, source revocation, and project-access revocation trigger deletion. The activation implementation must retain deletion evidence and must not return records whose source has been deleted or revoked.

## Storage, Write, and Update Semantics

A memory record must include a memory identifier; workspace, project, user, agent, and authorization scopes; content classification; source citations; observed time; policy version; retention classification; and record version. Writes require a current authorization decision, citations, classification, and a trace event. Updates preserve the prior record version and require a new authorization decision, observed time, and trace. Backend deletion is required, but an audit tombstone—without raw memory content—retains the identifier, deletion trigger, deletion time, authorization decision, and policy version. Tombstoned memories are never retrievable.

## Observability

Memory operations must retain the scoped identity, agent, authorization decision, citations, and retention classification so use can be audited without exposing raw memory content in routine logs.
