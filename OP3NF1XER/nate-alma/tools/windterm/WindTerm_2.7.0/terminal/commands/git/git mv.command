description:
  Move or rename a file, a directory, or a symlink
synopses:
  - git mv [-v] [-f] [-n] [-k] <source> <destination>
  - git mv [-v] [-f] [-n] [-k] <source> ... <destination directory>
options:
  -f, --force: Force renaming or moving of a file even if the target exists
  -k: Skip move or rename actions which would lead to an error condition.
  -n, --dry-run: Do nothing; only show what would happen
  -v, --verbose: Report the names of files as they are moved.