description:
  Displays the location of files that match the given search pattern.
synopses:
  - where [/r <Dir>] [/q] [/f] [/t] [$<ENV>:|<Path>:]<Pattern>[ ...]
options:
  /r <Dir>: Indicates a recursive search, starting with the specified directory.
  /q: Returns an exit code without displaying the list of matched files.
  /f: Displays the results of the "where" command in quotation marks.
  /t: Displays the file size and the last modified date and time of each matched file.
  /?: Displays help at the command prompt.