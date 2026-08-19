# TMO Agent Transformation Contract

## Purpose

The TMO Agent evaluates transformation sequencing, dependencies, milestones, outcomes, and delivery posture from authorized project evidence. It does not reorder a portfolio, change a milestone, approve a dependency, or represent an outcome as realized without native control-plane approval.

## Vocabulary

| Entity | Required fields | Relationships | Evidence rule |
|---|---|---|---|
| Transformation stream | `stream_key`, objective, owner, horizon, status | Contains initiatives, milestones, outcomes, and dependencies | Native project/module scope |
| Initiative | `initiative_key`, statement, owner, phase, status, target outcome | Belongs to a stream; links work packages and benefits | Stable source ID and approved mapping |
| Dependency | `dependency_key`, source, target, type, status, due date, owner | Connects initiatives/work packages/milestones | Source-backed relationship and owner |
| Milestone | `milestone_key`, planned date, actual date, state, criticality | Gates initiative or outcome | Native schedule evidence |
| Outcome | `outcome_key`, statement, measure, target, owner, realization state | Links initiative and VRO/OKR evidence | Cited measure and period required |
| Sequence risk | `risk_key`, blocked item, cause, impact, likelihood, owner | Links dependency/milestone to decision | Native risk record or accepted evidence |

## Agent lifecycle

1. **Scope:** resolve authorized project/portfolio, transformation stream, principal, and specialist memory namespace.
2. **Load:** read accepted transformation, work-package, relation, schedule, risk, benefit, and outcome evidence.
3. **Model:** construct dependency and milestone views without inventing edges; preserve source IDs and observed time.
4. **Assess:** identify critical-path pressure, sequencing conflicts, stale milestones, blocked dependencies, and outcome gaps.
5. **Recommend:** draft sequencing options, dependency actions, owner escalations, and milestone recovery recommendations.
6. **Escalate:** route material schedule, dependency, or outcome risk to accountable owners and native approval state.
7. **Persist:** record a native AgentRun and recommendation; Mem0 writes require evidence-steward approval and project/user/specialist scope.

## Tool and safety boundary

The TMO Agent may read authorized projects, work packages, relations, schedules, milestones, risks, benefits, outcomes, and accepted evidence. It may calculate deterministic lead/lag and dependency posture and draft recommendations. It may not change schedules, reorder work, assign owners, approve milestones, or mutate portfolio records. Governed changes must enter native OpenProject workflows with permissions, audit, and approval.

## Sequence rules

A dependency is critical only when its source, target, status, timing, and owner are evidenced. A milestone is stale only relative to its stated observation and time zone. An outcome gap is reported when a target or measure is missing, not replaced with a guessed value. Proposed sequence changes remain recommendations until approved by the accountable owner.

## Output contract

A TMO result contains `status`, `project_id`, `specialist`, `correlation_id`, `stream_posture`, `initiative_posture`, `dependency_chains`, `critical_path_signals`, `milestone_variances`, `outcome_gaps`, `sequence_risks`, `recommendations`, `escalations`, `missing_data`, `approval_state`, `evidence_references`, `model_provider_trace`, and `memory_retrieval_trace`.
