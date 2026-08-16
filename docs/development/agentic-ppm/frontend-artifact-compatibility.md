# Frontend Artifact Compatibility Record

## Status

The Agentic PPM fork source currently identifies itself as **OpenProject 17.8.0**. As of 2026-08-16, the latest official stable OpenProject release is **17.7.2**; an official 17.8 release artifact is not listed in the upstream release index.[1][2]

## Runtime Decision

The Cloud Computer cannot safely build the full Angular frontend in place because the VM has approximately 958 MB of memory and limited disk headroom. A source-map-free OpenProject 17.7.2 frontend bundle was extracted from the official image and installed only as a **temporary proof bridge**. It allows the native login page, core browser entrypoints, and authenticated Agentic PPM project route to render during the runtime demonstration.

> This bridge is not an exact version match and must not be described as a final customer-production frontend.

## Required Production Resolution

Before customer production use, select exactly one of the following evidence-backed paths:

1. Build the fork’s exact 17.8 frontend artifact in a capacity-appropriate CI runner and deploy it with the matching Rails source.
2. Rebase the fork deliberately to the official 17.7.2 release tag, rebuild the Agentic PPM module against that baseline, and run the native regression suite.

The first path preserves current source direction. The second path is a compatibility rollback and requires an explicit source and migration review.

## References

[1] [OpenProject release notes](https://www.openproject.org/docs/release-notes/)

[2] [OpenProject upstream releases](https://github.com/opf/openproject/releases)
