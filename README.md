# mk96-ai-claude-env

Claude Code environment of Markes96: global instructions, rules, skills, commands, hooks, mods, plugins and preferences.

It is written and read by the [mk96-env plugin](https://github.com/mk96-ai/mk96-ai-claude-env-plugin):

- `/mk96-env:export` stores the environment of a machine in `env/` and pushes it.
- `/mk96-env:import` brings it into another machine's `~/.claude`.

Do not edit `env/` by hand: change the environment in `~/.claude` and export it.

To start your own environment from this one, fork this repository and point the plugin to your fork.
