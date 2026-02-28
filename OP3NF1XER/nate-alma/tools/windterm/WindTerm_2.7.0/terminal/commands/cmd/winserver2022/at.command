description:
  Schedules commands and programs to run on a computer at a specified time and date.
synopses:
  - at [\computername] [[id] [/delete] | /delete [/yes]]
  - at [\computername] <time> [/interactive] [/every:date[,...] | /next:date[,...]] <command>
options:
  /delete: Cancels a scheduled command.
  /yes: Answers yes to all queries from the system when you delete scheduled events.
  /interactive: Allows command to interact with the desktop of the user who is logged on at the time Command runs.
  /every:date[,...]: Runs "command" on every specified day or days of the week or month.
  /next:date[,...]: Runs "command" on the next occurrence of the day.
  /?: Displays help at the command prompt.