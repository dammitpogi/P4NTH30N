description:
  Show the working tree status
synopses:
  - git status [<options>…​] [--] [<pathspec>…​]
options:
  -s, --short: Give the output in the short-format.
  -b, --branch: Show the branch and tracking info even in short-format.
  --show-stash: Show the number of entries currently stashed away.
  --porcelain[=<version>]: Give the output in an easy-to-parse format for scripts.
  --long: Give the output in the long-format. This is the default.
  -v, --verbose: In addition to the names of files that have been changed, also show the textual changes that are staged to be committed.
  -u[<mode>], --untracked-files[=<mode>]:
    description: Show untracked files.
    values:
      - no: Show no untracked files
      - normal: Shows untracked files and directories
      - all: Also shows individual files in untracked directories.
  --ignore-submodules[=<when>]:
    description: Ignore changes to submodules in the diff generation.
    values:
      - none: Submodule is not considered modified when it either contains untracked or modified files or its HEAD differs from the commit recorded in the superproject
      - untracked: Submodules are not considered dirty when they only contain untracked content
      - dirty: Ignores all changes to the work tree of submodules, only changes to the commits stored in the superproject are shown
      - all: Hides all changes to submodules
  --ignored[=<mode>]:
    description: Show ignored files as well.
    values:
      - traditional: Shows ignored files and directories.
      - no: Show no ignored files.
      - matching: Shows ignored files and directories matching an ignore pattern.
  -z: Terminate entries with NUL, instead of LF.
  --column[=<options>]:
    description: Display untracked files in columns.
    values:
      - always: always show in columns
      - auto: show in columns if the output is to the terminal
      - never: never show in columns
      - column: fill columns before rows
      - row: fill rows before columns
      - plain: show in one column
      - dense: make unequal size columns to utilize more space
      - nodense: make equal size columns
  --no-column: Hide untracked files in columns.
  --ahead-behind: Display detailed ahead/behind counts for the branch relative to its upstream branch.
  --no-ahead-behind: Do not display detailed ahead/behind counts for the branch relative to its upstream branch.
  --renames: Turn on rename detection regardless of user configuration.
  --no-renames: Turn off rename detection regardless of user configuration.
  --find-renames[=<n>]: Turn on rename detection, optionally setting the similarity threshold.