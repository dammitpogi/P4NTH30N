description:
  Searches for patterns of text in files.
synopses:
  - findstr [/b] [/e] [/l | /r] [/s] [/i] [/x] [/v] [/n] [/m] [/o] [/p] [/f:<file>]
    [/c:<string>] [/g:<file>] [/d:<dirlist>] [/a:<colorattribute>] [/off[line]] <strings>
    [<drive>:][<path>]<filename>[ ...]
options:
  /b: Matches the text pattern if it is at the beginning of a line.
  /e: Matches the text pattern if it is at the end of a line.
  /l: Processes search strings literally.
  /r: Processes search strings as regular expressions. This is the default setting.
  /s: Searches the current directory and all subdirectories.
  /i: Ignores the case of the characters when searching for the string.
  /x: Prints lines that match exactly.
  /v: Prints only lines that don't contain a match.
  /n: Prints the line number of each line that matches.
  /m: Prints only the file name if a file contains a match.
  /o: Prints character offset before each matching line.
  /p: Skips files with non-printable characters.
  /off, /offline: Does not skip files that have the offline attribute set.
  /f:<file>: Gets a file list from the specified file.
  /c:<string>: Uses the specified text as a literal search string.
  /g:<file>: Gets search strings from the specified file.
  /d:<dirlist>: Searches the specified list of directories. Each directory must be separated with a semicolon (;).
  /a:<colorattribute>: Specifies color attributes with two hexadecimal digits.
  /?: Displays Help at the command prompt.