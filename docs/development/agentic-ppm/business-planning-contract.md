# Business Planning Agent Contract

## Purpose

The Business Planning Agent evaluates strategic assumptions, capacity, scenarios, investment choices, and alignment from authorized project and portfolio evidence. It produces traceable planning options, not approved strategy or financial commitments.

## Vocabulary

| Entity | Required fields | Relationships | Evidence rule |
|---|---|---|---|
| Planning assumption | `assumption_key`, statement, owner, confidence, effective period, status | Drives scenario or capacity model | Source, owner, and review date required |
| Strategic objective | `objective_key`, statement, owner, horizon, status | Aligns projects, outcomes, OKRs, and benefits | Native objective and authorization scope |
| Capacity envelope | `capacity_key`, resource class, available amount, period, owner | Constrains initiatives/work packages | Source-backed capacity and period |
| Scenario | `scenario_key`, name, assumptions, horizon, constraints, version | Contains options and projected outcomes | Versioned assumptions and provenance |
| Planning option | `option_key`, action, trade-offs, cost/capacity impact, confidence | Candidate response to scenario | Recommendation until approved |
| Alignment assessment | `alignment_key`, objective, contribution, confidence, evidence status | Links initiative/project to strategy | Explicit attribution status and source |
| Decision | `decision_key`, option, actor, date, approval state | Selects a planning option | Native approval and audit record |

## Agent lifecycle

1. **Scope:** resolve authorized portfolio/project, planning period, principal, and specialist memory namespace.
2. **Load:** read approved objectives, assumptions, capacity, budgets, dependencies, benefits, OKRs, and accepted evidence.
3. **Validate:** reject expired assumptions, incompatible periods, duplicate versions, unsupported capacity claims, and cross-scope records.
4. **Model:** compare scenarios and deterministic capacity/constraint effects; label model projections and assumptions.
5. **Align:** assess contribution to strategic objectives with explicit attribution status and evidence references.
6. **Recommend:** draft options, trade-offs, missing-data requests, and decision questions for accountable owners.
7. **Persist:** record a native AgentRun and recommendation; Mem0 writes require evidence-steward approval and project/user/specialist scope.

## Tool and safety boundary

The agent may read authorized planning records, objectives, budgets, capacities, dependencies, benefits, OKRs, work packages, and accepted evidence. It may calculate deterministic constraints and draft scenario options. It may not approve strategy, commit funding, change capacity plans, alter objectives, or execute external mutations. Governed decisions enter native OpenProject workflows with permissions, audit, and approval state.

## Scenario rules

Each scenario identifies assumptions, horizon, constraints, version, and owner. A scenario with missing assumptions is marked insufficient evidence. Options expose trade-offs and confidence rather than a single fabricated optimum. Capacity is never silently treated as available when it is missing, expired, or disputed. Alignment remains proposed until an accountable owner approves it.

## Output contract

A Business Planning result contains `status`, `project_id`, `specialist`, `correlation_id`, `planning_posture`, `assumptions`, `capacity_constraints`, `scenarios`, `planning_options`, `alignment_assessments`, `trade_offs`, `missing_data`, `decision_questions`, `approval_state`, `evidence_references`, `model_provider_trace`, and `memory_retrieval_trace`.
