description:
  locate the binary, source, and manual page files for a command
synopses:
  - whereis [options] [-BMS directory... -f] name...
options:
  -b: Search for binaries.
  -m: Search for manuals.
  -s: Search for sources.
  -u: Only show the command names that have unusual entries.
  -B directories: Limit the places where whereis searches for binaries, by a whitespace-separated list of directories.
  -M directories: Limit the places where whereis searches for manuals and documentation in Info format, by a whitespace-separated list of directories.
  -S directories: Limit the places where whereis searches for sources, by a whitespace-separated list of directories.
  -f: Terminates the directory list and signals the start of filenames. It must be used when any of the -B, -M, or -S options is used.
  -l: Output the list of effective lookup paths that whereis is using.
  -h, --help: Display help text and exit.
  -V, --version: Display version information and exit.