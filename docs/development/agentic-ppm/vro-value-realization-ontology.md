# VRO Agent Value-Realization Ontology

## Purpose

The VRO Agent interprets approved benefit hypotheses and outcome evidence within an authorized OpenProject project. It does not declare value realized from unverified claims; it produces evidence-cited posture, variance questions, and escalation recommendations for accountable owners.

## Core vocabulary

| Entity | Required fields | Relationships | Source boundary |
|---|---|---|---|
| Value hypothesis | `hypothesis_key`, statement, owner, baseline, target, expected_by | Linked to project, objective, benefit, and work package | Approved project evidence only |
| Benefit | `benefit_key`, description, category, owner, realization state | Realizes a hypothesis; linked to outcome measures and milestones | Approved benefit evidence |
| Outcome measure | `measure_key`, name, unit, baseline value, current value, target value, observed at | Measures a benefit; may link to KPI/OKR | Source-cited measurement evidence |
| Realization checkpoint | `checkpoint_key`, planned date, actual date, state, evidence status | Links benefit to milestone, release, or decision | OpenProject milestone and approved outcome records |
| Value variance | `variance_key`, expected, observed, delta, severity, reason status | Links to benefit, measure, owner, and escalation | Derived only from cited baseline/current evidence |
| Accountable owner | OpenProject user identity and project role | Owns hypothesis, benefit, measure, or variance | Native membership/permission records |

## VRO lifecycle

1. **Intake:** accept only project-scoped, authorized hypotheses, benefits, measures, milestones, and outcome envelopes.
2. **Baseline:** preserve the source baseline, unit, observed time, and provenance; never infer a baseline from missing data.
3. **Observe:** compare cited current evidence to the approved baseline and target using unit-safe semantics.
4. **Interpret:** produce an evidence-cited realization posture, missing-data notice, or variance question. A model inference is labeled as inference, not observed fact.
5. **Escalate:** route material variance or missing ownership to the accountable value owner through native OpenProject approval/escalation state.
6. **Persist:** record an audited AgentRun and recommendation; Mem0 writes require the common evidence-steward approval gate and use workspace/project/user/specialist scope.

## Permitted VRO tools

The VRO Agent may call `read_project_evidence`, `read_value_evidence`, and `record_audited_agent_run` within the current project. It cannot update benefit values, approve realization, change budgets, access raw connector credentials, or retrieve another project’s memory. Any governed business-data mutation must be approved and executed by a native OpenProject workflow.

## Mapping rules

A source record maps to a value entity only when it contains a stable source ID, project ID, entity key, observed timestamp, and approved mapping profile. Relationships preserve source identity and correlation ID in Memgraph. A measure without unit or observed time is retained as a missing-data condition, not converted into a numerical claim. A benefit with no accountable owner escalates as an ownership gap.

## Output contract

A VRO result contains: `status`, `project_id`, `specialist`, `correlation_id`, `observed_facts`, `inferred_relationships`, `value_variances`, `missing_data`, `recommendations`, `evidence_references`, `accountable_owner`, `escalation_state`, `model_provider_trace`, and `memory_retrieval_trace`. Human approval remains a native OpenProject state; the VRO Agent never represents a recommendation as an approved realization.
