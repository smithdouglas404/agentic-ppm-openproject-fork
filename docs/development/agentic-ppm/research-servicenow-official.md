# Official ServiceNow Research Notes

## Authorization Boundary

ServiceNow documents API authentication as identity validation followed by authorization against the instance features available to that identity. Its OAuth documentation describes external clients obtaining a token to access instance resources rather than transmitting login credentials on every request.[1][2] The native connection model must therefore retain only a protected credential reference, instance URL, authorizing identity or service principal metadata, selected table or API contract, table-level read authorization evidence, and an explicit mapping profile.

## Read-Only Mapping Surface

| ServiceNow source | Official behavior | Initial Agentic PPM mapping |
| --- | --- | --- |
| Table API | ServiceNow documents the Table API as CRUD endpoints over existing tables; initial integration uses only read operations, a configured field allow-list, pagination/cursor checkpoint, and table-level authorization.[3] | Incidents, demands, risks, service records, and other approved record tables become source-backed facts rather than OpenProject work-package replacements. |
| Change Management API | ServiceNow documents a dedicated Change Management REST API for third-party integration with the Change Management process.[4] | Change evidence, lifecycle state, planned timing, affected service reference, and risk/control links. |
| OAuth application | ServiceNow documents OAuth 2.0 as token-based external-client access to instance resources.[2] | Preferred approved authorization option when an instance administrator supplies the client registration and permitted scope/role model. |

## Safety Requirements

The initial connector is read-only and disabled by default. It must require an approved instance URL, credential reference, exact table/API allow-list, field allow-list, authorizing principal metadata, project/workspace mapping profile, pagination checkpoint, source sys_id or record identity, observed time, correlation ID, and authorization provenance. It may not write records, elevate roles, discover tables broadly, or ingest fields outside the approved mapping profile.

## Sources

[1] [ServiceNow API authentication](https://www.servicenow.com/docs/r/xanadu/platform-security/authentication/api-authentication.html)

[2] [ServiceNow OAuth 2.0 applications](https://www.servicenow.com/docs/r/platform-security/authentication/c_OAuthApplications.html)

[3] [ServiceNow Table API](https://www.servicenow.com/docs/r/api-reference/rest-apis/c_TableAPI.html)

[4] [ServiceNow Change Management API](https://www.servicenow.com/docs/r/api-reference/rest-apis/change-management-api.html)
