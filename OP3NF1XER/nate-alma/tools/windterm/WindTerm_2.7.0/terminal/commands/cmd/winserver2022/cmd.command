description:
  Starts a new instance of the command interpreter, Cmd.
synopses:
  - cmd [/c|/k] [/s] [/q] [/d] [/a|/u] [/t:{<b><f> | <f>}] [/e:{on | off}] [/f:{on | off}] [/v:{on | off}] [<string>]
options:
  /c: Carries out the command specified by string and then stops.
  /k: Carries out the command specified by string and continues.
  /s: Modifies the treatment of string after /c or /k.
  /q: Turns the echo off.
  /d: Disables execution of AutoRun commands.
  /a: Formats internal command output to a pipe or a file as American National Standards Institute (ANSI).
  /u: Formats internal command output to a pipe or a file as Unicode.
  /t:{<b><f> | <f>}: Sets the background (b) and foreground (f) colors.
  /e:{on | off}:
    description: Toggle command extensions.
    values:
      - on: Enable command extensions
      - off: Disable command extensions
  /f:{on | off}:
    description: Toggle file and directory name completion.
    values:
      - on: Enable file and directory name completion
      - off: Disable file and directory name completion
  /v:{on | off}:
    description: Toggle delayed environment variable expansion
    values:
      - on: Enable delayed environment variable expansion
      - off: Disable delayed environment variable expansion
  /?: Displays help at the command prompt.