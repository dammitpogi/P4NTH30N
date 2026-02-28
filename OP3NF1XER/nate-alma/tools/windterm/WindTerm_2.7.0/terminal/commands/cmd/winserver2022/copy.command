description:
  Copies one or more files from one location to another.
synopses:
  - copy [/d] [/v] [/n] [/y | /-y] [/z] [/a | /b] <source> [/a | /b] [+<source> [/a | /b] [+ ...]] [<destination> [/a | /b]]
options:
  /d: Allows the encrypted files being copied to be saved as decrypted files at the destination.
  /v: Verifies that new files are written correctly.
  /n: Uses a short file name, if available, when copying a file with a name longer than eight characters, or with a file name extension longer than three characters.
  /y: Suppresses prompting to confirm that you want to overwrite an existing destination file.
  /-y: Prompts you to confirm that you want to overwrite an existing destination file.
  /z: Copies networked files in restartable mode.
  /a: Indicates an ASCII text file.
  /b: Indicates a binary file.
  /?: Displays help at the command prompt.