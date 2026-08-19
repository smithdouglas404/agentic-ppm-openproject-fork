# OKR/KPI Agent Contract

## Purpose

The OKR/KPI Agent evaluates objective and indicator posture from authorized, project-scoped evidence. It does not invent targets, alter performance values, or treat a model inference as an observed result. Native OpenProject remains the control plane for objective ownership, approvals, and governed writes.

## Vocabulary

| Entity | Required fields | Relationships | Evidence rule |
|---|---|---|---|
| Objective | `objective_key`, title, owner, period, status, statement | Belongs to project/portfolio; contains key results | Stable native ID and authorized scope |
| Key result | `key_result_key`, objective key, target, unit, current value, confidence, observed at | Measures objective progress | Target/current values require cited sources |
| KPI definition | `kpi_key`, name, unit, calculation rule, owner, version | Produces KPI observations | Calculation rule and version are immutable per observation |
| KPI observation | `observation_key`, KPI key, value, unit, observed at, source ID | Updates indicator trend | Source ID, project ID, and observed timestamp required |
| Attribution | `attribution_key`, source entity, contribution type, weight/status | Links work package, benefit, or outcome to objective/KPI | Attribution is labeled approved, proposed, or disputed |
| Period/version | `period_key`, effective start/end, version | Scopes objective/KPI comparison | Cross-period comparisons require compatible units and definitions |

## Agent lifecycle

1. **Scope:** resolve the authorized project, portfolio, principal, and specialist memory namespace.
2. **Load:** read accepted project evidence, native objective/KPI records, and approved mapping profiles.
3. **Validate:** reject missing units, ambiguous periods, unversioned formulas, duplicate observations, and cross-project references.
4. **Assess:** calculate only deterministic deltas from cited values; label model interpretation as inferred.
5. **Attribute:** propose contribution links with confidence and attribution status; do not convert a proposal into an approval.
6. **Recommend:** emit evidence-cited actions, missing-data requests, or escalation for owner review.
7. **Persist:** create a native AgentRun and recommendation; Mem0 writes require the common evidence-steward approval gate and project/user/specialist scope.

## Permitted tools and boundaries

The agent may read authorized objectives, key results, KPI definitions, observations, work packages, benefits, and accepted evidence envelopes. It may calculate deterministic metrics and draft attribution proposals. It may not directly modify targets, current values, formulas, approvals, budgets, or connector credentials. Governed writes enter through native OpenProject services with permissions, audit, and approval state.

## Attribution rules

An attribution must identify a source entity, target objective/KPI, contribution type, time period, and status. Approved attribution may be used in a realization analysis. Proposed attribution remains a recommendation. Disputed attribution is surfaced as a source conflict and is excluded from deterministic rollups until resolved. Weights must be explicitly sourced or labeled as an analyst/model proposal; the agent must never silently normalize missing weights.

## Output contract

An OKR/KPI result contains `status`, `project_id`, `specialist`, `correlation_id`, `objective_posture`, `key_result_deltas`, `kpi_observations`, `attribution_proposals`, `source_conflicts`, `missing_data`, `recommendations`, `evidence_references`, `approval_state`, `model_provider_trace`, and `memory_retrieval_trace`. Every numeric claim includes unit, period/version, observed timestamp, and source reference.
