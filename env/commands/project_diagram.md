---
description: Draw a diagram of the project parts and how they relate (terminal-friendly, optional Mermaid). Read-only
allowed-tools: Bash(git ls-files:*), Bash(git grep:*), Bash(git log:*)
---

Draw how the project is organized. Read-only: do not create files.

Focus (optional: a module, a flow or a level of detail; default the whole project at high level): $ARGUMENTS

Steps:
1. Map the real structure from the code: main modules or services, entry points, databases, queues, external services, and which part calls which. Use imports, configuration and routes as evidence, not folder names alone.
2. Draw it as a text diagram inside a code block, aligned and complete (no `...`), readable in a terminal. Use boxes and arrows. Keep it to what fits on one screen; if the project is bigger, draw the high level and offer to zoom into each part.
3. Under the diagram, add a legend: one plain line per box saying what it is responsible for.
4. Mark as a guess any relationship you could not confirm in the code.
5. Offer a Mermaid version for pasting into documentation. Do not generate it unless asked.

Reply following the global communication rules.
