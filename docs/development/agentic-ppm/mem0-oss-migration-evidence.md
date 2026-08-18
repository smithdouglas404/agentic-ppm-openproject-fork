# Mem0 OSS Migration Evidence

## Official source record

The Mem0 OSS migration guidance states that Python `search()` and `get_all()` entity identifiers move from top-level keyword arguments into a `filters` object, while `add()` retains top-level entity identifiers. The guidance also marks the change as breaking and recommends updating the package before adopting the scoped-filter contract.

The pgvector reference documents Python `connection_string` as the highest-priority connection input, ahead of split connection fields. The Agentic PPM memory service therefore uses a generated PostgreSQL connection string built from protected Railway variables rather than relying on split-field mapping.

| Evidence | Implementation consequence | Status |
|---|---|---|
| Current scoped filter contract | Read and search paths require `filters={"agent_id": ...}` or another bounded entity scope. | Implemented and protected-read proven. |
| `connection_string` priority | pgvector connection is constructed from protected host, port, database, user, and password variables. | Implemented; non-writing scoped retrieval returns an empty result. |
| Public health versus protected memory operations | Health remains unauthenticated for service monitoring; memory read, search, and write endpoints require `X-Mem0-Api-Key`. | Implemented; unauthenticated read returned HTTP 401 and a managed Agents key returned a scoped empty result. |
| Real memory activation | A source-backed PMO flow must produce a governed finding before the service receives any memory write. | Open. |

## Sources

1. [Mem0 OSS v2-to-v3 migration guide](https://github.com/mem0ai/mem0/blob/main/docs/migration/oss-v2-to-v3.mdx)
2. [Mem0 pgvector configuration](https://docs.mem0.ai/components/vectordbs/dbs/pgvector)
3. [Mem0 OSS configuration](https://docs.mem0.ai/open-source/configuration)
