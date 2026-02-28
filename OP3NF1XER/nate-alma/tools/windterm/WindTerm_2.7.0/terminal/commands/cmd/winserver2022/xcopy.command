description:
  Copies files and directories, including subdirectories.
synopses:
  - xcopy <Source> [<Destination>] [/w] [/p] [/c] [/v] [/q] [/f] [/l] [/g] [/d[:Date]]
    [/u] [/i] [/s [/e]] [/t] [/k] [/r] [/h] [{/a | /m}] [/n] [/o] [/x] [/exclude:File1[+File2][+File3]...]
    [{/y | /-y}] [/z] [/b] [/j]
options:
  /w: Displays the "Press any key to begin copying file" message.    
  /p: Prompts you to confirm whether you want to create each destination file.
  /c: Ignores errors.
  /v: Verifies each file as it is written to the destination file to make sure that the destination files are identical to the source files.
  /q: Suppresses the display of xcopy messages.
  /f: Displays source and destination file names while copying.
  /l: Displays a list of files that are to be copied.
  /g: Creates decrypted Destination files when the destination does not support encryption.
  /d[:Date]: Copies source files changed on or after the specified date only.
  /u: Copies files from *Source* that exist on *Destination* only.
  /i: Assumes Destination specifies a directory name and creates a new directory.
  /s: Copies directories and subdirectories, unless they are empty.
  /e: Copies all subdirectories, even if they are empty.
  /t: Copies the subdirectory structure (that is, the tree) only, not files.
  /k: Copies files and retains the read-only attribute on Destination files if present on the Source files.
  /r: Copies read-only files.
  /h: Copies files with hidden and system file attributes.
  /a: Copies only Source files that have their archive file attributes set.
  /m: Copies Source files that have their archive file attributes set.
  /n: Creates copies by using the NTFS short file or directory names.
  /o: Copies file ownership and discretionary access control list (DACL) information.
  /x: Copies file audit settings and system access control list (SACL) information.
  /exclude:File1[+File2][+File3]...: Specifies a list of files. At least one file must be specified.
  /y: Suppresses prompting to confirm that you want to overwrite an existing destination file.
  /-y: Prompts to confirm that you want to overwrite an existing destination file.
  /z: Copies over a network in restartable mode.
  /b: Copies the symbolic link instead of the files.
  /j: Copies files without buffering.
  /?: Displays help at the command prompt.