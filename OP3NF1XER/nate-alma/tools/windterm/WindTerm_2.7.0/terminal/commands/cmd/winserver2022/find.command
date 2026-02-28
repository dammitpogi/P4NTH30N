description:
  Searches for a string of text in a file or files, and displays lines of text that contain the specified string.
synopses:
  - find [/v] [/c] [/n] [/i] [/off[line]] <"string"> [[<drive>:][<path>]<filename>[...]]
options:
  /v: Displays all lines that don't contain the specified `<string>`.
  /c: Counts the lines that contain the specified `<string>` and displays the total.
  /n: Precedes each line with the file's line number.
  /i: Specifies that the search is not case-sensitive.
  /off, /offline: Doesn't skip files that have the offline attribute set.
  /?: Displays help at the command prompt.