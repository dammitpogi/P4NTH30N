description:
  List, create, or delete branches
synopses:
  - git branch [--color[=<when>] | --no-color] [-r | -a]
      [--list] [-v [--abbrev=<length> | --no-abbrev]]
      [--column[=<options>] | --no-column] [--sort=<key>]
      [(--merged | --no-merged) [<commit>]]
      [--contains [<commit>]] [--no-contains [<commit>]]
      [--points-at <object>] [--format=<format>] [<pattern>…​]
  - git branch [--track | --no-track] [-l] [-f] <branchname> [<start-point>]
  - git branch (--set-upstream-to=<upstream> | -u <upstream>) [<branchname>]
  - git branch --unset-upstream [<branchname>]
  - git branch (-m | -M) [<oldbranch>] <newbranch>
  - git branch (-c | -C) [<oldbranch>] <newbranch>
  - git branch (-d | -D) [-r] <branchname>…​
  - git branch --edit-description [<branchname>]
options:
  -d, --delete: Delete a branch.
  -D: Shortcut for --delete --force.
  --create-reflog: Create the branch's reflog.
  -f, --force: Reset <branchname> to <startpoint>, even if <branchname> exists already.
  -m, --move: Move/rename a branch, together with its config and reflog.
  -M: Shortcut for --move --force.
  -c, --copy: Copy a branch, together with its config and reflog.
  -C: Shortcut for --copy --force.
  --color[=<when>]:
    description: Color branches to highlight current, local, and remote-tracking branches.
    values:
      - always
      - never
      - auto
  --no-color: Turn off branch colors, even when the configuration file gives the default to color output. Same as --color=never.
  -i, --ignore-case: Sorting and filtering branches are case insensitive.
  --column[=<options>]:
    description: Display branch listing in columns.
    values:
      - always: always show in columns
      - auto: show in columns if the output is to the terminal
      - never: never show in columns
      - column: fill columns before rows
      - row: fill rows before columns
      - plain: show in one column
      - dense: make unequal size columns to utilize more space
      - nodense: make equal size columns
  --no-column: Hide branch listing in columns.
  -r, --remotes: List or delete (if used with -d) the remote-tracking branches. Combine with --list to match the optional pattern(s).
  -a, --all: List both remote-tracking branches and local branches. Combine with --list to match optional pattern(s).
  -l, --list: List branches. With optional <pattern>...
  --show-current: Print the name of the current branch. In detached HEAD state, nothing is printed.
  -v, -vv, --verbose: When in list mode, show sha1 and commit subject line for each head, along with relationship to upstream branch (if any).
  -q, --quiet: Be more quiet when creating or deleting a branch, suppressing non-error messages.
  --abbrev=<n>: In the verbose listing that show the commit object name, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object.
  --no-abbrev: Display the full sha1s in the output listing rather than abbreviating them.
  -t, --track[=(direct|inherit)]:
    description: Set "upstream" tracking configuration for the new branch.
    values:
      - direct: Use the start-point branch
      - inherit: copy the upstream configuration
  --no-track: Do not set up "upstream" configuration, even if the branch.autoSetupMerge configuration variable is set.
  --recurse-submodules: Causes the current command to recurse into submodules if submodule.propagateBranches is enabled.
  --set-upstream: No longer supported. Please use --track or --set-upstream-to instead.
  -u <upstream>, --set-upstream-to=<upstream>: Set up <branchname>'s tracking information so <upstream> is considered <branchname>'s upstream branch. If no <branchname> is specified, then it defaults to the current branch.
  --unset-upstream: Remove the upstream information for <branchname>. If no branch is specified it defaults to the current branch.
  --edit-description: Open an editor and edit the text to explain what the branch is for, to be used by various other commands.
  --contains [<commit>]: Only list branches which contain the specified commit (HEAD if not specified). Implies --list.
  --no-contains [<commit>]: Only list branches which don't contain the specified commit (HEAD if not specified). Implies --list.
  --merged [<commit>]: Only list branches whose tips are reachable from the specified commit (HEAD if not specified). Implies --list.
  --no-merged [<commit>]: Only list branches whose tips are not reachable from the specified commit (HEAD if not specified). Implies --list.
  --sort=<key>: Sort based on the key given.
  --points-at <object>: Only list branches of the given object.
  --format <format>: A string that interpolates %(fieldname) from a branch ref being shown and the object it points at.