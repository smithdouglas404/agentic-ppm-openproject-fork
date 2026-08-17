# Official Jira Cloud Research Notes

## Authorization Boundary

Atlassian states that OAuth scopes establish potential access but do not override Jira permissions: an app cannot read a project if the authorizing user lacks the corresponding Jira project permission. The integration must therefore retain the authorizing principal, Jira cloud/site identity, requested scopes, and a project mapping in its protected connection configuration.[1]

For a read-only initial portfolio synchronization, the preferred classic Jira Cloud platform scope is `read:jira-work`; Jira Software resources require their documented granular Software scopes. Write scopes must not be requested for initial evidence ingestion. Atlassian recommends classic scopes where available and asks app developers to select scopes from the specific REST operations they use.[1]

## Read-Only Mapping Surface

| Jira source | Official read behavior | Initial Agentic PPM mapping |
| --- | --- | --- |
| Board | `GET /rest/agile/1.0/board`; results are limited to boards the user may view, with `read:board-scope:jira-software` and `read:project:jira` documented.[2] | Project/portfolio container and Agile delivery context |
| Sprint | `GET /rest/agile/1.0/sprint/{sprintId}` returns a sprint only when the user can view its board or at least one issue in it; requires `read:sprint:jira-software`.[3] | Sprint/iteration evidence, schedule dates, goal, and state |
| Sprint issues | Jira documents paginated sprint issue retrieval and includes Software fields such as sprint, closed sprints, flagged, and epic; the enhanced route requires `read:sprint:jira-software`, `read:issue-details:jira`, and `read:jql:jira`.[3] | Work-package evidence, epic containment, and delivery context |
| Issue links | Jira Software issue results expose `issuelinks` with inward/outward issues and link-type semantics.[3] | Directed dependency evidence; preserve raw link type and normalized relationship mapping |
| Version/release | Jira platform version endpoints are governed by project-version read scopes.[1] | Release/milestone evidence when an approved mapping profile is configured |

## Safety Requirements

The first connection is read-only, paginated, and idempotent. It must preserve Jira issue IDs and keys, board/sprint IDs, link IDs and directions, authorizing account context, scopes, field selections, cursor/checkpoint, observed time, and correlation ID. A connector may not write back to Jira, register webhooks, or broaden scopes without an approved lifecycle change.

## Sources

[1] [Atlassian Jira OAuth 2.0 scopes](https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/)

[2] [Atlassian Jira Software board REST API](https://developer.atlassian.com/cloud/jira/software/rest/api-group-board/)

[3] [Atlassian Jira Software sprint REST API](https://developer.atlassian.com/cloud/jira/software/rest/api-group-sprint/)
