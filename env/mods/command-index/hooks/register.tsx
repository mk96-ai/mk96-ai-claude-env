import type { CommandInfo, Register } from 'claude-code'

const COMMAND_NAME = 'command_list'
const PANE_ID = 'command-list'
// Display order of the known prefixes; any other prefix falls into OTHER_GROUP.
const GROUP_ORDER = ['git', 'changes', 'project', 'debug', 'session', 'command']
const OTHER_GROUP = 'other'

// Remembered between runs of the command, so a redraw keeps the same view.
let isShowingAll = false

const prefixOf = (name: string): string => name.split('_')[0] ?? name

const selectCommands = (
  commands: readonly CommandInfo[],
  isAll: boolean,
): CommandInfo[] =>
  commands.filter(command =>
    isAll ? command.source !== 'builtin' : command.source === 'user',
  )

const groupCommands = (commands: readonly CommandInfo[]) => {
  const groups = new Map<string, CommandInfo[]>()
  for (const command of commands) {
    const prefix = prefixOf(command.name)
    const group = GROUP_ORDER.includes(prefix) ? prefix : OTHER_GROUP
    groups.set(group, [...(groups.get(group) ?? []), command])
  }
  return [...GROUP_ORDER, OTHER_GROUP]
    .filter(group => groups.has(group))
    .map(group => ({
      group,
      commands: (groups.get(group) ?? []).sort((a, b) =>
        a.name.localeCompare(b.name),
      ),
    }))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: COMMAND_NAME,
      description: 'Show your slash commands grouped by prefix (Esc closes it)',
      argumentHint: 'all',
    })
    return next(e)
  })

  // The command only opens the pane: nothing is printed in the conversation.
  on('command.run', { command: COMMAND_NAME }, async ($, e) => {
    isShowingAll = e.args.trim() === 'all'
    await $.ui.open({
      id: PANE_ID,
      title: 'Commands',
      focus: true,
      closeOnEscape: true,
    })
    return {}
  })

  on('ui.render', { component: 'Pane', requestId: PANE_ID }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const commands = selectCommands(await $.command.list(), isShowingAll)
    const groups = groupCommands(commands)
    const nameWidth = Math.max(0, ...commands.map(c => c.name.length)) + 3

    if (commands.length === 0) {
      return <Text dimColor>No custom commands found. Esc closes.</Text>
    }

    return (
      <Box flexDirection="column">
        {groups.map(({ group, commands: members }) => (
          <Box flexDirection="column">
            <Text weight="bold">
              {group.toUpperCase()} ({members.length})
            </Text>
            {members.map(command => (
              <Box flexDirection="row">
                <Text>{`  /${command.name}`.padEnd(nameWidth + 2)}</Text>
                <Text dimColor>{command.description}</Text>
              </Box>
            ))}
            <Text> </Text>
          </Box>
        ))}
        <Text dimColor>
          {commands.length} commands. Esc closes.
          {isShowingAll ? '' : ` /${COMMAND_NAME} all adds plugin commands.`}
        </Text>
      </Box>
    )
  })
}
