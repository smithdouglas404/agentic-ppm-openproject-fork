# Letta Specialist-Agent Contract

## Status

This is an **inactive-by-default runtime contract**. It defines how the eight exact Agentic PPM specialists will be provisioned only after a Letta endpoint, protected credentials, model-policy approval, and project authorization proof are available. It does not assert that any Letta agent exists or can currently be invoked.

## Identity and Scope

Each agent receives the deterministic identity `agentic_ppm/<invocation_key>`. Persistent state is scoped to the project, authorized user, specialist invocation key, and applicable policy. Conversations cannot cross project boundaries, and cross-project evidence access requires a separate OpenProject authorization decision.

## Tool and Action Policy

Letta begins with no usable tool privileges. The native configuration’s per-agent `permitted_tools` list is the only eligible tool input; OpenProject-native policy must validate each tool call again. Agents cannot directly write OpenProject records, retrieve raw connector credentials, or use unscoped memory. Any state-changing action must enter a governed OpenProject workflow.

## Trace and Memory Requirements

Every invocation must retain OpenProject user and project identities, agent identity, authorization decision, evidence references, model-provider trace, and memory-retrieval trace. Mem0 retrieval and writes must additionally comply with workspace, project, user, agent, policy, retention, deletion, and citation controls defined before memory activation.

## Provisioning Gate

Provisioning requires a healthy authorized Letta service, protected endpoint credentials, allowed model-provider selection, project-permission enforcement, a tested tool registry, trace persistence, and an end-to-end PMO vertical-slice test. The VRO and other specialists remain inactive until the PMO slice is proven.
