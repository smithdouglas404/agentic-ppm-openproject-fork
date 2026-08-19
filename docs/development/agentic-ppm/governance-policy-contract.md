# Governance Agent Policy-as-Code Contract

## Purpose

The Governance Agent converts approved policy documents and control requirements into versioned, reviewable rules that can be evaluated against authorized OpenProject evidence. It never silently publishes a rule, changes a project control, approves an exception, or treats a model interpretation as policy.

## Policy lifecycle

| State | Meaning | Allowed transition | Required record |
|---|---|---|---|
| Draft | Policy source or rule draft under authoring | Draft → review | Source document, owner, checksum |
| Review | Rule set awaiting control-owner review | Review → approved/rejected | Reviewer, validation trace, comments |
| Approved | Versioned rule set eligible for evaluation | Approved → active/retired | Approval decision, effective period |
| Active | Rule set may evaluate scoped evidence | Active → superseded/retired | Activation actor, policy version |
| Exception requested | Control deviation proposed | Requested → approved/rejected | Owner, reason, expiry, compensating control |
| Exception approved | Time-bounded deviation is authorized | Approved → expired/revoked | Approver, expiry, audit event |

## Rule model

A rule contains `policy_key`, `version`, `rule_key`, `statement`, `condition`, `required_evidence_types`, `scope`, `severity`, `owner`, `effective_period`, `evaluation_mode`, `source_document_id`, `source_checksum`, `validation_trace`, and `approval_state`. Conditions must be deterministic and schema-validated before an LLM interpretation is allowed to add context.

## Evaluation and evidence

The agent evaluates only project-scoped accepted evidence and native control records. Every result is classified as `pass`, `fail`, `not_applicable`, `insufficient_evidence`, or `conflict`. A failed control includes the rule version, source references, observed time, evaluated scope, and remediation recommendation. Missing evidence is never converted into a pass.

## Langflow boundary

Langflow may provide a visual authoring and simulation reference for authorized business owners. The native runtime stores the approved policy version and validation trace; it does not trust an unreviewed flow export. A publish callback must validate schema, tool allowlist, scope, secret stripping, and policy-owner approval before a version can become active. Rollback selects a prior approved version and records the reason.

## Permitted tools and prohibitions

The Governance Agent may read policy documents, control evidence, project records, approved rule versions, and exception records; evaluate deterministic conditions; draft exceptions; and produce remediation recommendations. It may not publish policy, approve an exception, change permissions, access raw connector secrets, or execute an external mutation. Native OpenProject permissions, audit events, and approval records govern all state changes.

## Output contract

A Governance result contains `status`, `project_id`, `specialist`, `correlation_id`, `policy_versions`, `control_results`, `exceptions`, `insufficient_evidence`, `conflicts`, `remediation_recommendations`, `approval_state`, `evidence_references`, `validation_trace`, `model_provider_trace`, and `memory_retrieval_trace`.
