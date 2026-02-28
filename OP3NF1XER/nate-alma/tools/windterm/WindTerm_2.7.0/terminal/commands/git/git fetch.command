description:
  Download objects and refs from another repository
synopses:
  - git fetch [<options>] [<repository> [<refspec>…​]]
  - git fetch [<options>] <group>
  - git fetch --multiple [<options>] [(<repository> | <group>)…​]
  - git fetch --all [<options>]
options:
  --all: Fetch all remotes.
  -a, --append: Append ref names and object names of fetched refs to the existing contents of .git/FETCH_HEAD.
  --atomic: Use an atomic transaction to update local refs.
  --depth=<depth>: Limit fetching to the specified number of commits from the tip of each remote branch history.
  --deepen=<depth>: Similar to --depth, except it specifies the number of commits from the current shallow boundary instead of from the tip of each remote branch history.
  --shallow-since=<date>: Deepen or shorten the history of a shallow repository to include all reachable commits after <date>.
  --shallow-exclude=<revision>: Deepen or shorten the history of a shallow repository to exclude commits reachable from a specified remote branch or tag. This option can be specified multiple times.
  --unshallow: If the source repository is complete, convert a shallow repository to a complete one, removing all the limitations imposed by shallow repositories.
  --update-shallow: Updates .git/shallow and accept such refs.
  --negotiation-tip=<commit|glob>:
    description: Only report commits reachable from the given tips.
    values:
      - commit
      - glob
  --negotiate-only: Do not fetch anything from the server, and instead print the ancestors of the provided --negotiation-tip=* arguments, which we have in common with the server.
  --dry-run: Show what would be done, without making any changes.
  --write-fetch-head: Write the list of remote refs fetched in the FETCH_HEAD file directly under $GIT_DIR.
  --no-write-fetch-head: Do not Write the list of remote refs fetched in the FETCH_HEAD file directly under $GIT_DIR.
  -f, --force: When git fetch is used with <src>:<dst> refspec it may refuse to update the local branch. This option overrides that check.
  -k, --keep: Keep downloaded pack.
  --multiple: Allow several <repository> and <group> arguments to be specified. No <refspec>s may be specified.
  --auto-maintenance, --no-auto-maintenance: Run git maintenance run --auto at the end to perform automatic repository maintenance if needed.
  --auto-gc, --no-auto-gc: Run git maintenance run --auto at the end to perform automatic repository maintenance if needed.
  --write-commit-graph, --no-write-commit-graph: Write a commit-graph after fetching.
  --prefetch: Modify the configured refspec to place all refs into the refs/prefetch/ namespace.
  -p, --prune: Before fetching, remove any remote-tracking references that no longer exist on the remote.
  -P, --prune-tags: Before fetching, remove any local tags that no longer exist on the remote if --prune is enabled.
  -n, --no-tags: By default, tags that point at objects that are downloaded from the remote repository are fetched and stored locally. This option disables this automatic tag following.
  --refetch: Instead of negotiating with the server to avoid transferring commits and associated objects that are already present locally, this option fetches all objects as a fresh clone would.
  --refmap=<refspec>: When fetching refs listed on the command line, use the specified refspec (can be given more than once) to map the refs to remote-tracking branches, instead of the values of remote.*.fetch configuration variables for the remote repository.
  -t, --tags: Fetch all tags from the remote, in addition to whatever else would otherwise be fetched.
  --recurse-submodules[=yes|on-demand|no]:
    description: This option controls if and under what conditions new commits of submodules should be fetched too.
    values:
      - yes
      - no-demand
      - no
  -j <n>, --jobs=<n>: Number of parallel children to be used for all forms of fetching.
  --no-recurse-submodules: Disable recursive fetching of submodules.
  --set-upstream: If the remote is fetched successfully, add upstream reference.
  --submodule-prefix=<path>: Prepend <path> to paths printed in informative messages such as "Fetching submodule foo".
  --recurse-submodules-default=[yes|on-demand]:
    description: This option is used internally to temporarily provide a non-negative default value for the --recurse-submodules option.
    values:
      - yes
      - no-demand
  -u, --update-head-ok: By default git fetch refuses to update the head which corresponds to the current branch. This flag disables the check.
  --upload-pack <upload-pack>: When given, and the repository to fetch from is handled by git fetch-pack, --exec=<upload-pack> is passed to the command to specify non-default path for the command run on the other end.
  -q, --quiet: Pass --quiet to git-fetch-pack and silence any other internally used git commands. Progress is not reported to the standard error stream.
  -v, --verbose: Be verbose.
  --progress: Progress status is reported on the standard error stream by default when it is attached to a terminal.
  -o <option>, --server-option=<option>: Transmit the given string to the server when communicating using protocol version 2. The given string must not contain a NUL or LF character.
  --show-forced-updates: By default, git checks if a branch is force-updated during fetch. This can be disabled through fetch.showForcedUpdates, but the --show-forced-updates option guarantees this check occurs.
  --no-show-forced-updates: By default, git checks if a branch is force-updated during fetch. Pass --no-show-forced-updates or set fetch.showForcedUpdates to false to skip this check for performance reasons.
  -4, --ipv4: Use IPv4 addresses only, ignoring IPv6 addresses.
  -6, --ipv6: Use IPv6 addresses only, ignoring IPv4 addresses.
  --stdin: Read refspecs, one per line, from stdin in addition to those provided as arguments.