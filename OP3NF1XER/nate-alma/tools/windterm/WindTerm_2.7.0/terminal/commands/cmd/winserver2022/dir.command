description:
  Displays a list of a directory's files and subdirectories.
synopses:
  - dir [<drive>:][<path>][<filename>] [...] [/p] [/q] [/w] [/d] [/a[[:]<attributes>]][/o[[:]<sortorder>]]
    [/t[[:]<timefield>]] [/s] [/b] [/l] [/n] [/x] [/c] [/4] [/r]
options:
  /p: Displays one screen of the listing at a time. To see the next screen, press any key.
  /q: Displays file ownership information.
  /w: Displays the listing in wide format, with as many as five file names or directory names on each line.
  /d: Displays the listing in the same format as **/w**, but the files are sorted by column.
  /a[:<attributes>]:
    description: Displays only the names of those directories and files with your specified attributes.
    values:
      - d: Directories
      - h: Hidden files
      - s: System files
      - l: Reparse points
      - r: Read only files
      - a: Files ready for archiving
      - i: Not content indexed files
  /o[:<sortorder>]:
    description: Sorts the output according to sortorder.
    values:
      - n: Alphabetically by name
      - e: Alphabetically by extension
      - g: Group directories first
      - s: By size, smallest first
      - d: By date/time, oldest first
      - -n: Reverse alphabetical order by name
      - -e: Reverse alphabetical order by extension
      - -g: Group directories last
      - -s: By size, smallest last
      - -d: By date/time, oldest last
  /t[:<timefield>]:
    description: Specifies which time field to display or to use for sorting.
    values:
      - c: Creation
      - a: Last accessed
      - w: Last written
  /s: Lists every occurrence of the specified file name within the specified directory and all subdirectories.
  /b: Displays a bare list of directories and files, with no additional information.
  /l: Displays unsorted directory names and file names, using lowercase.
  /n: Displays a long list format with file names on the far right of the screen.
  /x: Displays the short names generated for non-8dot3 file names.
  /c: Displays the thousand separator in file sizes.
  /-c: Hides the thousand separator in file sizes.
  /4: Displays years in four-digit format.
  /r: Display alternate data streams of the file.
  /?: Displays help at the command prompt.