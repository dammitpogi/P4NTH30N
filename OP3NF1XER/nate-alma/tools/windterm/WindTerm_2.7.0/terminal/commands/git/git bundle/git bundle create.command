description:
  Create a bundle.
synopses:
  - git bundle create [-q | --quiet | --progress | --all-progress] [--all-progress-implied]
    [--version=<version>] <file> <git-rev-list-args>
options:
  --progress: Progress status is reported on the standard error stream by default when it is attached to a terminal
  --all-progress: This flag is like --progress except that it forces progress report for the write-out phase as well even if --stdout is used.
  --all-progress-implied: This is used to imply --all-progress whenever progress display is activated. Unlike --all-progress this flag doesn't actually force any progress display by itself.
  --version=<version>: Specify the bundle version.
  -q, --quiet: This flag makes the command not to report its progress on the standard error stream.