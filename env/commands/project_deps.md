---
description: Check dependencies for outdated versions and known vulnerabilities. Report only, upgrades nothing
allowed-tools: Bash(git ls-files:*), Bash(git log:*), Bash(git status:*)
---

Check the health of the project dependencies. Report only: do not upgrade, install or edit anything.

Focus (optional: a manifest, an ecosystem or a package): $ARGUMENTS

Steps:
1. Find the dependency manifests and lock files (package.json, pom.xml, build.gradle, requirements, pyproject, etc.). The project may use several languages; cover each one.
2. For each ecosystem, use its own tools when available to list outdated packages and known vulnerabilities (for example `npm outdated` and `npm audit`, `pip list --outdated`, `pip-audit`, Maven or Gradle versions and audit plugins). If a tool is not installed, say so; do not guess versions or vulnerabilities from memory.
3. Output, short and schematic:
   - **Vulnerabilities first**: package, version, severity, what the problem allows in plain words, and the fixed version.
   - **Outdated**: package, current and latest version, and whether the jump is patch, minor or major (major jumps may break things).
   - **Risky**: abandoned or deprecated packages, if you can tell.
4. Finish with a suggested order of upgrades (safest first) and what should be tested after each one. Do not apply anything.

Reply following the global communication rules.
