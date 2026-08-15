# Agentic PPM Optional Service Activation

This Compose profile is deliberately separate from OpenProject’s default development stack. It allows the Agentic PPM module to activate Memgraph, Langflow, and a Letta App Server when Docker is available, without making those services prerequisites for ordinary OpenProject development.

```bash
docker compose \
  --env-file docker/dev/agentic-ppm.local.env \
  -f docker/agentic-ppm/compose.yml \
  --profile agentic-ppm up -d
```

The module must use the service adapter configuration in `config/agentic_ppm/services.yml`; it must not assume local hostnames, ports, or service availability. Mem0 and Inngest are exposed as remote adapters initially because their self-hosted deployment requires a separate approved runtime configuration. Their absence must produce an explicit capability state rather than blocking OpenProject workflows.

> Do not put credentials in this directory. Use managed secret storage and the git-ignored `docker/dev/agentic-ppm.local.env` placeholder only for local wiring.
