# Langflow Visual Governance Contract

## Status

This policy is inactive until an authorized Langflow service and protected credentials are available. The current native OpenProject business-rule lifecycle remains the enforcement point; the policy does not authorize a visual flow to execute or modify OpenProject data directly.

## Embedding and Scope

Langflow may be embedded only in project-scoped business-rule administration. A rule refers to an immutable, versioned external flow identifier. Embedded secret values are prohibited, and the visual flow cannot execute native OpenProject transactions without a separately governed native action.

## Lifecycle and Roles

Native `manage_agentic_ppm_rules` permission is required for all draft, submission, approval, publication, and rollback transitions. Publication requires an approved native rule plus a valid external result that names the exact flow reference and version, validator, policy version, and validation time. Simulation uses authorized sanitized or synthetic data and retains a trace before publication.

## Audit and Rollback

OpenProject retains the project, rule, actor, transition, flow reference/version, validation reference, authorization decision, and observed time. Rollback passes through the native lifecycle service and preserves prior publication evidence. A visual flow never bypasses native permission checks or becomes the system of record for rule state.
