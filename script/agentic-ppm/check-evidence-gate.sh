#!/usr/bin/env bash
set -euo pipefail

base_ref=${1:?"Base revision is required"}
head_ref=${2:-HEAD}
evidence_file="docs/development/agentic-ppm/runtime-evidence.md"

if ! git cat-file -e "${base_ref}^{commit}" 2>/dev/null; then
  base_ref="${head_ref}^"
fi

changed_files=$(git diff --name-only "$base_ref" "$head_ref")

if grep -qE '^modules/agentic_ppm/(app|config|db|lib)/' <<<"$changed_files"; then
  if ! grep -qx "$evidence_file" <<<"$changed_files"; then
    echo "Native Agentic PPM source changed without updating ${evidence_file}."
    exit 1
  fi
fi

for heading in "# Agentic PPM Runtime Evidence" "## Verified Runtime Evidence" "## Explicitly Unverified or Inactive"; do
  grep -Fqx "$heading" "$evidence_file" >/dev/null || {
    echo "Missing required evidence heading: $heading"
    exit 1
  }
done

echo "Agentic PPM source-first evidence gate passed."
