# Methodology Profiles and Semantic Mapping Contract

## Methodology profiles

Each project has a versioned profile with lifecycle states, cadence, role vocabulary, evidence requirements, planning units, and transition rules. The profile changes interpretation and validation; it does not replace native OpenProject project or work-package identity.

| Profile | Planning unit | Typical states | Required semantic emphasis |
|---|---|---|---|
| Waterfall | phase/milestone | planned, baselined, in-progress, gated, complete | stage gates, baseline variance, dependencies |
| Agile | iteration/release | backlog, ready, active, review, done | flow, iteration commitment, outcome evidence |
| Hybrid | phase + iteration | gated with iterative delivery | cross-cadence alignment and dependency joins |
| SAFe | epic/capability/feature | funnel, analyzing, implementing, releasing | lean portfolio, ART/value-stream alignment |
| Scrum | sprint/product backlog | ordered, sprint-ready, in-sprint, accepted | increment, sprint goal, acceptance evidence |
| Kanban | flow item | ready, active, blocked, done | WIP, aging, throughput, blocked time |
| Lean Portfolio Management | investment/theme/epic | funnel, analyze, prioritize, execute | funding, strategic alignment, benefit realization |
| Customer-defined | declared by customer | versioned customer states | explicit mapping, validation, and fallback behavior |

## Mapping rules

A mapping is a versioned record containing `profile_id`, `source_type`, `source_field`, `target_namespace`, `target_type`, `target_attribute`, `transform`, `required`, `confidence_policy`, `effective_from`, `effective_to`, and `owner`. Mapping precedence is customer override, approved profile mapping, then safe default. Unknown fields are retained as unmapped evidence and never silently discarded.

## Core semantic mappings

| Source concept | Target ontology | Required evidence |
|---|---|---|
| project/program | `project:project` / `portfolio:portfolio` | native project ID, name, methodology profile |
| epic/initiative | `delivery:stream` or `portfolio:investment-theme` | source key, owner, lifecycle |
| work package | `project:work-package` | native work-package ID, status, dates |
| milestone | `project:milestone` | target date, baseline/version |
| risk/issue | `risk:risk` / `risk:issue` | severity, owner, status, observed time |
| dependency | `project:dependency` relationship `depends_on`/`blocks` | source endpoints, direction, status |
| objective/KPI | `value:objective` / `value:KPI` | period, unit, observation status |
| benefit | `value:benefit` | hypothesis, owner, realization checkpoint |
| budget/cost | `finance:funding-envelope` / `finance:cost` | currency, period, approval, source |
| team/stakeholder | `people:team` / `people:stakeholder-group` | membership or governed OCM evidence |
| control/decision | `governance:control` / `governance:decision` | policy version, approver, audit reference |

## Version migration and compatibility

Ontology versions use semantic versioning. Additive concepts and optional attributes are backward compatible. Renames, relationship-direction changes, unit changes, and required-field changes require a migration plan, dual-read window, validation report, and rollback version. Historical graph entities retain their source-version and observed history. Agents must declare the ontology version they support; unsupported versions fail closed or route to review.

A migration record contains actor, rationale, effective time, source and target versions, affected namespaces, counts of mapped/unmapped records, validation failures, rollback plan, and approval. No migration deletes source evidence or rewrites native OpenProject history.
