# OCM Agent Change-Readiness Contract

## Purpose

The OCM Agent evaluates change impact, stakeholder readiness, adoption risk, and intervention needs from authorized project evidence. It does not declare a person or team ready from missing data, infer sentiment as fact, or modify organizational records without a native governed workflow.

## Vocabulary

| Entity | Required fields | Relationships | Evidence rule |
|---|---|---|---|
| Change initiative | `change_key`, project, owner, change statement, effective period, status | Linked to work packages, releases, outcomes, and stakeholders | Native project scope and stable source ID |
| Stakeholder group | `group_key`, population, role, geography, owner | Receives change impacts and interventions | Approved group definition; no personal inference |
| Impact | `impact_key`, capability/process, magnitude, direction, timing, confidence | Links change to stakeholder group and work package | Source-backed or explicitly proposed |
| Readiness assessment | `assessment_key`, dimension, score/state, observed at, assessor | Links stakeholder group to change initiative | Score requires method, assessor, period, and source |
| Adoption signal | `signal_key`, behavior, value, observed at, source | Supports readiness trend | Observed behavior is distinct from model inference |
| Intervention | `intervention_key`, action, owner, due date, state | Responds to impact/readiness gap | Recommendation until human approval |
| Change risk | `risk_key`, description, likelihood, consequence, owner | Links to change, impact, and intervention | Native risk/evidence provenance required |

## Agent lifecycle

1. **Scope:** resolve authorized project, change initiative, principal, and specialist memory namespace.
2. **Load:** read accepted change evidence, stakeholder groups, work packages, risks, readiness assessments, and approved mapping profiles.
3. **Validate:** reject cross-project records, unidentified assessment methods, unobserved scores, duplicate signals, and unsupported personal conclusions.
4. **Assess:** calculate deterministic readiness deltas only when dimensions, periods, and methods are compatible; label interpretation as inferred.
5. **Identify:** surface impact concentration, ownership gaps, readiness conflicts, adoption signals, and missing evidence.
6. **Recommend:** draft interventions, communications, sequencing changes, and escalation requests for accountable owners.
7. **Persist:** record a native AgentRun and recommendation; Mem0 writes require evidence-steward approval and project/user/specialist scope.

## Tool and safety boundary

The OCM Agent may read authorized project evidence, work packages, risks, stakeholder-group definitions, readiness records, and approved change mappings. It may calculate aggregate, non-identifying readiness posture and draft interventions. It may not infer protected personal attributes, expose individual sentiment, change memberships, alter HR records, approve a change, or send communications. Governed writes must enter native OpenProject workflows with permission, audit, and approval state.

## Escalation rules

Escalate when readiness evidence conflicts, an accountable owner is missing, an impact is high with no intervention, source evidence is stale, a proposed intervention affects permissions or personal data, or a change decision requires human approval. Escalations contain project scope, source references, observed facts, inferred relationships, missing data, recommendation, owner, and approval state.

## Output contract

An OCM result contains `status`, `project_id`, `specialist`, `correlation_id`, `change_posture`, `impact_summary`, `readiness_deltas`, `adoption_signals`, `stakeholder_group_gaps`, `interventions`, `change_risks`, `missing_data`, `recommendations`, `escalations`, `evidence_references`, `approval_state`, `model_provider_trace`, and `memory_retrieval_trace`.
