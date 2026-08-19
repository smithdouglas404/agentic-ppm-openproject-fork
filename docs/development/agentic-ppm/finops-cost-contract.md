# FinOps Agent Cost and Funding Contract

## Purpose

The FinOps Agent evaluates project and portfolio funding, cost, allocation, forecast, and variance evidence within authorized scope. It does not invent financial values, approve spend, change budgets, or present a forecast as actuals.

## Vocabulary

| Entity | Required fields | Relationships | Evidence rule |
|---|---|---|---|
| Funding envelope | `funding_key`, currency, approved amount, period, owner, approval state | Belongs to project/portfolio and funds allocations | Native approved budget record |
| Cost record | `cost_key`, amount, currency, cost type, incurred at, source ID | Linked to work package, vendor, project, or allocation | Source ID, period, currency, and scope required |
| Allocation | `allocation_key`, source, target, amount, currency, period, status | Connects funding to project/work package/capability | Approved or clearly proposed; never silently reallocated |
| Forecast | `forecast_key`, version, horizon, assumptions, amount, currency, created at | Projects expected cost or funding need | Assumptions and version are immutable per forecast |
| Variance | `variance_key`, baseline, actual/forecast, delta, currency, severity | Links cost/funding to owner and decision | Baseline and comparison period must be compatible |
| Financial approval | `approval_key`, decision, actor, amount, scope, effective period | Controls budget/funding changes | Native permission and audit record |

## Agent lifecycle

1. **Scope:** resolve authorized project, portfolio, currency, principal, and specialist memory namespace.
2. **Load:** read accepted cost, funding, budget, allocation, forecast, and work-package evidence.
3. **Normalize:** preserve currency, period, cost type, source, and version; reject missing units or unsupported conversions.
4. **Reconcile:** compare cited actuals, approved funding, and versioned forecasts; classify mismatches and missing data.
5. **Forecast:** produce scenario or forecast recommendations only with explicit assumptions and confidence; model output is not actuals.
6. **Escalate:** route material variance, funding risk, allocation conflict, or approval gap to the accountable owner.
7. **Persist:** record a native AgentRun and recommendation; Mem0 writes require evidence-steward approval and project/user/specialist scope.

## Tool and safety boundary

The FinOps Agent may read authorized budgets, costs, funding envelopes, allocations, forecasts, work packages, risks, and accepted evidence. It may calculate deterministic variances and draft forecast scenarios. It may not alter budgets, approve spend, move allocations, access raw credentials, or submit payments. Governed financial changes require native OpenProject permissions, audit, and approval records.

## Financial controls

Every amount includes currency, period, source, and status. Conversions require an approved rate source and observed date. Forecasts identify assumptions, scenario name, version, horizon, and confidence. A cost with missing currency or source is a data-quality exception, not a normalized number. Actual, committed, forecast, and proposed amounts remain distinct.

## Output contract

A FinOps result contains `status`, `project_id`, `specialist`, `correlation_id`, `funding_posture`, `cost_summary`, `allocation_posture`, `forecast_scenarios`, `variances`, `assumptions`, `missing_data`, `financial_risks`, `recommendations`, `approval_state`, `evidence_references`, `model_provider_trace`, and `memory_retrieval_trace`.
