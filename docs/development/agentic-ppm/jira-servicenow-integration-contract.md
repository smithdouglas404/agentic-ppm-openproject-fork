# Jira and ServiceNow Integration Contract

The native `config/agentic_ppm/integrations.yml` policy is the executable contract for the first connection phase. Jira and ServiceNow providers remain disabled by default, accept only read-only synchronization mode, and persist only a managed credential reference rather than a token or password.

Jira requires the authorizing account’s project and board/issue visibility in addition to OAuth scopes. The policy records approved read-only Jira platform and Software scopes, board, issue, sprint, and sprint-issue endpoints, an explicit field allow-list, cursor/offset checkpoints, and normalized work-package, milestone, and relationship targets.[1][2][3]

ServiceNow requires approved instance-level authorization and explicit table-read evidence. The policy permits only selected Table API and Change Management API reads, selected source tables, field allow-lists, bounded pagination, a `sys_updated_on` plus `sys_id` checkpoint, and normalized demand, change, incident, service, and risk targets.[4][5][6]

No connection may be enabled until a global administrator has supplied protected credential metadata, selected the approved authentication mode and mapping profile, and recorded endpoint health, source authorization, and project/workspace scope proof. The policy explicitly prohibits writes, scope or role escalation, unapproved discovery, and direct browser credential entry.

## Sources

[1] [Atlassian Jira OAuth scopes](https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/)

[2] [Atlassian Jira Software board API](https://developer.atlassian.com/cloud/jira/software/rest/api-group-board/)

[3] [Atlassian Jira Software sprint API](https://developer.atlassian.com/cloud/jira/software/rest/api-group-sprint/)

[4] [ServiceNow API authentication](https://www.servicenow.com/docs/r/xanadu/platform-security/authentication/api-authentication.html)

[5] [ServiceNow Table API](https://www.servicenow.com/docs/r/api-reference/rest-apis/c_TableAPI.html)

[6] [ServiceNow Change Management API](https://www.servicenow.com/docs/r/api-reference/rest-apis/change-management-api.html)
