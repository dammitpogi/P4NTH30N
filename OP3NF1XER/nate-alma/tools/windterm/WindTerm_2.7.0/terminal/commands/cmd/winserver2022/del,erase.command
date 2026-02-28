description:
  Deletes one or more files.
synopses:
  - del [/p] [/f] [/s] [/q] [/a[:<attributes>]] <names>
options:
  /p: Prompts for confirmation before deleting the specified file.
  /f: Forces deletion of read-only files.
  /s: Deletes specified files from the current directory and all subdirectories. Displays the names of the files as they are being deleted.
  /q: Specifies quiet mode. You are not prompted for delete confirmation.
  /a[:<attributes>]:
    description: Deletes files based on the file attributes
    values:
      - r: Read-only files
      - h: Hidden files
      - i: Not content indexed files
      - s: System files
      - a: Files ready for archiving
      - '|': Reparse points
      - -: Used as a prefix meaning 'not'
  /?: Displays help at the command prompt.