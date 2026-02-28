description:
  Creates a directory or file symbolic or hard link.
synopses:
  - mklink [[/d] | [/h] | [/j]] <link> <target>
options:
  /d: Creates a directory symbolic link. By default, this command creates a file symbolic link.
  /h: Creates a hard link instead of a symbolic link.
  /j: Creates a Directory Junction.
  /?: Displays help at the command prompt.