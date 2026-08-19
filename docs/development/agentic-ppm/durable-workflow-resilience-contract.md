# Durable Workflow Resilience Contract

## Current source-backed behavior

OpenProject owns the durable AgentRun and GoodJob boundary. AgentRun creation is idempotency-correlated; evidence envelopes use project/idempotency keys; runtime evidence writes are atomic; Mem0 writes are evidence-stewarded; HTTP calls use bounded timeouts; long graph and ingest operations use background jobs and polling rather than synchronous proxy calls.

## Required execution envelope

Each durable workflow carries `agent_run_id`, `correlation_id`, `attempt_id`, `idempotency_key`, `specialist`, `project_id`, `principal_id`, `started_at`, `deadline_at`, and `cancel_requested_at`. Retries reuse the root correlation and idempotency key while incrementing attempt ID. A duplicate request must return the existing native run rather than create a second result.

## Retry policy

Retry only transient network, rate-limit, service-unavailable, and dependency-timeout classes. Use bounded exponential backoff with jitter and a maximum attempt count from the native policy. Do not retry validation, authorization, evidence-blocked, malformed-payload, or policy-denied failures. Every retry writes a trace event and preserves the prior error class.

## Timeout policy

Each boundary has a deadline: OpenProject handoff, Letta operation, Mem0 operation, Memgraph query, model call, Langflow validation, and native worker execution. A timeout produces `timed_out`, retains the correlation and source evidence, and moves the run to retryable or `needs_review` according to policy. It must not be represented as a successful empty result.

## Cancellation

Cancellation is requested in the native control plane and is cooperative. Workers check the request before starting a node, before external calls, and before durable writes. A cancelled run records `cancelled`, does not write findings or memory after the cancellation boundary, and retains its trace. Force termination is an operator recovery action and must not delete evidence or audit rows.

## Dead-letter handling

After the retry budget is exhausted, the native run enters a durable dead-letter state with correlation, attempt history, error class, last safe checkpoint, evidence references, and remediation owner. Dead-letter records are visible to operators, can be replayed only with an explicit new attempt, and cannot silently re-enter the queue. Replay preserves the root correlation and creates a new attempt ID.

## Verification gates

Required proof cases are: duplicate enqueue returns one run; transient failure retries; validation/auth failure does not retry; deadline produces `timed_out`; cancellation prevents downstream writes; retry exhaustion creates a visible dead-letter record; replay creates one new attempt; and all cases retain trace/audit provenance. Tests must use real persisted native records or bounded contract harnesses and must not seed fabricated customer evidence.
