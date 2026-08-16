# Frontend Artifact Compatibility Record

## Status

The Agentic PPM fork source identifies itself as **OpenProject 17.8.0**. An exact frontend artifact was built from the `agentic-ppm-runtime-proof` branch by the private fork's GitHub Actions workflow on 2026-08-16 and deployed to the Cloud Computer. The production login page and manifest-mapped `main`, `polyfills`, and `styles` entrypoints returned HTTP 200; the authenticated native Agentic PPM project route also returned HTTP 200.

## Runtime Decision

The Cloud Computer cannot safely build the full Angular frontend in place because the VM has approximately 958 MB of memory and limited disk headroom. The earlier source-map-free OpenProject 17.7.2 browser bundle was therefore used only as a temporary proof bridge. It has now been replaced by the exact branch-built artifact from GitHub Actions run `31917353652`; the supported Rails task rebuilt `config/frontend_assets.manifest.json`, and production Rails/Sprockets assets were precompiled without recompiling Angular.

## Production Resolution Achieved

The exact-build path was selected and verified. The temporary close-version artifact remains only as a rollback archive on the Cloud Computer; it is not served by the active native application. Future frontend changes must continue to use the private fork's artifact workflow, including the linked-plugin generation step required before Angular compilation.

## References

[1] [OpenProject release notes](https://www.openproject.org/docs/release-notes/)

[2] [OpenProject upstream releases](https://github.com/opf/openproject/releases)

[3] [Exact frontend artifact workflow run](https://github.com/smithdouglas404/agentic-ppm-openproject-fork/actions/runs/31917353652)
